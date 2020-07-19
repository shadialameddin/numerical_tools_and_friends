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
#define input prhs[0]
#define output plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  if (!(mxIsStruct(prhs[0]) && mxGetNumberOfFields(prhs[0]) > 0 && (nlhs > 0) &&
        (nrhs > 0))) {
    mexErrMsgIdAndTxt("MATLAB:mexcpp:typeargin",
                      "First argument has to be double scalar.");
    return;
  }

  auto eps_p_bar = mxGetField(prhs[0], 0, "eps_p_bar");
  auto sigma_bar = mxGetField(prhs[0], 0, "sigma_bar");
  auto Hdo = mxGetField(prhs[0], 0, "Hdo");
  auto inv_Hdo = mxGetField(prhs[0], 0, "iHdo");
  auto delta_in = mxGetField(prhs[0], 0, "delta");
  // auto DG_proj = mxGetField(prhs[0], 0, "DG_proj");
  // auto D_operator = mxGetField(prhs[0], 0, "D_operator");
  // auto ntp_in = mxGetField(prhs[0], 0, "ntp");
  auto dt = mxGetField(prhs[0], 0, "dt");
  auto I_g = mxGetField(prhs[0], 0, "I_g");
  auto sgn = mxGetField(prhs[0], 0, "sign");
  auto sign = int(*mxGetPr(sgn));
  auto d_t = double(*mxGetPr(dt));

  auto Hdo_Dimensions = mxGetDimensions(Hdo);
  auto sigma_Dimensions = mxGetDimensions(sigma_bar);
  size_t const ncomp = 6; // TODO 3D only
  if (Hdo_Dimensions[0] != 6)
    mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin", "3D only, ncomp should equal 6.");
  size_t const ngp = Hdo_Dimensions[2];
  size_t const ntp = Hdo_Dimensions[3];
  size_t const nmodes = sigma_Dimensions[1];

  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;
  using matrix6 = Eigen::Matrix<double, 6, 6>;

  // Eigen::Map<Vector> Hdo_v(mxGetPr(Hdo), ntp * ngp * ncomp * ncomp);
  // Eigen::Map<Vector> inv_Hdo_v(mxGetPr(inv_Hdo), ntp * ngp * ncomp * ncomp);
  // Eigen::Map<Vector> delta_v(mxGetPr(delta_in), ntp * ngp * ncomp);
  // Eigen::Map<Vector> sigma_v(mxGetPr(sigma_bar), ngp * ncomp * nmodes);
  // Eigen::Map<Vector> eps_p_v(mxGetPr(eps_p_bar), ngp * ncomp * nmodes);

  // clang-format off
  // time_matrix6_storage H(ntp, gauss_matrix6_storage(ngp, matrix6_storage()));
  // time_matrix6_storage iH(ntp, gauss_matrix6_storage(ngp, matrix6_storage()));
  // time_vector_storage delta(ntp, gauss_vector_storage(ngp, vector_storage(ncomp)));
  // gauss_matrix_storage sigma(ngp, matrix_storage(ncomp, nmodes));
  // gauss_matrix_storage eps_p(ngp, matrix_storage(ncomp, nmodes));
  // clang-format on

  auto const tensor_shift = ncomp * ncomp;
  auto const vector_shift = ncomp * nmodes;
  auto const delta_shift = ncomp;

  // using sparse_matrix = Eigen::SparseMatrix<double, Eigen::RowMajor>;
  // sparse_matrix A(nmodes * ntp, nmodes * ntp);
  // A.reserve(2 * nmodes * nmodes * ntp - (2 * nmodes - 1));
  // A.coeffs() = 0.0;
  Matrix A = Matrix::Zero(nmodes * ntp, nmodes * ntp);
  Vector b = Vector::Zero(ntp * nmodes);

  auto const nel = ntp - 1;

  // TODO
  // std::vector<std::int32_t> dofs(nel);
  // std::generate(begin(dofs), end(dofs), [j = -nmodes] () mutable {
  //      j += nmodes;
  //      return j;
  // });

  std::vector<std::int32_t> dofs;
  for (size_t j = 0; j < nel * nmodes; j += nmodes)
    dofs.push_back(j);

  std::vector<std::int32_t> fixed_dofs;
  for (size_t j = 0; j < nmodes; j++)
    fixed_dofs.push_back(j);

    // how come I don't have race condition here? TODO
    // clang-format off
// #pragma omp parallel for collapse(2)
#pragma omp declare reduction(+ : Eigen::MatrixXd : omp_out =  omp_out + omp_in)
#pragma omp declare reduction(+ : Eigen::VectorXd : omp_out =  omp_out + omp_in)

