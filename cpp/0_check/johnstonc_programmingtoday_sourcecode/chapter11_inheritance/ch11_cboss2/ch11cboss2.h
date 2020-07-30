//Program 11-6 CBoss2  CBoss class  derived from CEmployee 

//File:  Ch11CBoss2.h

#ifndef  _CBOSS_H
#define  _CBOSS_H

#include "Ch11CEmployee.h"


class CBoss: public CEmployee
{
protected:
    float bonus;
public:                             
    void GetEmpInfo();
    void WriteEmpInfo();
};

#endif           