//Program 11-4  CEmployee and CBoss    CBoss class is derived from CEmployee class  

//File:  Ch11CBoss.cpp

#include <iostream.h>
#include "Ch11CBoss.h"
#include "Ch11CEmployee.h"

void CBoss::WhatsMyBonus()
{
	cout << "\n\n What is my bonus this year? $$$$$$  ";
	cin >> bonus;
}

void CBoss::WriteBonus()
{
	cout << "\n    Bonus:  $" << bonus;
}
