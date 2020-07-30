pip install conan --user
conan profile new default --detect
conan profile update settings.compiler.libcxx=libstdc++11 default

cd cmake-build-debug
conan install ..

cd ~/0_delme

git clone https://github.com/fmtlib/fmt.git
cd fmt && mkdir build && cd build
cmake ..
make -j6
sudo make install