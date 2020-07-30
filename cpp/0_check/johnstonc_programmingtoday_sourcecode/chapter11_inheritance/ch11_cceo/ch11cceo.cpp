//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

//File:  Ch11CCEO.cpp

#include <iostream.h>
#include "Ch11CCEO.h"

void CCEO::HowManySharesDoIGet()
{
	cout << "\n How many shares do I get?  ";
	cin >> stock_options;

}

void CCEO::WriteShares()
{
	cout << "\n   Shares:  " << stock_options;
}

