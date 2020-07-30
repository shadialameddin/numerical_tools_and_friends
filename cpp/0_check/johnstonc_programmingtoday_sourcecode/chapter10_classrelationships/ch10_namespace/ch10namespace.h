//Program 10-1 Namespace  A program to illustrate different namespaces

//File: Ch10Namespace.cpp

#ifndef _CH10NAMESPACE_H
#define _CH10NAMESPACE_H

namespace MyOwn
{
    int rand();
    int sqrt();
};

int MyOwn::rand()
{
    return 42;  // my number is always 42
}

int MyOwn::sqrt()
{
                           
    return 52;  //sqrt always returns a 52
}

#endif