#pragma omp parallel for
  for (size_t i = 0; i < ntp; i++) {
    Matrix a11 = Matrix::Zero(nmodes, nmodes);
    Matrix a10 = Matrix::Zero(nmodes, nmodes);
    Matrix a00 = Matrix::Zero(nmodes, nmodes);
    Vector d1 = Vector::Zero(nmodes);
    Vector d0 = Vector::Zero(nmodes);


// #pragma omp parallel for reduction(+ : a11,a10,a00,d1,d0)
// #pragma omp parallel for
    for (size_t j = 0; j < ngp; j++) {
      int const int_idx = j * tensor_shift;
      int const tensor_idx = (i * ngp + j) * tensor_shift;
      int const delta_idx = (i * ngp + j) * delta_shift;
      int const vector_idx = j * vector_shift;

      //Hdo_v.segment(tensor_idx, tensor_shift);
      // Eigen::Map<matrix6> Int_space(mxGetPr(I_g));
      matrix6 Int_space = Eigen::Map<matrix6>(mxGetPr(I_g) + int_idx, ncomp, ncomp);
      matrix6 H = Eigen::Map<matrix6>(mxGetPr(Hdo) + tensor_idx, ncomp, ncomp);
      matrix6 iH = Eigen::Map<matrix6>(mxGetPr(inv_Hdo) + tensor_idx);
      Vector delta = Eigen::Map<Vector>(mxGetPr(delta_in) + delta_idx, ncomp);
      Matrix sigma = Eigen::Map<Matrix>(mxGetPr(sigma_bar) + vector_idx, ncomp,nmodes);
      Matrix eps_p = Eigen::Map<Matrix>(mxGetPr(eps_p_bar) + vector_idx, ncomp,nmodes);

      a11.noalias() += eps_p.transpose() * (iH * (Int_space * eps_p)); // TODO noalias
      a10 += -1.0 * sign * eps_p.transpose() * Int_space * sigma;
      a00 += sigma.transpose() * (H * (Int_space * sigma)); // TODO I_g is the same for all elements? shouldn't be
      d1 += -1.0 * sign * eps_p.transpose() * (iH * (Int_space * delta));
      d0 += sigma.transpose() * Int_space * delta;
    }

    Matrix t11 = a11 / (d_t * d_t); // TODO use cwiseQuotient
    Matrix t12 = a10 / (d_t);       //   a01 = a10;
    Matrix t22 = t11 + t12 + t12 + a00;
    t12 = -t12 - t11;
    Vector b0 = -d1 / (d_t);
    Vector b1 = d1 / (d_t) + d0;

    if (i>0) { //for (size_t i = 0; i < nel; i++) {
      Matrix a_el(2 * nmodes, 2 * nmodes);
      Vector b_el(2 * nmodes);

      a_el << t11, t12,
              t12, t22;

      b_el << b0,
              b1; // TODO use I_time

//       for (size_t j = 0; j < 2 * nmodes; j++) {
//         for (size_t k = 0; k < 2 * nmodes; k++) {
// #pragma omp critical
//           A.coeffRef(dofs[i-1]+j, dofs[i-1]+k) += a_el(j,k);
//         }
//       }
//       for (size_t j = 0; j < 2 * nmodes; j++) {
// #pragma omp atomic
//           b.coeffRef(dofs[i-1]+j) += b_el(j);
//       }

#pragma omp critical
{
      A.block(dofs[i-1], dofs[i-1], 2 * nmodes, 2 * nmodes) += a_el; // TODO this assembly is not final
      b.segment(dofs[i-1], 2 * nmodes) += b_el;
}
    }
  }
  // clang-format on

  for (auto const fixed_dof : fixed_dofs) {
    auto const diagonal_entry = A.coeff(fixed_dof, fixed_dof); // TODO // sparse

    b(fixed_dof) = 0.0;

    std::vector<std::int64_t> non_zero_visitor;

    // // Zero the rows and columns
    // for (sparse_matrix::InnerIterator it(A, fixed_dof); it; ++it) {
    //   // Set the value of the col or row resp. to zero
    //   it.valueRef() = 0.0;
    //   non_zero_visitor.push_back(A.IsRowMajor ? it.col() : it.row());
    // }
    // // Zero the row or col respectively
    // for (auto const &non_zero : non_zero_visitor) {
    //   const auto row = A.IsRowMajor ? non_zero : fixed_dof;
    //   const auto col = A.IsRowMajor ? fixed_dof : non_zero;
    //
    //   A.coeffRef(row, col) = 0.0;
    // }
    for (int i = 0; i < A.rows(); i++) {
      for (int j = 0; j < A.cols(); j++) {
        A.coeffRef(fixed_dof, j) = 0.0;
        A.coeffRef(i, fixed_dof) = 0.0;
      }
    }
    // Reset the diagonal to the same value to preserve conditioning
    A.coeffRef(fixed_dof, fixed_dof) = diagonal_entry;
  }

  // TODO //Vector x = (b.norm() > 0.0) ? A.partialPivLu().solve(b)

  Vector x;
  if (b.norm() > 0)
    x = A.partialPivLu().solve(b); // fullPivLu
  else {
    x = b;
  }
  // Eigen::SimplicialCholesky<Eigen::SparseMatrix<double>> chol(
  //     A); // performs a Cholesky factorization of A
  // Eigen::SimplicialLDLT<Eigen::SparseMatrix<double>> chol(
  //     A); // performs a Cholesky factorization of A
  // Eigen::VectorXd x = chol.solve(
  //     b); // use the factorization to solve for the given right hand side

  output = mxCreateDoubleMatrix(nmodes, ntp, mxREAL);
  auto out_pt = mxGetPr(output);
  Eigen::Map<Eigen::MatrixXd> mapp(out_pt, nmodes, ntp);
  mapp = x; // copy
  // std::copy(x.begin(), x.end(), mxGetPr(output));
  return;
}

// mxArray *cpp_to_MexArray(const std::vector<double> &v) {
//   mxArray *mx = mxCreateDoubleMatrix(1, v.size(), mxREAL);
//   std::copy(v.begin(), v.end(), mxGetPr(mx));
//
//   return mx;
// }
