//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

//File:  Ch11CBoss.cpp

#include <iostream.h>
#include "Ch11CBoss.h"

void CBoss::WhatsMyBonus()
{
	cout << "\n\n What is my bonus this year? $$$$$$  ";
	cin >> bonus;
}

void CBoss::WriteBonus()
{
	cout << "\n    Bonus:  $" << bonus;
}
