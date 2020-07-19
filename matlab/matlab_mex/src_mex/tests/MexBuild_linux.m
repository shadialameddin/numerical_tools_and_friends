clc;
clear all; 
close all;

 

% mex -L. -I"/home/chuongnguyen/Documents/Dropbox/SubCodes/Eigen334"...
%     -largeArrayDims...
%     solver_eigen_mex.cpp
% 
% mex -L. -I"/home/chuongnguyen/Documents/Dropbox/SubCodes/Eigen334"...
%     -largeArrayDims...
%     itera_solver_eigen_lhs_vector_mex.cpp

mex -L. -I"/usr/include/eigen3" -I/opt/intel/compilers_and_libraries_2019.3.199/linux/mkl/include -L/usr/lib64 -lpastix -lscotch -lscotcherr -lmkl_intel_lp64 -lmkl_tbb_thread -lmkl_core -ltbb -lstdc++ -lpthread -lm -ldl *.cpp

mex -L. -I"/usr/include/eigen3" -I/opt/intel/compilers_and_libraries_2019.3.199/linux/mkl/include -L/usr/lib64 -lpastix -lscotch -lscotcherr -lmkl_intel_lp64 -lmkl_tbb_thread -lmkl_core -ltbb -lstdc++ -lpthread -lm -ldl direct_solver_mex.cpp

mex -L. -I"/usr/include/eigen3" -I/opt/intel/compilers_and_libraries_2019.3.199/linux/mkl/include -L/usr/lib64 -lpastix -lscotch -lscotcherr -lmkl_intel_lp64 -lmkl_tbb_thread -lmkl_core -ltbb -lstdc++ -lpthread -lm -ldl solver_pastix_mex.cpp

mex -L. -I"/usr/include/eigen3" -I/opt/intel/compilers_and_libraries_2019.3.199/linux/mkl/include -L/usr/lib64 -lpastix -lscotch -lscotcherr -lmkl_intel_lp64 -lmkl_tbb_thread -lmkl_core -ltbb -lstdc++ -lpthread -lm -ldl solver_eigen_mex.cpp
