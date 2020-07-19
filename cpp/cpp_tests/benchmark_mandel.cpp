// We current store second order tensors as 3x3 matrices, regardless of symmetric considerations. Some memory (or theoretically computation) reduction can be achieved from using Voigt or Mandel notation.

// Some data on a conversion:

#include <benchmark/benchmark.h>

#include <cmath>
#include <numeric>

#include <eigen3/Eigen/Dense>

using vector6 = Eigen::Matrix<double, 6, 1>;
using matrix3 = Eigen::Matrix<double, 3, 3>;

static void tensor_contraction(benchmark::State &state) {

  std::vector<matrix3> as(10'000), bs(10'000);

  std::generate(begin(as), end(as), []() { return matrix3::Random(3, 3); });
  std::generate(begin(bs), end(bs), []() { return matrix3::Random(3, 3); });

  for (auto _ : state) {
    [[maybe_unused]] volatile double result =
        std::inner_product(begin(as), end(as), begin(bs), 0.0, std::plus<>(),
                           [](auto const &a, auto const &b) {
                             return std::sqrt((a.array() * b.array()).sum());
                           });
  }
  state.counters["norms"] = state.iterations();
}

static void voigt_contraction(benchmark::State &state) {

  std::vector<vector6> as(10'000), bs(10'000);

  std::generate(begin(as), end(as), []() { return vector6::Random(6, 1); });
  std::generate(begin(bs), end(bs), []() { return vector6::Random(6, 1); });

  for (auto _ : state) {
    [[maybe_unused]] volatile double result = std::inner_product(
        begin(as), end(as), begin(bs), 0.0, std::plus<>(),
        [](auto const &a, auto const &b) { return std::sqrt(a.dot(b)); });
  }

  state.counters["norms"] = state.iterations();
}

BENCHMARK(tensor_contraction);
BENCHMARK(voigt_contraction);

BENCHMARK_MAIN();
