
// C++-ified SVD example from
// https://docs.nvidia.com/cuda/cusolver/index.html#svd_examples

#include <cuda.h>
#include <cuda_runtime.h>
#include <curand.h>
#include <cusolverDn.h>

#include <cassert>
#include <iostream>
#include <vector>

inline void printMatrix(int m, int n, const double* A, int rows_A, const char* name)
{
    for (int row = 0; row < m; row++)
    {
        for (int col = 0; col < n; col++)
        {
            std::cout << name << "(" << row + 1 << ", " << col + 1
                      << ") = " << A[row + col * rows_A] << '\n';
        }
    }
}

inline void check(cudaError_t&& error)
{
    if (error != cudaSuccess)
    {
        throw std::domain_error("CUDA error");
    }
}

inline void check(cublasStatus_t&& status)
{
    if (status != CUBLAS_STATUS_SUCCESS)
    {
        throw std::domain_error("Cuda BLAS error");
    }
}

inline void check(cusolverStatus_t&& status)
{
    if (status != CUSOLVER_STATUS_SUCCESS)
    {
        throw std::domain_error("Cuda SOLVER error");
    }
}

inline void check(curandStatus_t&& status)
{
    if (status != CURAND_STATUS_SUCCESS)
    {
        throw std::domain_error("Cuda RAND error");
    }
}

class gpu_matrix
{
public:
    gpu_matrix(int64_t rows, int64_t columns)
    {
        m = rows;
        n = columns;
        lda = rows;
        check(cudaMalloc((void**)&device_matrix, sizeof(double) * m * n));
    };
    auto data() { return device_matrix; };
    auto rows() { return m; };
    auto columns() { return n; };
    auto leading_dimension() { return lda; };

private:
    double* device_matrix = nullptr;
    int64_t m;
    int64_t n;
    int64_t lda;
};

// compute C = alpha * A * B + beta * C (double real matrices)
void gpu_matrix_multiplication(cublasHandle_t cublas_handle,
                               gpu_matrix A,
                               bool A_is_transposed,
                               gpu_matrix B,
                               bool B_is_transposed,
                               gpu_matrix C,
                               const double alpha = 1,
                               const double beta = 0)
{
    check(cublasDgemm(cublas_handle,
                      (A_is_transposed) ? CUBLAS_OP_T : CUBLAS_OP_N,
                      (B_is_transposed) ? CUBLAS_OP_T : CUBLAS_OP_N,
                      A.rows(),
                      B.columns(),
                      A.rows(),
                      &alpha,
                      A.data(),
                      A.leading_dimension(),
                      B.data(),
                      B.leading_dimension(),
                      &beta,
                      C.data(),
                      C.leading_dimension()));
}

