//Program 11-3  CEmployee        CEmployee class and file organization


//File:  Ch11CEmployeeDriver.cpp


#include <iostream.h>
#include "Ch11CEmployee.h"


int main()
{
	
	cout << "\n\n Work, Work, Work. \n";
	
	CEmployee worker;


	worker.GetEmpInfo();

	worker.WriteEmpInfo();

	cout << "\n\n No more work to do.\n\n";
	return 0;

}


