// clang-format off
// mex -I"/usr/include/eigen3" ...
// -I"/usr/local/include" '-LC:/usr/local/lib/' -llibpastix.so direct_solver_mex.cpp
// clang-format on
// g++ -I"/usr/include/eigen3" -L/usr/lib64/ -lpastix testpastix.cpp

// direct_solver(sparse(2*eye(3)),sparse([1 0 0]'))
// #include "tbb/parallel_for.h"

#include <iostream>
#include <limits>
#include <mex.h>
#include <omp.h>
#include <type_traits>
#include <vector>

#include <eigen3/Eigen/Core>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/PaStiXSupport>
#include <eigen3/Eigen/Sparse>
#include <eigen3/Eigen/SparseCholesky>
#include <eigen3/Eigen/SparseLU>
#include <eigen3/Eigen/SparseQR>

#define A_raw prhs[0]
#define b_raw prhs[1]
#define A_ptr mxGetPr(prhs[0])

#define output plhs[0]

using namespace Eigen;

typedef SparseMatrix<double, ColMajor, std::make_signed<mwIndex>::type>
    MatlabSparse;

Map<MatlabSparse> matlab_to_eigen_sparse(const mxArray *mat) {
  mxAssert(mxGetClassID(mat) == mxDOUBLE_CLASS,
           "Type of the input matrix isn't double");
  mwSize m = mxGetM(mat);
  mwSize n = mxGetN(mat);
  mwSize nz = mxGetNzmax(mat);
  /*Theoretically fails in very very large matrices*/
  mxAssert(nz <= std::numeric_limits<std::make_signed<mwIndex>::type>::max(),
           "Unsupported Data size.");
  double *pr = mxGetPr(mat);
  MatlabSparse::StorageIndex *ir =
      reinterpret_cast<MatlabSparse::StorageIndex *>(mxGetIr(mat));
  MatlabSparse::StorageIndex *jc =
      reinterpret_cast<MatlabSparse::StorageIndex *>(mxGetJc(mat));
  Map<MatlabSparse> result(m, n, nz, jc, ir, pr);
  return result;
}

mxArray *eigen_to_matlab_sparse(
    const Ref<const MatlabSparse, StandardCompressedFormat> &mat) {
  mxArray *result =
      mxCreateSparse(mat.rows(), mat.cols(), mat.nonZeros(), mxREAL);
  const MatlabSparse::StorageIndex *ir = mat.innerIndexPtr();
  const MatlabSparse::StorageIndex *jc = mat.outerIndexPtr();
  const double *pr = mat.valuePtr();

  mwIndex *ir2 = mxGetIr(result);
  mwIndex *jc2 = mxGetJc(result);
  double *pr2 = mxGetPr(result);

  for (mwIndex i = 0; i < mat.nonZeros(); i++) {
    pr2[i] = pr[i];
    ir2[i] = ir[i];
  }
  for (mwIndex i = 0; i < mat.cols() + 1; i++) {
    jc2[i] = jc[i];
  }
  return result;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // TODO: is the stiffness fixed or changing (sparsity or everything?)
  using sparse_matrix = Eigen::SparseMatrix<double, Eigen::ColMajor>;
  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;

  auto A_Dimensions = mxGetDimensions(A_raw);
  size_t const row = A_Dimensions[0];
  size_t const col = A_Dimensions[1];

  Map<MatlabSparse> A = matlab_to_eigen_sparse(A_raw);
  auto b = matlab_to_eigen_sparse(b_raw);

  std::cout << A << std::endl;
  std::cout << typeid(A).name() << std::endl;

  Eigen::SimplicialLLT<Eigen::SparseMatrix<double>> solver;
  // Eigen::PastixLU<Eigen::SparseMatrix, true> solver;
  solver.analyzePattern(A);
  solver.factorize(A);
  auto space_mode = solver.solve(b);

  // auto space_mode = b;
  output = mxCreateDoubleMatrix(row, 1, mxREAL);
  Eigen::Map<Matrix>(mxGetPr(output), row, 1) = space_mode;

  return;
}
