#include "tbb/parallel_for.h"
#include <iostream>
#include <mex.h>
#include <omp.h>
#include <vector>

#include <eigen3/Eigen/Core>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Sparse>
// #include <Eigen/StdVector>

// #include <range/v3/all.hpp>
// #include <range/v3/core.hpp>

// #include "storage_aliases.h"

// #define ngp int(*mxGetPr(prhs[0]))

#define int_space_ptr mxGetPr(prhs[0])
#define delta_ptr mxGetPr(prhs[1])
#define Hdo_raw prhs[2]
#define Hdo_ptr mxGetPr(prhs[2])
#define int_time_ptr mxGetPr(prhs[3])
#define d_alpha_ptr mxGetPr(prhs[4])
#define alpha_ptr mxGetPr(prhs[5])
#define inv_hooke_ptr mxGetPr(prhs[6])
#define gradient_ptr mxGetPr(prhs[7])
#define dof_imposed_raw prhs[8]
#define dof_imposed_ptr mxGetPr(prhs[8])
#define inv_hooke_full_ptr mxGetPr(prhs[9])
#define gradient_width int(*mxGetPr(prhs[10]))

#define output plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  // auto t1 = omp_get_wtime();
  using sparse_matrix = Eigen::SparseMatrix<double, Eigen::RowMajor>;
  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;
  using matrix6 = Eigen::Matrix<double, 6, 6>;
  using vector6 = Eigen::Matrix<double, 6, 1>;

  auto Hdo_Dimensions = mxGetDimensions(Hdo_raw);
  auto dof_imposed_Dimensions = mxGetDimensions(dof_imposed_raw);
  size_t const ncomp = 6; // TODO 3D only
  size_t const ngp = Hdo_Dimensions[2];
  size_t const ntp = Hdo_Dimensions[3];
  size_t const ndof_imp = dof_imposed_Dimensions[0];
  size_t const tensor_shift = ncomp * ncomp;
  size_t const delta_shift = ncomp;

  Vector alpha = Eigen::Map<Vector>(alpha_ptr, ntp);
  Vector d_alpha = Eigen::Map<Vector>(d_alpha_ptr, ntp);
  Eigen::Map<Matrix> int_time(int_time_ptr, ntp, ntp);
  Eigen::Map<Matrix> gradient(gradient_ptr, ngp * ncomp, gradient_width);
  Eigen::Map<matrix6> inv_hooke(inv_hooke_ptr);
  Eigen::Map<Matrix> inv_hooke_full(inv_hooke_full_ptr, ngp * ncomp,
                                    ngp * ncomp);
  std::vector<std::int32_t> fixed_dofs;
  for (size_t j = 0; j < ndof_imp; j++)
    fixed_dofs.push_back(*(dof_imposed_ptr + j));

  sparse_matrix A(ncomp * ngp, ncomp * ngp);
  sparse_matrix A_noint(ncomp * ngp, ncomp * ngp);
  Vector b(ngp * ncomp);
  Vector Q3_vec(ngp * ncomp);
  Vector space_mode(ngp * ncomp);

  double int_alpha_d_alpha = alpha.transpose() * int_time * d_alpha;
  Vector int_alpha_alpha = int_time * alpha.cwiseProduct(alpha);
  Vector int_alpha = int_time * alpha;
  Vector int_d_alpha = int_time * d_alpha;
  // auto t2 = omp_get_wtime();
  // std::cout << " /* block1 */ " << t2 - t1 << '\n';

  // t1 = omp_get_wtime();
  // #pragma omp parallel for
  for (size_t i = 0; i < ngp; i++) {
    size_t const position = i * ncomp;
    size_t const int_idx = i * tensor_shift;
    matrix6 B = matrix6::Zeros();
    vector6 Q3 = vector6::Zeros();

    // #pragma omp parallel for
    for (size_t j = 0; j < ntp; j++) {
      int const delta_idx = (j * ngp + i) * delta_shift;
      int const tensor_idx = (j * ngp + i) * tensor_shift;
      matrix6 H = Eigen::Map<matrix6>(Hdo_ptr + tensor_idx);
      vector6 delta = Eigen::Map<vector6>(delta_ptr + delta_idx);
      B.noalias() += H * int_alpha_alpha(j);
      Q3 += delta * int_alpha(j);
    }

    matrix6 Int_space = Eigen::Map<matrix6>(int_space_ptr + int_idx, ncomp,
                                            ncomp); // TODO: alligned
    matrix6 Z = (B + int_alpha_d_alpha * inv_hooke).inverse();
    matrix6 int_Z = Int_space * Z;

    // #pragma omp critical
    for (size_t k = 0; k < ncomp; k++) {
      for (size_t l = 0; l < ncomp; l++) {
        A.insert(position + k, position + l) = int_Z(k, l);
        A_noint.insert(position + k, position + l) = Z(k, l);
      }
    }
    b.segment<6>(position) = -int_Z * Q3;
    Q3_vec.segment<6>(position) = Q3;
  }
  // t2 = omp_get_wtime();
  // std::cout << " /* block2 */ " << t2 - t1 << '\n';

  // t1 = omp_get_wtime();
  Matrix K = gradient.transpose() * A * gradient;
  Vector F = gradient.transpose() * b;
  for (auto const fixed_dof : fixed_dofs) {
    auto const diagonal_entry = K.coeff(fixed_dof, fixed_dof); // TODO //
    F(fixed_dof) = 0.0;
    for (int i = 0; i < K.rows(); i++) {
      for (int j = 0; j < K.cols(); j++) {
        K.coeffRef(fixed_dof, j) = 0.0;
        K.coeffRef(i, fixed_dof) = 0.0; // TODO K.row(i)=0;
      }
    }
    K.coeffRef(fixed_dof, fixed_dof) = diagonal_entry;
  }
  // if (b.norm() > 0)
  auto U_tilde = K.llt().solve(F); // TODO: is this ok?
  // else {
  //   U_tilde = F;
  // }
  //   t2 = omp_get_wtime();
  //   std::cout << " /* block3 */ " << t2 - t1 << '\n';

  // t1 = omp_get_wtime();
  auto E_tilde = gradient * U_tilde;
  auto sigma = A_noint * (E_tilde + Q3_vec);
  space_mode = E_tilde / int_alpha_d_alpha - inv_hooke_full * sigma;
  // t2 = omp_get_wtime();
  // std::cout << " /* block4 */ " << t2 - t1 << '\n';

  // t1 = omp_get_wtime();
  output = mxCreateDoubleMatrix(ngp * ncomp, 1, mxREAL);
  Eigen::Map<Matrix>(mxGetPr(output), ngp * ncomp, 1) = space_mode;
  // t2 = omp_get_wtime();
  // std::cout << " /* block5 */ " << t2 - t1 << '\n';

  return;
}

// mxArray *cpp_to_MexArray(const std::vector<double> &v) {
//   mxArray *mx = mxCreateDoubleMatrix(1, v.size(), mxREAL);
//   std::copy(v.begin(), v.end(), mxGetPr(mx));
//
//   return mx;
// }
