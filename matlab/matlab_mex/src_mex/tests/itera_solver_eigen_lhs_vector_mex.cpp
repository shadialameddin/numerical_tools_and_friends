#include <iostream>
#include <vector>
#include <fstream>
#include <string> // for string class
#include <math.h>
#include <iostream>
#include <cmath>
#include <array>
#include <complex>
#include<time.h>
#include "mex.h"

//#define EIGEN_USE_MKL_ALL
#include <Eigen/Dense>
#include <Eigen/Sparse>
// #include <unsupported/Eigen/CXX11/Tensor>
#include <Eigen/LU>
// #include <unsupported/Eigen/KroneckerProduct>
#include <Eigen/Core>
// #include <Eigen/SVD>
#include<unsupported/Eigen/SparseExtra>
#include<Eigen/IterativeLinearSolvers>

using namespace Eigen;
// using complex_sparse_matrix = Eigen::SparseMatrix<std::complex<double>>;
// using complex_vector = Eigen::VectorXcd;
// using complex_matrix = Eigen::MatrixXcd;

#define PI acos(-1.0)

//*******************Changing***************************
//Without damping matrix
//full geometry, no symmetric boundarycondition
//********************************************************

//#include "mkl_lapacke.h"
//#include "lapack.h"

//typedef size_t INT;
//#define MKL_INT INT
//#ifndef lapack_int
//#define lapack_int MKL_INT
//#endif
//written by Chau Nguyen Khanh
#define MIN(a, b) ((a) < (b) ? (a) : (b))
//#ifdef __cplusplus
//extern "C" bool utIsInterruptPending();
//#else
//extern bool utIsInterruptPending();
//#endif

#if defined(NAN_EQUALS_ZERO)
#define IsNonZero(d) ((d)!=0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d)!=0.0)
#endif

//Dynamic force
// double force(double x)
// {
// 	double i;
// 	if ((1 - x) >= 0)
// 	{
// 		i = 1.0;
// 	}
// 	else
// 	{
// 		i = 0.0;
// 	}
// 	return -4 * (1.0 - pow((2.0 * x - 1.0), 2.0)) * i;
// }

// double force(double x)
// {
// 	return 1e9*sin(460 * x);
// }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//*********************************************
	/* get the values from the struct 1x1 */
	// int NoTimeStep = (int) mxGetScalar(mxGetField(prhs[0], 0, "NoTimeStep"));
	// int N_DoF = (int) mxGetScalar(mxGetField(prhs[0], 0, "N_DoF")); // number of dof per element
	// double dt = (double) mxGetScalar(mxGetField(prhs[0], 0, "dt")); // number of dof per element
	//*********************************************

	/* get the values from the struct Matrix m x 1 *//*only use the pointer*/
	// double *TIME_vec = (double *) mxGetPr(mxGetField(prhs[0], 0, "TIME_vec"));
	// int *TIMEPLOT = (int*) mxGetPr(mxGetField(prhs[0], 0, "TIMEPLOT"));
	// int LengthTIMEPLOT = (int) mxGetScalar(mxGetField(prhs[0], 0, "LengthTIMEPLOT")); // number of dof per element

	// 	double *val_v0 = (double *) mxGetPr(mxGetField(prhs[0], 0, "v0")); //
	// 	Eigen::VectorXd v0 = Map < VectorXd > (val_v0, N_DoF);
	//*********************************************
	double *val_rhs_matrix = (double *) mxGetPr(mxGetField(prhs[0], 0, "rhs_matrix"));
	int m_rhs_matrix = mxGetM(mxGetField(prhs[0], 0, "rhs_matrix"));
	Eigen::VectorXd rhs_matrix = Eigen::Map < Eigen::VectorXd > (val_rhs_matrix, m_rhs_matrix);

	double *val_x0 = (double *) mxGetPr(mxGetField(prhs[0], 0, "x0"));
	int m_x0 = mxGetM(mxGetField(prhs[0], 0, "x0"));
	Eigen::VectorXd x0 = Eigen::Map < Eigen::VectorXd > (val_x0, m_x0);

	double *nnzval_K = (double *) mxGetPr(mxGetField(prhs[0], 0, "nnzval_K"));
	int m_K = (int) mxGetScalar(mxGetField(prhs[0], 0, "m_K"));
	int nnz_K = (int) mxGetScalar(mxGetField(prhs[0], 0, "nnz_K"));
	int *Ir_K = (int *) mxGetPr(mxGetField(prhs[0], 0, "Ir_K"));
	int *Jc_K = (int *) mxGetPr(mxGetField(prhs[0], 0, "Jc_K"));
	std::vector < Eigen::Triplet<double> > trip_K(3 * nnz_K);
	for (int i = 0; i < nnz_K; ++i)
	{
		trip_K.push_back(Eigen::Triplet<double>(Ir_K[i] - 1, Jc_K[i] - 1, nnzval_K[i]));
	}
	Eigen::SparseMatrix<double> K(m_K, m_K);
	K.setFromTriplets(trip_K.begin(), trip_K.end());

    std::cout << "finishing read matrix from matlab" << std::endl;

    
	//	* Out put *//* Out put *//* Out put *//* Out put *//* Out put *//* Out put */
	plhs[0] = mxCreateDoubleMatrix((mwSize) m_rhs_matrix, (mwSize) 1, mxREAL);
	double *u0_out = mxGetPr(plhs[0]); // pointer pr_out will manage data in COLUMN Major.
	// plhs[1] = mxCreateDoubleMatrix((mwSize) N_DoF, (mwSize) LengthTIMEPLOT, mxREAL);
	// double *v0_out = mxGetPr(plhs[1]); // pointer pr_out will manage data in COLUMN Major.
	// plhs[2] = mxCreateDoubleMatrix((mwSize) N_DoF, (mwSize) LengthTIMEPLOT, mxREAL);
	// double *a0_out = mxGetPr(plhs[2]); // pointer pr_out will manage data in COLUMN Major.


	// Eigen::SparseLU < Eigen::SparseMatrix<double> > solver_LHS;
	Eigen::ConjugateGradient<Eigen::SparseMatrix<double>, Lower|Upper> solver_LHS;
//     Eigen::BiCGSTAB<Eigen::SparseMatrix<double> > solver_LHS;
	solver_LHS.analyzePattern(K); // for this step the numerical values of A are not used
	solver_LHS.factorize(K);
	if (solver_LHS.info() != Success)
	{
		// decomposition failed
		std::cout << "decomposition failed" << std::endl;
		return;
	} else {
		std::cout << "decomposition successful" << std::endl;
	}

	Eigen::VectorXd u_n1(m_rhs_matrix);
	// u_n1 = solver_LHS.solve(rhs_matrix);
		u_n1 = solver_LHS.solveWithGuess(rhs_matrix,x0);

	//Update solution to Final matrix

	Eigen::Map < Eigen::VectorXd > (u0_out, m_rhs_matrix) = u_n1;
//Eigen::Map < MatrixXd > (u0_out + (m_rhs_matrix * 0), m_rhs_matrix,n_rhs_matrix) = u_n1;
}
