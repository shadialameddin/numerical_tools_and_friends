//Program 10-3 Shopper and Check-out Clerk     Shoppper uses a Cart 
  
//File: Ch10Shopper.cpp

#include "Ch10Shopper.h"

using namespace std;

void Shopper::PutItemInCart(Item newthing, Cart *pCart)
{
	pCart->AddItemToCart(newthing);
}


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