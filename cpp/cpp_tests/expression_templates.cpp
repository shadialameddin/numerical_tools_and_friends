// Expression templates are a C++ template metaprogramming technique that builds
// structures representing a computation at compile time, where expressions are
// evaluated only as needed to produce efficient code for the entire computation
// Expression templates thus allow programmers to bypass the normal order of
// evaluation of the C++ language and achieve optimizations such as loop fusion.

#include <cassert>
#include <iostream>
#include <vector>

template <typename vec> class vec_expression {
public:
  void print() {
    for (size_t i = 0; i != (*this).size(); ++i)
      std::cout << static_cast<vec const &>(*this)[i] << '\t';
    std::cout << '\n';
  };
  double operator[](size_t i) const {
    return static_cast<vec const &>(*this)[i];
  }
  size_t size() const { return static_cast<vec const &>(*this).size(); }
};

class vec_class : public vec_expression<vec_class> {
  std::vector<double> vector_elements = {1. / 3, 3. / 3, 5. / 3};

public:
  double operator[](size_t i) const { return vector_elements[i]; }
  double &operator[](size_t i) { return vector_elements[i]; }
  size_t size() const { return vector_elements.size(); }
  void print() {
    for (auto const &x : vector_elements)
      std::cout << x << '\t';
    std::cout << '\n';
  };
};

template <typename left_arg_type, typename right_arg_type>
class vec_operation
    : public vec_expression<vec_operation<left_arg_type, right_arg_type>> {
  left_arg_type const &vl;
  right_arg_type const &vr;

public:
  vec_operation(left_arg_type const &v_l, right_arg_type const &v_r)
      : vl(v_l), vr(v_r) {
    assert(v_l.size() == v_r.size());
  }
  double operator[](size_t i) const { return vl[i] + vr[i]; }
  size_t size() const { return vr.size(); }
};

template <typename left_arg_type, typename right_arg_type>
auto operator+(left_arg_type const &v_l, right_arg_type const &v_r) {
  return vec_operation<left_arg_type, right_arg_type>(v_l, v_r);
}

int main() {
  vec_class vv1;
  vec_class vv2;
  vec_class vv3;

  auto vv = vv1 + vv2 + vv3;
  vv.print();

  std::cout << "/* message */" << '\n';
  return 0;
}