int main(int argc, char* argv[])
{
    cusolverDnHandle_t cusolverH = nullptr;
    cublasHandle_t cublasH = nullptr;
    cudaStream_t stream = nullptr;
    gesvdjInfo_t gesvdj_params = nullptr;

    const int rows_A = 3;
    const int cols_A = 2;
    const int modes = std::min(cols_A, 2);

    ///       | 1 2  |
    ///   A = | 4 5  |
    ///       | 2 1  |
    std::vector<double> A = {1.0, 4.0, 2.0, 2.0, 5.0, 1.0};
    // m-by-m unitary matrix, left singular vectors
    std::vector<double> U(rows_A * rows_A);
    // n-by-n unitary matrix, right singular vectors
    std::vector<double> V(cols_A * cols_A);
    // numerical singular value
    std::vector<double> S(cols_A);
    // exact singular values
    std::vector<double> const S_exact = {7.065283497082729, 1.040081297712078};

    // device copy of A
    double* d_A = nullptr;
    // singular values
    double* d_S = nullptr;
    // left singular vectors
    double* d_U = nullptr;
    // right singular vectors
    double* d_V = nullptr;
    // error info
    int* d_info = nullptr;

    // devie workspace for gesvdj
    double* d_work = nullptr;
    // host copy of error info
    int info = 0;

    // configuration of gesvdj
    constexpr double tol = 1.e-7;
    constexpr int max_sweeps = 15;

    // compute eigenvectors
    const cusolverEigMode_t jobz = CUSOLVER_EIG_MODE_VECTOR;
    // econ = 1 for economy size
    constexpr int econ = 0;

    // numerical results of gesvdj
    double residual = 0.0;

    int executed_sweeps = 0;

    std::cout << "example of gesvdj \n";
    printf("tol = %E, default value is machine zero \n", tol);
    printf("max. sweeps = %d, default value is 100\n", max_sweeps);
    printf("econ = %d \n", econ);

    std::cout << "A = (matlab base-1)\n";
    printMatrix(rows_A, cols_A, A.data(), rows_A, "A");
    std::cout << "=====\n";

    // step 1: create cusolver handle, bind a stream
    check(cusolverDnCreate(&cusolverH));
    check(cublasCreate(&cublasH));
    check(cudaStreamCreateWithFlags(&stream, cudaStreamNonBlocking));
    check(cusolverDnSetStream(cusolverH, stream));

    // step 2: configuration of gesvdj
    check(cusolverDnCreateGesvdjInfo(&gesvdj_params));
    // default value of tolerance is machine zero
    check(cusolverDnXgesvdjSetTolerance(gesvdj_params, tol));
    // default value of max. sweeps is 100
    check(cusolverDnXgesvdjSetMaxSweeps(gesvdj_params, max_sweeps));

    // step 3: copy to device
    check(cudaMalloc((void**)&d_A, sizeof(double) * rows_A * cols_A));
    check(cudaMalloc((void**)&d_S, sizeof(double) * cols_A));
    check(cudaMalloc((void**)&d_U, sizeof(double) * rows_A * rows_A));
    check(cudaMalloc((void**)&d_V, sizeof(double) * cols_A * cols_A));
    check(cudaMalloc((void**)&d_info, sizeof(int)));

    check(cudaMemcpy(d_A, A.data(), sizeof(double) * rows_A * cols_A, cudaMemcpyHostToDevice));

    std::cout << "random number generator\n";

    double* d_random = nullptr;
    int rows_random = cols_A;
    int cols_random = modes;
    check(cudaMalloc((void**)&d_random, rows_random * cols_random * sizeof(double)));

    curandGenerator_t gen;
    /* Create pseudo-random number generator */
    check(curandCreateGenerator(&gen, CURAND_RNG_PSEUDO_DEFAULT));

    /* Set seed */
    check(curandSetPseudoRandomGeneratorSeed(gen, 1234ULL));

    /* Generate n floats on device */
    check(curandGenerateUniformDouble(gen, d_random, rows_random * cols_random));

    std::cout << "compute approximate basis\n";

    double alpha = 1.0;
    double beta = 0.0;

    gpu_matrix g_basis(rows_A, modes);
    std::cout << "/* message */" << g_basis.rows() << '\n';
    std::cout << "/* message */" << g_basis.columns() << '\n';
    std::cout << "/* ------------------------------------------- */" << '\n';

    double* d_basis = nullptr;
    int rows_basis = rows_A;
    int cols_basis = modes;
    check(cudaMalloc((void**)&d_basis, sizeof(double) * rows_basis * cols_basis));

    check(cublasDgemm(cublasH,
                      CUBLAS_OP_N,
                      CUBLAS_OP_N,
                      rows_basis,
                      cols_basis,
                      cols_A,
                      &alpha,
                      d_A,
                      rows_A,
                      d_random,
                      rows_random,
                      &beta,
                      d_basis,
                      rows_basis));

    std::cout << "orthonormalise the approximate basis\n";
    // perform QR decomposition on d_basis
    int lwork = 0;
    check(cusolverDnDgeqrf_bufferSize(cusolverH, rows_basis, cols_basis, d_basis, rows_basis, &lwork));
    check(cudaMalloc((void**)&d_work, sizeof(double) * lwork));

    double* d_tau = nullptr;
    check(cudaMalloc((void**)&d_tau, sizeof(double) * cols_A));

    check(cusolverDnDgeqrf(cusolverH,
                           rows_basis,
                           cols_basis,
                           d_basis,
                           rows_basis,
                           d_tau,
                           d_work,
                           lwork,
                           d_info));
    // calculate Q
    check(cusolverDnDorgqr_bufferSize(cusolverH,
                                      rows_basis,
                                      cols_basis,
                                      cols_basis,
                                      d_basis,
                                      rows_basis,
                                      d_tau,
                                      &lwork));

    check(cusolverDnDorgqr(cusolverH,
                           rows_basis,
                           cols_basis,
                           cols_basis,
                           d_basis,
                           rows_basis,
                           d_tau,
                           d_work,
                           lwork,
                           d_info));

    std::cout << "restrict A to its "
                 "approximate basis\n";

    double* d_A_reduced = nullptr;
    int rows_A_reduced = modes;
    int cols_A_reduced = cols_A;
    check(cudaMalloc((void**)&d_A_reduced, sizeof(double) * rows_A_reduced * cols_A_reduced));

    check(cublasDgemm(cublasH,
                      CUBLAS_OP_T,
                      CUBLAS_OP_N,
                      rows_A_reduced,
                      cols_A_reduced,
                      rows_A,
                      &alpha,
                      d_basis,
                      rows_basis,
                      d_A,
                      rows_A,
                      &beta,
                      d_A_reduced,
                      rows_A_reduced));

    std::cout << "randomised svd solver\n";

    double* d_U_reduced = nullptr;
    int rows_U_reduced = rows_A_reduced;
    int cols_U_reduced = rows_A_reduced;
    check(cudaMalloc((void**)&d_U_reduced, sizeof(double) * rows_U_reduced * cols_U_reduced));

    // size of workspace
    check(cusolverDnDgesvdj_bufferSize(cusolverH,
                                       jobz,
                                       econ,
                                       rows_A_reduced,
                                       cols_A_reduced,
                                       d_A_reduced,
                                       rows_A_reduced,
                                       d_S,
                                       d_U_reduced,
                                       rows_U_reduced,
                                       d_V,
                                       cols_A_reduced,
                                       &lwork,
                                       gesvdj_params));

    check(cudaMalloc((void**)&d_work, sizeof(double) * lwork));

    check(cusolverDnDgesvdj(cusolverH,
                            jobz,
                            econ,
                            rows_A_reduced,
                            cols_A_reduced,
                            d_A_reduced,
                            rows_A_reduced,
                            d_S,
                            d_U_reduced,
                            rows_U_reduced,
                            d_V,
                            cols_A_reduced,
                            d_work,
                            lwork,
                            d_info,
                            gesvdj_params));

    check(cublasDgemm(cublasH,
                      CUBLAS_OP_N,
                      CUBLAS_OP_N,
                      rows_A,
                      rows_A,
                      cols_basis,
                      &alpha,
                      d_basis,
                      rows_basis,
                      d_U_reduced,
                      rows_U_reduced,
                      &beta,
                      d_U,
                      rows_A));

    std::cout << "compare the results & ...\n";
    // TODO

    std::cout << "svd solver\n";
    // step 4: query workspace of SVD

    // size of workspace
    check(cusolverDnDgesvdj_bufferSize(cusolverH,
                                       jobz, // CUSOLVER_EIG_MODE_NOVECTOR:
                                             // compute singular values only
                                       // CUSOLVER_EIG_MODE_VECTOR: compute
                                       // singular value and singular vectors
                                       econ,   // econ = 1 for economy size
                                       rows_A, // nubmer of rows of A, 0 <= m
                                       cols_A, // number of columns of A, 0 <=
                                               // n
                                       d_A,    // m-by-n
                                       rows_A, // leading dimension of A
                                       d_S,    // min(m,n)
                                               // the singular values in
                                               // descending order
                                       d_U,    // m-by-m if econ = 0
                                               // m-by-min(m,n) if econ = 1
                                       rows_A, // leading dimension of U, ldu
                                               // >= max(1,m)
                                       d_V,    // n-by-n if econ = 0
                                               // n-by-min(m,n) if econ = 1
                                       rows_A, // leading dimension of V, ldv
                                               // >= max(1,n)
                                       &lwork,
                                       gesvdj_params));

    check(cudaMalloc((void**)&d_work, sizeof(double) * lwork));

    // step 5: compute SVD
    check(cusolverDnDgesvdj(cusolverH,
                            jobz, // CUSOLVER_EIG_MODE_NOVECTOR:
                                  // compute singular values only
                            // CUSOLVER_EIG_MODE_VECTOR: compute
                            // singular value and singular vectors
                            econ,   // econ = 1 for economy size
                            rows_A, // nubmer of rows of A, 0 <= m
                            cols_A, // number of columns of A, 0 <=
                                    // n
                            d_A,    // m-by-n
                            rows_A, // leading dimension of A
                            d_S,    // min(m,n)
                                    // the singular values in
                                    // descending order
                            d_U,    // m-by-m if econ = 0
                                    // m-by-min(m,n) if econ = 1
                            rows_A, // leading dimension of U, ldu
                                    // >= max(1,m)
                            d_V,    // n-by-n if econ = 0
                                    // n-by-min(m,n) if econ = 1
                            rows_A, // leading dimension of V, ldv
                                    // >= max(1,n)
                            d_work,
                            lwork,
                            d_info,
                            gesvdj_params));

    check(cudaDeviceSynchronize());

    check(cudaMemcpy(U.data(), d_U, sizeof(double) * rows_A * rows_A, cudaMemcpyDeviceToHost));
    check(cudaMemcpy(V.data(), d_V, sizeof(double) * cols_A * cols_A, cudaMemcpyDeviceToHost));
    check(cudaMemcpy(S.data(), d_S, sizeof(double) * cols_A, cudaMemcpyDeviceToHost));
    check(cudaMemcpy(&info, d_info, sizeof(int), cudaMemcpyDeviceToHost));

    check(cudaDeviceSynchronize());

    if (info == 0)
    {
        std::cout << "gesvdj converges\n";
    }
    else if (0 > info)
    {
        printf("%d-th parameter is wrong \n", -info);
        exit(1);
    }
    else
    {
        printf("WARNING: info = %d : gesvdj did "
               "not converge \n",
               info);
    }

    std::cout << "S = singular values (matlab "
                 "base-1)\n";
    printMatrix(cols_A, 1, S.data(), rows_A, "S");
    std::cout << "=====\n";

    std::cout << "U = left singular vectors "
                 "(matlab base-1)\n";
    printMatrix(rows_A, rows_A, U.data(), rows_A, "U");
    std::cout << "=====\n";

    std::cout << "V = right singular vectors "
                 "(matlab base-1)\n";
    printMatrix(cols_A, cols_A, V.data(), rows_A, "V");
    std::cout << "=====\n";

    /* step 6: measure error of singular value
     */
    double ds_sup = 0.0;
    for (int j = 0; j < cols_A; j++)
    {
        ds_sup = std::max(ds_sup, std::abs(S[j] - S_exact[j]));
    }
    printf("|S - S_exact|_sup = %E \n", ds_sup);

    check(cusolverDnXgesvdjGetSweeps(cusolverH, gesvdj_params, &executed_sweeps));

    check(cusolverDnXgesvdjGetResidual(cusolverH, gesvdj_params, &residual));

    printf("residual |A - U*S*V**H|_F = %E \n", residual);
    printf("number of executed sweeps = %d \n", executed_sweeps);

    if (d_A) cudaFree(d_A);
    if (d_S) cudaFree(d_S);
    if (d_U) cudaFree(d_U);
    if (d_V) cudaFree(d_V);
    if (d_info) cudaFree(d_info);
    if (d_work) cudaFree(d_work);

    if (cusolverH) cusolverDnDestroy(cusolverH);
    if (stream) cudaStreamDestroy(stream);
    if (gesvdj_params) cusolverDnDestroyGesvdjInfo(gesvdj_params);
    if (cublasH) cublasDestroy(cublasH);

    cudaDeviceReset();

    return 0;
}
