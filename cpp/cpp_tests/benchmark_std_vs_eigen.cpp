
#include <benchmark/benchmark.h>

#include <vector>
#include <numeric>

#include <eigen3/Eigen/Dense>

using vector = Eigen::VectorXd;

static void eigen_dot(benchmark::State& state)
{
    vector x = vector::Random(state.range(0));
    vector y = vector::Random(state.range(0));

    for (auto _ : state)
    {
        volatile double value = x.dot(y);
    }
    state.SetBytesProcessed(state.range(0) * 2 * state.iterations() * sizeof(double));
}

static void std_inner_product(benchmark::State& state)
{
    std::vector<double> x(state.range(0)), y(state.range(0));

    std::generate(begin(x), end(x), std::rand);
    std::generate(begin(y), end(y), std::rand);

    for (auto _ : state)
    {
        volatile double value = std::inner_product(begin(x), end(x), begin(y), 0.0);
    }
    state.SetBytesProcessed(state.range(0) * 2 * state.iterations() * sizeof(double));
}

static void eigen_sum(benchmark::State& state)
{
    vector x = vector::Random(state.range(0));

    for (auto _ : state)
    {
        volatile double value = x.sum();
    }
    state.SetBytesProcessed(state.range(0) * state.iterations() * sizeof(double));
}

static void std_accumulate(benchmark::State& state)
{
    std::vector<double> x(state.range(0));
    std::generate(begin(x), end(x), std::rand);

    for (auto _ : state)
    {
        volatile double value = std::accumulate(begin(x), end(x), 0.0);
    }
    state.SetBytesProcessed(state.range(0) * state.iterations() * sizeof(double));
}

BENCHMARK(eigen_dot)->RangeMultiplier(2)->Range(8, 8 << 20);
BENCHMARK(std_inner_product)->RangeMultiplier(2)->Range(8, 8 << 20);

BENCHMARK(eigen_sum)->RangeMultiplier(2)->Range(8, 8 << 20);
BENCHMARK(std_accumulate)->RangeMultiplier(2)->Range(8, 8 << 20);

BENCHMARK_MAIN();
