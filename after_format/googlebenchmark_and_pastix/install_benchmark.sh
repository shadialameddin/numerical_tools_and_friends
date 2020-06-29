git clone https://github.com/google/benchmark.git
# Benchmark requires Google Test as a dependency. Add the source tree as a subdirectory.
git clone https://github.com/google/googletest.git benchmark/googletest
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ../benchmark
# Assuming a makefile generator was used
make all -j6
sudo make install
