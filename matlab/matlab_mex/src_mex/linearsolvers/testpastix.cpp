// mex -I"/usr/include/eigen3" -I"/usr/local/include" -L"/usr/local/lib/"
// -l"libpastix.so" direct_solver.cpp mex -I"/usr/include/eigen3"
// -I"/usr/local/include" '-LC:/usr/local/lib/' -llibpastix.so direct_solver.cpp
// g++ -I"/usr/include/eigen3" -L/usr/lib64/ -lpastix testpastix.cpp
// g++ -I"/usr/include/eigen3" -L/usr/local/lib -lpastix testpastix.cpp
// -Wl,--unresolved-symbols=ignore-all

// g++ -I"/usr/include/eigen3"
// -I/opt/intel/compilers_and_libraries_2019.3.199/linux/mkl/include
// -L/usr/lib64 -lpastix -lscotch -lscotcherr -lmkl_intel_lp64 -lmkl_tbb_thread
// -lmkl_core -ltbb -lstdc++ -lpthread -lm -ldl testpastix.cpp && ./a.out

// -lmkl_sequential

// direct_solver(sparse(2*eye(3)),sparse([1 0 0]'))
// #include "tbb/parallel_for.h"

#include <iostream>
#include <limits>
#include <type_traits>
#include <vector>

#define EIGEN_USE_MKL_ALL

#include <eigen3/Eigen/Core>
#include <eigen3/Eigen/Dense>
#include <eigen3/Eigen/Sparse>
#include <eigen3/Eigen/SparseCholesky>
#include <eigen3/Eigen/SparseLU>
#include <eigen3/Eigen/SparseQR>

#include <chrono>

#include <eigen3/Eigen/PaStiXSupport>
#include <eigen3/Eigen/PardisoSupport>

int main() {

  // using sparse_matrix = Eigen::SparseMatrix<double, Eigen::RowMajor>;
  using sparse_matrix = Eigen::SparseMatrix<double>;
  using Matrix = Eigen::MatrixXd;
  using Vector = Eigen::VectorXd;

  int n = 3000;
  auto A = Matrix::Random(n, n).sparseView();
  // A.insert(0, 0) = 0.5;
  // A.insert(1, 1) = 0.5;
  // A.insert(2, 2) = 0.5;
  auto b = Vector::Ones(n);

  // std::cout << A << std::endl;

  auto const start = std::chrono::steady_clock::now();

  Eigen::SimplicialLLT<Eigen::SparseMatrix<double>> solver;
  solver.analyzePattern(A);
  solver.factorize(A);
  auto space_mode = solver.solve(b);
  // std::cout << space_mode << std::endl;

  auto const end = std::chrono::steady_clock::now();
  std::chrono::duration<double> elapsed_seconds = end - start;
  std::cout << "1st solver took " << elapsed_seconds.count() << "s\n";

  auto const start2 = std::chrono::steady_clock::now();

  Eigen::PastixLU<Eigen::SparseMatrix<double>, true> solver2;
  solver2.iparm(34) = 4;
  solver2.analyzePattern(A);

  auto const end22 = std::chrono::steady_clock::now();
  elapsed_seconds = end22 - start2;
  std::cout << "2nd analyzePattern took " << elapsed_seconds.count() << "s\n";
  solver2.factorize(A);
  auto space_mode2 = solver2.solve(b);
  // std::cout << space_mode2 << std::endl;
  auto const end2 = std::chrono::steady_clock::now();
  elapsed_seconds = end2 - start2;
  std::cout << "2nd solver took " << elapsed_seconds.count() << "s\n";

  auto const start3 = std::chrono::steady_clock::now();

  // Eigen::PardisoLU<Eigen::SparseMatrix<double>> solver3;
  Eigen::PardisoLDLT<Eigen::SparseMatrix<double>> solver3;
  // solver3.pardisoParameterArray()[59] = 1;
  solver3.analyzePattern(A);
  solver3.factorize(A);
  auto space_mode3 = solver3.solve(b);
  // Eigen::VectorXd space_mode3 = solver3.solve(b);
  // std::cout << typeof(space_mode3) << std::endl;
  std::cout << typeid(space_mode3).name() << std::endl;

  // std::cout << (solver3.info() == 0) << std::endl;
  // std::cout << *space_mode3[0] << std::endl;

  auto const end3 = std::chrono::steady_clock::now();
  elapsed_seconds = end3 - start3;
  std::cout << "3rd solver took " << elapsed_seconds.count() << "s\n";

  return 0;
}
