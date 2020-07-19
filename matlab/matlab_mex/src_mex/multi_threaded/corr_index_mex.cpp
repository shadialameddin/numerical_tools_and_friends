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
#include <omp.h>

//#define EIGEN_USE_MKL_ALL
#include <Eigen/Dense>
// #include <Eigen/Sparse>
// #include <unsupported/Eigen/CXX11/Tensor>
// #include <Eigen/LU>
// #include <unsupported/Eigen/KroneckerProduct>
#include <Eigen/Core>
// #include <Eigen/SVD>
// #include<unsupported/Eigen/SparseExtra>

#define PI acos(-1.0)


using namespace Eigen;


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  //*********************************************

  double *val_Node_Coord = (double *) mxGetPr(mxGetField(prhs[0], 0, "Node_Coord"));
  int m_Node_Coord = mxGetM(mxGetField(prhs[0], 0, "Node_Coord"));
  int n_Node_Coord = mxGetN(mxGetField(prhs[0], 0, "Node_Coord"));
  Eigen::MatrixXd Node_Coord = Map < MatrixXd > (val_Node_Coord,m_Node_Coord,n_Node_Coord);

  double *val_Node_Coord_ndgrid = (double *) mxGetPr(mxGetField(prhs[0], 0, "Node_Coord_ndgrid"));
  int m_Node_Coord_ndgrid = mxGetM(mxGetField(prhs[0], 0, "Node_Coord_ndgrid"));
  int n_Node_Coord_ndgrid = mxGetN(mxGetField(prhs[0], 0, "Node_Coord_ndgrid"));
  Eigen::MatrixXd Node_Coord_ndgrid = Map < MatrixXd > (val_Node_Coord_ndgrid,m_Node_Coord_ndgrid,n_Node_Coord_ndgrid);

  double *val_node_index_total= (double *) mxGetPr(mxGetField(prhs[0], 0, "node_index_total"));
  int m_node_index_total = mxGetM(mxGetField(prhs[0], 0, "node_index_total"));
  Eigen::VectorXd node_index_total = Map < VectorXd > (val_node_index_total,m_node_index_total);


  int nnode=Node_Coord_ndgrid.rows();
  Eigen::MatrixXd corr_index(nnode,1); corr_index.setZero();


// Eigen::MatrixXd a(3,3);
// a<<1,2,3,
// 4,5,6,
// 7,8,9;
// std::cout << a<< '\n';
// Eigen::VectorXd b=Eigen::Map<VectorXd>(a.data(), a.cols()*a.rows());
// std::cout << b.transpose() << '\n';
// std::cout <<Eigen::Map<VectorXd>(a.data(), a.cols()*a.rows()) << '\n';

  // int p, n;
  // double sum;
  // sum = 0.0;
  // n = 100;
  // #pragma omp parallel for shared(n) private(p) reduction(+: sum)
  // for(p = 0; p<n; p++){
  //   sum += 1.0;
  //   std::cout << "/* message */"<< sum << '\n';
  // }
  // mexPrintf("sum = %f\n",sum);
  int i=0;
  #pragma omp parallel for private(i) shared(Node_Coord_ndgrid,Node_Coord,node_index_total,corr_index)
  for (i = 0; i < nnode; i++) {
    Eigen::Vector3d coord = Node_Coord_ndgrid.row(i);
    MatrixXf::Index index;

    // Eigen::MatrixXd temp=Node_Coord.rowwise()-coord.transpose();
    // Eigen::VectorXd coordx = temp.rowwise().norm();;
    // std::cout << "/* ***** */" << '\n';
    // std::cout <<  coord.transpose() << '\n';
    // // std::cout << "/* message */" << '\n';
    // // std::cout << temp.block<5,3>(0,0) << '\n';
    // std::cout << "/* message */" << '\n';
    // std::cout << coordx.head(5) << '\n';
    // std::cout << "/* message */" << '\n';
    // coordx.minCoeff(&index);
    // std::cout << index << " ***  "<< node_index_total(index)<< '\n';


    (Node_Coord.rowwise()-coord.transpose()).rowwise().norm().minCoeff(&index);
    // std::cout << index << " ***  "<< node_index_total(index)<< '\n';
    corr_index(i,0)=node_index_total(index);
  }



  //	* Out put *//* Out put *//* Out put *//* Out put *//* Out put *//* Out put */
  plhs[0] = mxCreateDoubleMatrix((mwSize) nnode, (mwSize) 1, mxREAL);
  double *corr_index_out = mxGetPr(plhs[0]); // pointer pr_out will manage data in COLUMN Major.
  Eigen::Map < MatrixXd > (corr_index_out, nnode,1) = corr_index;
};
