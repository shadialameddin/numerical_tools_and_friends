#include "mex.h"

// .selfadjointView<Upper>()
// mex -I"/home/alameddin/packages/include" effective_mex.cpp
// >> mex -I"/home/alameddin/packages/include" Class/Solvers/SN_Latin/Operators/effective_mex.cpp

// #include </home/alameddin/packages/include/eigen3/Eigen/Dense>
// #include </home/alameddin/packages/include/eigen3/Eigen/Sparse>
// #include </home/alameddin/packages/include/eigen3/Eigen/Eigenvalues>

#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Sparse>
#include <eigen3/Eigen/Eigenvalues>

#include <iostream>
#include <vector>
// #include "matrix.h"
// #include <typeinfo>

#define ngp         int(*mxGetPr(prhs[0]))
#define ntp         int(*mxGetPr(prhs[1]))
#define nu          double(*mxGetPr(prhs[2]))
#define E           double(*mxGetPr(prhs[3]))
#define ncomp       int(*mxGetPr(prhs[4]))
#define dim         int(*mxGetPr(prhs[5]))
#define stress       prhs[6]
#define damage       prhs[7]
#define h           double(*mxGetPr(prhs[8]))
#define typ_cal     int(*mxGetPr(prhs[9]))

#define out       plhs[0]

#define sqrt2       sqrt(2)
#define inv_sqrt2   1/sqrt(2)


