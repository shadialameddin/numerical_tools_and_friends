//Program 11-6 CBoss2  CBoss class  derived from CEmployee 

//File:  Ch11CBoss2.cpp

#include <iostream.h>
#include "Ch11CBoss2.h"

void CBoss::GetEmpInfo()
{
    CEmployee::GetEmpInfo();
    cout << "\n\n What is my bonus this year? $$$$$$  ";
    cin >> bonus;
}

void CBoss::WriteEmpInfo()
{
    CEmployee::WriteEmpInfo();
    cout << "\n    Bonus:  $" << bonus;
}
                                                
