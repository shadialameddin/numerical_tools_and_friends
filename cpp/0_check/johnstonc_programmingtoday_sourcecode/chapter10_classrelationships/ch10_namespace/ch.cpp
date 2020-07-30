//Program 10-1 Namespace  A program to illustrate different namespaces

//File: Ch10Namespace.cpp

#include "Ch10Namespace.h"
#include <iostream>
#include <math.h>
using namespace std;

int main()
{
    srand(123);

    int StdNumber = rand();
    cout << "\n The number from the standard rand is " << StdNumber;

    int MyNumber = MyOwn::rand();
    cout << "\n The number from my own rand is " << MyNumber;

    double RealSqrt = sqrt(25.0);
    cout << "\n The real square root is " << RealSqrt;

    int MySqrt = MyOwn::sqrt();
    cout << "\n My square root is " << MySqrt;     


    cout << "\n All done. \n";

    return 0;
}
                                