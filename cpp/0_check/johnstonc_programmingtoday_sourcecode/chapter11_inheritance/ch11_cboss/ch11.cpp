//Program 11-4  CEmployee and CBoss    CBoss class is derived from CEmployee class  

//File:  Ch11CBossDriver.cpp

#include <iostream.h>
#include "Ch11CBoss.h"
#include "Ch11CEmployee.h"


int main()
{
	
	cout << "\n\n Work, Work, Work. \n";
	
	CBoss manager;


	manager.GetEmpInfo();
	manager.WhatsMyBonus();

	manager.WriteEmpInfo();
	manager.WriteBonus();


	cout << "\n\n No more work to do.\n\n";
	return 0;

}

