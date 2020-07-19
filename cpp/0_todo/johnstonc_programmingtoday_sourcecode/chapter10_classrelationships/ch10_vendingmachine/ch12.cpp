// Program 10-6   Acme Vending Machines

//File: Ch10MoneyCtr.cpp

#include "Ch10MoneyCtr.h"
#include <iostream>

using namespace std;

void MoneyCtr::GetMoney()
{
    float coin;
    char buffer[10];
    cout << "\n Please enter your coin value in pennies"
			" Quarter = 25, Dime = 10, etc.  ";
    cin.getline(buffer,10);
    coin = atof(buffer);
    input_amount += coin/100.0;
    cout.setf(ios::fixed);
    cout.precision(2);
    cout << "\n Total Money $" << input_amount;
}

void MoneyCtr::ReturnMoney(float change)
{
    cout << "\n Your change back is:  " << change;
    Clear();
}
