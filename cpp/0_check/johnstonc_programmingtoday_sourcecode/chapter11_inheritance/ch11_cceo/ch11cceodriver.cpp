//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

//File:  Ch11CCEODriver.cpp

#include <iostream.h>
#include "Ch11CCEO.h"


int main()
{
	
	cout << "\n\n Work, Work, Work. \n";
	
	CCEO BigCheese;


	BigCheese.GetEmpInfo();
	BigCheese.WhatsMyBonus();
	BigCheese.HowManySharesDoIGet();
	
	BigCheese.WriteEmpInfo();
	BigCheese.WriteBonus();
	BigCheese.WriteShares();


	cout << "\n\n No more work to do.\n\n";
	return 0;

}

