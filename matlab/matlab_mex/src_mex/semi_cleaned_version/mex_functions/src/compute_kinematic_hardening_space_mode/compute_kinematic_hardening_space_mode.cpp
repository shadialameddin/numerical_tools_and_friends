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
#define Hdo prhs[0]
#define inv_Hdo prhs[1]
#define sign int(*mxGetPr(prhs[2]))
#define C_operator double(*mxGetPr(prhs[3]))
#define I_t prhs[4]
#define d_alpha_in prhs[5]
#define alpha_in prhs[6]
#define delta_in prhs[7]

#define output plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

  auto Hdo_Dimensions = mxGetDimensions(Hdo);
  auto alpha_Dimensions = mxGetDimensions(alpha_in);

  size_t const ncomp = 6; // TODO 3D only
  size_t const ngp = Hdo_Dimensions[2];
  size_t const ntp = Hdo_Dimensions[3];
  size_t const nmodes = alpha_Dimensions[1];

  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;
  using matrix6 = Eigen::Matrix<double, 6, 6>;

  Eigen::Map<Eigen::MatrixXd> Int_time(mxGetPr(I_t), ntp, ntp);

  auto const tensor_shift = ncomp * ncomp;
  auto const delta_shift = ncomp;

  Matrix A = Matrix::Zero(nmodes * ntp, nmodes * ntp);
  Vector b = Vector::Zero(ntp * nmodes);

  Vector alpha = Eigen::Map<Vector>(mxGetPr(alpha_in), ntp);
  Vector d_alpha = Eigen::Map<Vector>(mxGetPr(d_alpha_in), ntp);

  // A
  Vector int_C_C_alpha_alpha =
      pow(C_operator, 2) * Int_time * (alpha.cwiseProduct(alpha));
  double int_C_alpha_d_alpha =
      C_operator * alpha.transpose() * (Int_time * d_alpha);
  Vector int_d_alpha_d_alpha = (Int_time * d_alpha.cwiseProduct(d_alpha));

  // b
  Vector int_C_alpha = C_operator * (Int_time * alpha);
  Vector int_d_alpha = (Int_time * d_alpha);

  Vector space_mode = Vector::Zero(ngp * ncomp);
  Matrix a2 = 2 * int_C_alpha_d_alpha * Matrix::Identity(ncomp, ncomp);

  // #pragma omp parallel for
  for (size_t i = 0; i < ngp; i++) {
    Matrix a1 = Matrix::Zero(ncomp, ncomp);
    Matrix a3 = Matrix::Zero(ncomp, ncomp);
    Matrix A = Matrix::Zero(ncomp, ncomp);

    Vector b1 = Vector::Zero(ncomp);
    Vector b2 = Vector::Zero(ncomp);
    Vector b = Vector::Zero(ncomp);

    for (size_t j = 0; j < ntp; j++) {

      int const delta_idx = (j * ngp + i) * delta_shift;
      int const tensor_idx = (j * ngp + i) * tensor_shift;

      matrix6 H = Eigen::Map<matrix6>(mxGetPr(Hdo) + tensor_idx);
      matrix6 iH = Eigen::Map<matrix6>(mxGetPr(inv_Hdo) + tensor_idx);
      Vector delta = Eigen::Map<Vector>(mxGetPr(delta_in) + delta_idx, ncomp);

      a1 += H * int_C_C_alpha_alpha(j);
      a3 += iH * int_d_alpha_d_alpha(j);
      b1 += delta * int_C_alpha(j);
      b2 += (iH * delta) * int_d_alpha(j);
    }

    A = a1 - sign * a2 + a3;
    b = b1 - sign * b2;

#pragma omp critical
    if (b.norm() > 0)
      space_mode.segment(i * ncomp, ncomp) = A.partialPivLu().solve(b);
    else
      space_mode.segment(i * ncomp, ncomp) = b;
  }

  output = mxCreateDoubleMatrix(ngp * ncomp, 1, mxREAL);
  auto out_pt = mxGetPr(output);
  Eigen::Map<Eigen::MatrixXd> mapp(out_pt, ngp * ncomp, 1);
  mapp = space_mode; // copy
  // std::copy(x.begin(), x.end(), mxGetPr(output));
  return;
}

// mxArray *cpp_to_MexArray(const std::vector<double> &v) {
//   mxArray *mx = mxCreateDoubleMatrix(1, v.size(), mxREAL);
//   std::copy(v.begin(), v.end(), mxGetPr(mx));
//
//   return mx;
// }
