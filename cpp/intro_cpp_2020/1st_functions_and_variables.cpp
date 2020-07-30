/*
Online compilers
https://www.onlinegdb.com/
https://www.onlinegdb.com/blog/brief-guide-on-how-to-use-onlinegdb-debugger/
https://godbolt.org/

package manager
https://conan.io/center/

ldd intro_cpp_2020 // print dynamic links
compilers & linkers
*/

#include <iostream>
#include <fmt/core.h>

double square_function(double, double);
double square_function_ref(const double&, const double&);
void define_variables();
void print_format();

int main()
{
    std::cout << "Hello, World! 1" << std::endl;
    // return 0;

    fmt::print("{:-^30}\n", "define variables");
    auto x = 3.3;             // 8 bytes
    const int y{3};           // 4 bytes may be computed at run time {} does extra checks
    constexpr auto z = 3 * 3; // should be computable at compile time
    auto* p = &x;             // pointer to x
    auto& r = x;              // reference to x
    double* nptr = nullptr;

    std::cout << sizeof(x) << "\t" << typeid(x).name() << "\t address:" << &x << std::endl;
    std::cout << sizeof(y) << "\t" << typeid(y).name() << "\t address:" << &y << std::endl;
    std::cout << sizeof(z) << "\t" << typeid(z).name() << "\t address:" << &z << std::endl;
    std::cout << sizeof(p) << "\t" << typeid(p).name() << "\t address:" << p << std::endl;
    std::cout << sizeof(r) << "\t" << typeid(r).name() << "\t address:" << &r << std::endl;
    std::cout << sizeof(x + y) << "\t" << typeid(x).name() << "\t"
              << std::endl; // convert all to the highest accuracy

    fmt::print("{:-^30}\n", "call functions");
    print_format();            // using a modern formatting library
    square_function(x, y);     // implicit conversion of y
    square_function_ref(x, y); // implicit conversion of y

    auto fun = [&](const auto x) {
        std::cout << sizeof(x) << "\t" << typeid(x).name() << "\t" << &x << std::endl;
        return 0;
    };
    fun(x); // TODO: why does the address change?!
}

void print_format()
{
    // https://vorbrodt.blog/2019/03/31/fmt/
    fmt::print("Default format: {} {}\n", 42, 100);
    fmt::print("{:-^30}\n", "end fmt");
}

double square_function(double x, double y)
{
    std::cout << "call by value " << sizeof(x) << "bytes \t address:" << &x << std::endl;
    return x * y;
}

double square_function_ref(const double& x, const double& y)
{
    std::cout << "call by value " << sizeof(x) << " bytes \t address:" << &x << std::endl;
    std::cout << "call by value " << sizeof(y) << " bytes \t address:" << &y << std::endl;
    return x * y;
}
