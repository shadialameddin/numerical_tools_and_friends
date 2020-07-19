clang++ std_vs_eigen.cpp -DNDEBUG -O3 -march=native -std=c++17 -ffast-math -lbenchmark -pthread -Wall -Winfinite-recursion -Wextra -Wpedantic && ./a.out --benchmark_out=benchmark_output.json
# g++ expression_templates.cpp -O3 -std=c++17 && ./a.out -Wall -Winfinite-recursion -Wextra -Wpedantic
# clang++ expression_templates.cpp -O3 -std=c++17 && ./a.out -Wall -Winfinite-recursion

# python3 plot.py

# sudo cpupower frequency-set --governor performance
# ./mybench
# sudo cpupower frequency-set --governor powersave
