// g++ -O3 -std=c++17 -fopenmp stifness_assembly.cpp -I"/usr/include/tbb"
// -I"/usr/include/eigen3" && ./a.out

// // #include <tbb/task_scheduler_init.h>
// #include <tbb/tbb.h>

// clang-format off
// Eigen::initParallel(); //TODO try this

#include <Eigen/Core>
#include <Eigen/Dense>
#include <Eigen/Sparse>
#include <iostream>
#include <omp.h>
#include <tbb/tbb.h>

int main() {
  double t1 = omp_get_wtime();

  auto const n = 10000;   // number of nodes
  auto const n_el = 20; // number of elements

  Eigen::MatrixXd Kdense = Eigen::MatrixXd::Zero(n, n); // global stiffness matrix
  Eigen::MatrixXd Ke = Eigen::MatrixXd::Ones(n_el, n_el); // elemental stiffness
#pragma omp declare reduction(+ : Eigen::MatrixXd : omp_out =  omp_out + omp_in) \
                initializer(omp_priv=Eigen::MatrixXd::Zero(n,n))

#pragma omp parallel for reduction(+ : Kdense)
  for (int i = 0; i < n - n_el + 1; i++) {
    Kdense.block(i, i, n_el, n_el) += Ke;
  }

  double t2 = omp_get_wtime();
  std::cout << Kdense.block(n - n_el, n - n_el, n_el, n_el) << std::endl;
  std::cout << "/* message */" << t2 - t1 << '\n';

  using namespace tbb;
    std::vector<double> a(20);
    tbb::parallel_for( size_t(0), 10,1,  [&]( size_t i ) {
        a.at(i)=i; return;
    } );


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
