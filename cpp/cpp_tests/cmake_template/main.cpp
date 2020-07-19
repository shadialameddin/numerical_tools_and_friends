#include <cassert>
#include <iostream>
#include <vector>

template <typename v> class expression {
public:
  // double operator[](size_t i) const { return (*this)[i]; }
  // double &operator[](size_t i) { return (*this)[i]; }
  // size_t size() const { return (*this).size(); }
};

class Vec : public expression<Vec> {
  std::vector<double> elems;

public:
  double operator[](size_t i) const { return elems[i]; }
  double &operator[](size_t i) { return elems[i]; }
  size_t size() const { return elems.size(); }

  Vec(size_t n) : elems(n) {}

  // construct vector using initializer list
  Vec(std::initializer_list<double> init) {
    for (auto i : init)
      elems.push_back(i);
  }

  // A Vec can be constructed from any expression, forcing its evaluation.
  template <typename E> Vec(expression<E> const &vec) : elems(vec.size()) {
    for (size_t i = 0; i != vec.size(); ++i) {
      elems[i] = vec[i];
    }
  }
};

template <typename E1, typename E2>
class VecSum : public expression<VecSum<E1, E2>> {
  E1 const &_u;
  E2 const &_v;

public:
  VecSum(E1 const &u, E2 const &v) : _u(u), _v(v) {
    assert(u.size() == v.size());
  }

  double operator[](size_t i) const { return _u[i] + _v[i]; }
  size_t size() const { return _v.size(); }
};

template <typename E1, typename E2>
VecSum<E1, E2> operator+(E1 const &u, E2 const &v) {
  return VecSum<E1, E2>(u, v);
}

int main() {

  Vec v0 = {23.4, 12.5, 144.56, 90.56};
  Vec v1 = {67.12, 34.8, 90.34, 89.30};
  Vec v2 = {34.90, 111.9, 45.12, 90.5};

  // Following assignment will call the ctor of Vec which accept type of
  // `expression<E> const&`. Then expand the loop body to
  // a.elems[i] + b.elems[i] + c.elems[i]
  auto sum_of_vec_type = v0 + v1 + v2;

  // int xx = sum_of_vec_type[0];
  // std::cout << typeid(sum_of_vec_type) << '\n';
  for (int i = 0; i < sum_of_vec_type.size(); ++i)
    std::cout << sum_of_vec_type[i] << std::endl;

  // int x = v0 + v1 + v2;
}
