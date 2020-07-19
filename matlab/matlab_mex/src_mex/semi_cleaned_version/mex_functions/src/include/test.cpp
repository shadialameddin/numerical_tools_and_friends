// g++ -O3 -std=c++17 -fopenmp stifness_assembly.cpp -I"/usr/include/tbb"
// -I"/usr/include/eigen3" && ./a.out

// // #include <tbb/task_scheduler_init.h>
// #include <tbb/tbb.h>

// clang-format off
// Eigen::initParallel(); //TODO try this

// #include <Eigen/Core>
// #include <Eigen/Dense>
// #include <Eiegn/Sparse>
#include <iostream>


void test() {

   // Eigen::MatrixXd HHH=Eigen::MatrixXd::Zero(6,6);
   // Eigen::MatrixXd KKK=Eigen::MatrixXd::Zero(6,6);
   // HHH+=KKK;
   // HHH=HHH.transpose();

}

// Eigen::SparseMatrix<double, Eigen::RowMajor> K(n, n);
// K.coeffs() = 0.0;
// auto Ke = Eigen::MatrixXd::Ones(n_el, n_el);

// #pragma omp critical
//     {
//       for (auto b = 0; b < dofs.size(); b++) {
//         for (auto a = 0; a < dofs.size(); a++) {
// #pragma omp critical
//           K.coeffRef(int(dofs[a]), int(dofs[b])) += Ke(a, b);
//         }
// }
// }
