#include <cassert>
#include <iostream>
#include <vector>

template <typename vec>
class vec_expression
{
public:
    void print(){std::cout<<"hi"<<'\n';}
};

template <typename vec>
class sub_class : public vec_expression<vec>
{

};

int main()
{
    vec_expression<int> vv;
    vv.print();
    sub_class<double> ss;
    ss.print();
}
