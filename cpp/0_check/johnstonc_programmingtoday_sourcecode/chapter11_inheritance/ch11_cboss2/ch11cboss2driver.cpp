//Program 11-6 CBoss2  CBoss class  derived from CEmployee 

//File: Ch11CBossDriver2.cpp


#include <iostream.h>
#include "Ch11CBoss2.h"


int main()
{

    cout << "\n\n Work, Work, Work. \n";

    CBoss manager;

    manager.GetEmpInfo();
    manager.WriteEmpInfo();
                                     
    cout << "\n\n No more work to do.\n\n";
    return 0;

}