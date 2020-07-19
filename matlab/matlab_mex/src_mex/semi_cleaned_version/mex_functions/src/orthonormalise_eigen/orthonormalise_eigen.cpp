// #include "mex.h"
// #include "matrix.h"
#include "mxarray.h"
#include <mex.h>

#include <Eigen/Eigen>

#include <range/v3/all.hpp>
// #include <range/v3/core.hpp>

#include <iostream>
#include <vector>
// #include "matrix.h"
#include "tbb/parallel_for.h"
#include <omp.h>
// #include <tbb/tbb.h>
#include <typeinfo>
// #include <eigen3/Eigen/CXX11/Tensor>
// #include <unsupported/eigen3/Eigen/CXX11/Tensor>
// #include <Eigen/src/Core/util/DisableStupidWarnings.h>
// #include <Eigen/Tensor>
#include "storage_aliases.h"
#include <unsupported/Eigen/CXX11/Tensor>

// #define ngp int(*mxGetPr(prhs[0]))
#define input prhs[0]
#define output plhs[0]

typedef Eigen::Map<Eigen::MatrixXd> MexMat;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  if (nrhs != 2) {
    mexErrMsgTxt("Needs 2 arguments -- X (NxD), Y (DxM)");
    return;
  }

  int N = mxGetM(prhs[0]);
  int D = mxGetN(prhs[0]);

  int P = mxGetM(prhs[1]);
  int M = mxGetN(prhs[1]);

  if ((N != P) || (P != M)) {
    mexErrMsgTxt("X #cols needs to match Y #rows!");
    return;
  }

  MexMat U(mxGetPr(prhs[0]), N, D);
  MexMat MM(mxGetPr(prhs[1]), P, M);

  // compute the Cholesky decomposition of A
  Eigen::MatrixXd L =
      MM.llt().matrixL(); // retrieve factor L  in the decomposition
  // << A.jacobiSvd(ComputeThinU | ComputeThinV).solve(b) << endl;

  Eigen::JacobiSVD<Eigen::MatrixXd> svd(
      U, Eigen::DecompositionOptions::ComputeThinU |
             Eigen::DecompositionOptions::ComputeThinV);
  svd.setThreshold(1e-14);

  // Create output matrix (using Matlab's alloc)
  int const number_singular_values = svd.singularValues().size();
  plhs[0] = mxCreateDoubleMatrix(N, number_singular_values, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(number_singular_values, D, mxREAL);
  plhs[2] = mxCreateDoubleMatrix(number_singular_values, number_singular_values,
                                 mxREAL);
  MexMat R(mxGetPr(plhs[0]), N, number_singular_values);
  MexMat V(mxGetPr(plhs[1]), number_singular_values, D);
  MexMat S(mxGetPr(plhs[2]), number_singular_values, number_singular_values);
  // R = L.lu().solve(svd.matrixU());
  R = svd.matrixU();
  S = svd.singularValues().asDiagonal();
  V = svd.matrixV().transpose();
  // Vector3f rhs(1, 0, 0);
  // cout << "Now consider this rhs vector:" << endl << rhs << endl;
  // cout << "A least-squares solution of m*x = rhs is:" << endl <<
  // svd.solve(rhs) << endl;
}