void mexFunction(int nlhs, mxArray* plhs[],
                 int nrhs, const mxArray* prhs[]) {


    /* Check for proper number of arguments */
    if(nrhs != 10) {mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin","MEXCPP requires two input arguments.");}
    // if(nlhs != 1) {mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout","MEXCPP requires no output argument.");}
    /* Check if the input is of proper type */
    // if(!mxIsDouble(sigma) || mxIsComplex(sigma)) {mexErrMsgIdAndTxt("MATLAB:mexcpp:typeargin","First argument has to be double scalar.");}
    // if(!mxIsDouble(D) || mxIsComplex(D)) {mexErrMsgIdAndTxt("MATLAB:mexcpp:typeargin","Second argument has to be double scalar.");}

    using Matrix  = Eigen::MatrixXd;
    using Vector  = Eigen::VectorXd;
    using Matrix2 = Eigen::Matrix2d;
    using Vector2 = Eigen::Vector2d;
    using Matrix3 = Eigen::Matrix3d;
    using Vector3 = Eigen::Vector3d;

    /* Acquire pointers to the input data */
    double* sigma = mxGetPr(stress);
    double* D     = mxGetPr(damage);

    auto nDimNum = mxGetNumberOfDimensions(stress);
    auto pDims = mxGetDimensions(stress);
    if (typ_cal==1) {
      nDimNum = mxGetNumberOfDimensions(damage);
      pDims = mxGetDimensions(damage);
    }
    out = mxCreateNumericArray(nDimNum, pDims, mxDOUBLE_CLASS, mxREAL);
    auto out_pt = mxGetPr(out);
    // std::cout << typeid(nDimNum).name() << '\n';
    // std::cout << typeid(pDims).name() << '\n';

    switch (dim) {
      case 1:
        {
          auto sigma_i_j=0.0;
          auto eps_e_i_j=0.0;
          auto sigma_pos=0.0;
          auto sigma_neg=0.0;

          for(int j=0; j<ntp; j++)
          {
              for(int i=0; i<ngp; i++)
              {

                 auto one_min_D = (1-D[j*ngp+i]);
                 auto one_min_hD = (1-h * D[j*ngp+i]);

                 sigma_i_j = sigma[j*ngp*ncomp+i*ncomp+0];
     //             std::cout<< sigma_i_j <<std::endl<<std::endl;
                if (sigma_i_j>0) {
                  sigma_pos = sigma_i_j;
                  sigma_neg = 0.0;}
                  else{
                  sigma_neg = sigma_i_j;
                  sigma_pos = 0.0;}

                 auto sigma_tr_pos = sigma_pos;
                 auto sigma_tr_neg = sigma_neg;

                 switch(typ_cal) {
                     case 0 :
                           {eps_e_i_j = (1+nu)/E * (sigma_pos/one_min_D + sigma_neg/one_min_hD)
                                - nu/E * ( sigma_tr_pos / one_min_D + sigma_tr_neg / one_min_hD);
                           out_pt[j*ngp*ncomp+i*ncomp+0]= eps_e_i_j;
                           break;}       // and exits the switch
                     case 1 :
                           {out_pt[j*ngp+i]= 0.5 * ((1+nu)/E * (sigma_pos*sigma_pos /(pow(one_min_D,2)) + h* sigma_neg*sigma_neg /(pow(one_min_hD,2)))
                                     - nu/E * (pow(sigma_tr_pos / one_min_D,2) + h * pow(sigma_tr_neg / one_min_hD,2)));
                           break;}
                 }

     //             std::cout<< sigma_pos + sigma_neg <<std::endl<<std::endl;
     //             std::cout<< sigma_i_j <<std::endl<<std::endl;

              }
          }
          break;
        }
        case 2:
          {
            Matrix2 sigma_i_j=Matrix2::Zero(); // Aa.setZero(3,3);
            Matrix2 eps_e_i_j=Matrix2::Zero(); // Aa.setZero(3,3);
            Vector2 x;
            Matrix2 v;
            Matrix2 sigma_pos;
            Matrix2 sigma_neg=Matrix2::Zero();

            for(int j=0; j<ntp; j++)
            {
                for(int i=0; i<ngp; i++)
                {

                   auto one_min_D = (1-D[j*ngp+i]);
                   auto one_min_hD = (1-h * D[j*ngp+i]);

                   sigma_pos=Matrix2::Identity();

                   sigma_i_j << sigma[j*ngp*ncomp+i*ncomp+0],             inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+2],
                                inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+2], sigma[j*ngp*ncomp+i*ncomp+1];
       //             std::cout<< sigma_i_j <<std::endl<<std::endl;

                   Eigen::SelfAdjointEigenSolver<Matrix2> eigen_solver(sigma_i_j);
                   v = eigen_solver.eigenvectors();

                   x = eigen_solver.eigenvalues();
                   for(int k=0; k<x.size(); k++)
                   {
                       if (x(k)<0)
                               x(k)=0;
                   }

                   sigma_pos.diagonal()=x;
                   sigma_pos = v * sigma_pos * v.transpose();
                   sigma_neg = sigma_i_j - sigma_pos;

                   auto sigma_tr_pos = sigma_pos.trace();
                   auto sigma_tr_neg = sigma_neg.trace();

                   switch(typ_cal) {
                       case 0 :
                             {eps_e_i_j = (1+nu)/E * (sigma_pos/one_min_D + sigma_neg/one_min_hD)
                                  - nu/E * ( sigma_tr_pos / one_min_D + sigma_tr_neg / one_min_hD) * Matrix2::Identity();
                             out_pt[j*ngp*ncomp+i*ncomp+0]= eps_e_i_j(0,0);
                             out_pt[j*ngp*ncomp+i*ncomp+1]= eps_e_i_j(1,1);
                             out_pt[j*ngp*ncomp+i*ncomp+2]= sqrt2 * eps_e_i_j(0,1);
                             break;}       // and exits the switch
                       case 1 :
                             {out_pt[j*ngp+i]= 0.5 * ((1+nu)/E * (sigma_pos.array().pow(2).sum() /(pow(one_min_D,2)) + h* sigma_neg.array().pow(2).sum() /(pow(one_min_hD,2)))
                                       - nu/E * (pow(sigma_tr_pos / one_min_D,2) + h * pow(sigma_tr_neg / one_min_hD,2)));
                             break;}
                   }

       //             std::cout<< sigma_pos + sigma_neg <<std::endl<<std::endl;
       //             std::cout<< sigma_i_j <<std::endl<<std::endl;

                }
            }
            break;
          }
      case 3:
        {
          Matrix3 sigma_i_j=Matrix3::Zero(); // Aa.setZero(3,3);
          Matrix3 eps_e_i_j=Matrix3::Zero(); // Aa.setZero(3,3);
          Vector3 x;
          Matrix3 v;
          Matrix3 sigma_pos;
          Matrix3 sigma_neg=Matrix3::Zero();

          for(int j=0; j<ntp; j++)
          {
              for(int i=0; i<ngp; i++)
              {

                 auto one_min_D = (1-D[j*ngp+i]);
                 auto one_min_hD = (1-h * D[j*ngp+i]);

                 sigma_pos=Matrix3::Identity();

                 sigma_i_j << sigma[j*ngp*ncomp+i*ncomp+0],             inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+5], inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+4],
                              inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+5], sigma[j*ngp*ncomp+i*ncomp+1],             inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+3],
                              inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+4], inv_sqrt2 * sigma[j*ngp*ncomp+i*ncomp+3], sigma[j*ngp*ncomp+i*ncomp+2];
     //             std::cout<< sigma_i_j <<std::endl<<std::endl;

                 Eigen::SelfAdjointEigenSolver<Matrix3> eigen_solver(sigma_i_j);
                 v = eigen_solver.eigenvectors();

                 x = eigen_solver.eigenvalues();
                 for(int k=0; k<x.size(); k++)
                 {
                     if (x(k)<0)
                             x(k)=0;
                 }

                 sigma_pos.diagonal()=x;
                 sigma_pos = v * sigma_pos * v.transpose();
                 sigma_neg = sigma_i_j - sigma_pos;

                 auto sigma_tr_pos = sigma_pos.trace();
                 auto sigma_tr_neg = sigma_neg.trace();

                 switch(typ_cal) {
                     case 0 :
                           {eps_e_i_j = (1+nu)/E * (sigma_pos/one_min_D + sigma_neg/one_min_hD)
                                - nu/E * ( sigma_tr_pos / one_min_D + sigma_tr_neg / one_min_hD) * Matrix3::Identity();
                           out_pt[j*ngp*ncomp+i*ncomp+0]= eps_e_i_j(0,0);
                           out_pt[j*ngp*ncomp+i*ncomp+1]= eps_e_i_j(1,1);
                           out_pt[j*ngp*ncomp+i*ncomp+2]= eps_e_i_j(2,2);
                           out_pt[j*ngp*ncomp+i*ncomp+3]= sqrt2 * eps_e_i_j(1,2);
                           out_pt[j*ngp*ncomp+i*ncomp+4]= sqrt2 * eps_e_i_j(0,2);
                           out_pt[j*ngp*ncomp+i*ncomp+5]= sqrt2 * eps_e_i_j(0,1);
                           break;}       // and exits the switch
                     case 1 :
                           {out_pt[j*ngp+i]= 0.5 * ((1+nu)/E * (sigma_pos.array().pow(2).sum() /(pow(one_min_D,2)) + h* sigma_neg.array().pow(2).sum() /(pow(one_min_hD,2)))
                                     - nu/E * (pow(sigma_tr_pos / one_min_D,2) + h * pow(sigma_tr_neg / one_min_hD,2)));
                           break;}
                 }

     //             std::cout<< sigma_pos + sigma_neg <<std::endl<<std::endl;
     //             std::cout<< sigma_i_j <<std::endl<<std::endl;

              }
          }
          break;
        }
    }
    return;
}
