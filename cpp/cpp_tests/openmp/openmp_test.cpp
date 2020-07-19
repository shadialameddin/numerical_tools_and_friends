
#include <cmath>
#include <iostream>
#include <numeric>
#include <omp.h>
#include <vector>

// Not the best way to do things but it's easy to test (we might not get from
// the CPU the maximum number of threads that we asked for)
int main() {
  using namespace std;
  omp_set_dynamic(0);
  omp_set_num_threads(8);                      // sets the maximum
  auto number_of_threads = 1;                  // omp_get_max_threads();
  double area_i[number_of_threads][8] = {0.0}; // Pading
  double area = 0.0;
  int total_number_of_divisions = 1e8;
  double thread_d_x = 1.0 / number_of_threads;
  double t1 = omp_get_wtime();
  // #pragma omp parallel
  // {
  number_of_threads = 1; // omp_get_num_threads();
  int number_of_divisions = total_number_of_divisions / number_of_threads;
  double min = omp_get_thread_num() * thread_d_x;
  double max = min + thread_d_x;
  double step = (max - min) / number_of_divisions;
  double res = 0.0;
  double x;
  // printf(" min max step %f\t%f\t%f\n", min, max, step);
#pragma omp parallel for reduction(+ : area) private(x)
  for (size_t i = 0; i < number_of_divisions; i++) {
    {
      x = min + (i + 0.5) * step;
      area += step * 4.0 / (1.0 + pow(x, 2));
    }
  }

  // #pragma omp atomic
  //     area += res;
  // area_i[omp_get_thread_num()][0] += res;
  // }
  double t2 = omp_get_wtime();
  cout << area << '\n';
  // for (size_t i = 0; i < number_of_threads; i++)
  //   s += area_i[i][0];
  // cout << "/* message */" << area << '\n'; //
  // accumulate(area_i.begin(), area_i.end(), 0.0)
  cout << "/* message */" << t2 - t1 << '\n';

  return 0;
}
