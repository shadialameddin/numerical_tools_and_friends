//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

//File: Ch10Shopper.cpp

#include "Ch10Shopper.h"

using namespace std;

float Shopper::GetMoneyFromWallet(float cost)
{
	if(cost > wallet)
	{
		cout << "\n Not enough money!  Put something back! \n";
		return 0;
	}
	else
	{
		wallet = wallet-cost;
		return cost;
	}
}
