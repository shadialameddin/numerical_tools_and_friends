// In C++ computer programming, copy elision refers to a compiler optimization
// technique that eliminates unnecessary copying of objects.

#include <iostream>

struct my_type {
  my_type() {}
  my_type(const my_type &) { std::cout << "A copy was made.\n"; }
};

my_type f() { return my_type(); }

int main() {
  std::cout << "Hello World!\n";
  my_type obj = f();
  my_type obj2(obj);
  return 0;
}
