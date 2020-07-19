

#define VIENNACL_HAVE_EIGEN
#define VIENNACL_WITH_OPENCL

#include <eigen3/Eigen/Sparse>

#include <viennacl/compressed_matrix.hpp>
#include <viennacl/linalg/cg.hpp>
#include <viennacl/linalg/jacobi_precond.hpp>
#include <viennacl/vector.hpp>

#include <chrono>
#include <vector>

using vector = Eigen::VectorXd;
using sparse_matrix = Eigen::SparseMatrix<double, Eigen::RowMajor>;

auto constexpr diagonal_value = 2.0;

sparse_matrix create_laplace_matrix(int const matrix_size) {
  std::vector<Eigen::Triplet<double>> triplets;
  triplets.reserve(matrix_size + 2 * (matrix_size - 1));

  triplets.emplace_back(0, 0, 1.0);

  triplets.emplace_back(1, 1, diagonal_value);
  triplets.emplace_back(1, 2, -1.0);

  for (int i = 2; i < matrix_size - 2; i++) {
    triplets.emplace_back(i, i - 1, -1.0);
    triplets.emplace_back(i, i, diagonal_value);
    triplets.emplace_back(i, i + 1, -1.0);
  }

  triplets.emplace_back(matrix_size - 2, matrix_size - 3, -1.0);
  triplets.emplace_back(matrix_size - 2, matrix_size - 2, diagonal_value);

  triplets.emplace_back(matrix_size - 1, matrix_size - 1, 1.0);

  sparse_matrix A(matrix_size, matrix_size);

  A.setFromTriplets(begin(triplets), end(triplets));

  return A;
}

void solve(sparse_matrix const &A, vector &x, vector const &b) {
  auto constexpr residual_tolerance = 1.0e-6;
  auto const max_iterations = b.rows();

  auto start = std::chrono::steady_clock::now();

  viennacl::ocl::set_context_device_type(0, viennacl::ocl::gpu_tag());

  viennacl::linalg::cg_tag solver_tag(residual_tolerance, max_iterations);

  viennacl::compressed_matrix<double> vcl_A(A.rows(), A.cols());
  viennacl::vector<double> vcl_b(b.rows());

  // Copy from Eigen objects to ViennaCL objects
  viennacl::copy(A, vcl_A);
  viennacl::copy(b, vcl_b);

  viennacl::linalg::ilut_tag ilut_config;
  viennacl::linalg::ilut_precond<viennacl::compressed_matrix<double>> vcl_ilut(
      vcl_A, ilut_config);

  viennacl::linalg::jacobi_precond<viennacl::compressed_matrix<double>>
      vcl_jacobi(vcl_A, viennacl::linalg::jacobi_tag());

  auto end = std::chrono::steady_clock::now();

  std::chrono::duration<double> elapsed_seconds = end - start;

  std::cout << "sparse matrix copied to gpu in " << elapsed_seconds.count()
            << "s\n";

  start = std::chrono::steady_clock::now();

  // Conjugate gradient solver with preconditioner on GPU
  viennacl::vector<double> const vcl_x =
      viennacl::linalg::solve(vcl_A, vcl_b, solver_tag, vcl_ilut);

  end = std::chrono::steady_clock::now();

  elapsed_seconds = end - start;

  std::cout << "solver finished in " << elapsed_seconds.count() << "s\n";

  start = std::chrono::steady_clock::now();

  // Copy back to host
  viennacl::copy(vcl_x, x);

  viennacl::backend::finish();

  end = std::chrono::steady_clock::now();

  elapsed_seconds = end - start;

  std::cout << "result transfer finished in " << elapsed_seconds.count()
            << "s\n";

  std::cout << "Conjugate gradient iterations: " << solver_tag.iters()
            << " (max. " << max_iterations
            << "), estimated error: " << solver_tag.error() << " (min. "
            << residual_tolerance << ")" << std::endl;
}

int main() {
  auto constexpr size = 3'000'000;

  auto start = std::chrono::steady_clock::now();

  sparse_matrix const A = create_laplace_matrix(size);

  vector x = vector::Zero(size);

  vector b = vector::Zero(size);
  b(0) = b(size - 1) = diagonal_value;
  b(1) = b(size - 2) = diagonal_value;

  auto end = std::chrono::steady_clock::now();

  std::chrono::duration<double> elapsed_seconds = end - start;

  std::cout << "sparse matrix filled in " << elapsed_seconds.count() << "s\n";

  // std::cout << A << std::endl << b << std::endl;

  solve(A, x, b);

  // std::cout << x << std::endl;

  std::cout << "error: " << (x - diagonal_value * vector::Ones(size)).norm()
            << std::endl;
}
