//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

//File: Ch10ShopperDriver.cpp
  
#include "Ch10Cart.h"
#include "Ch10Clerk.h"
#include "Ch10Shopper.h"
#include <iostream>
#include <string>

using namespace std;

int main()
{
	Shopper Ed;
	Clerk Gladys;

	float HowMuchEdOwes, PayOut;

	Item LemmeSeeIt;

	// Ed's first item is potato chips
	LemmeSeeIt.price = (float) 2.99;
	LemmeSeeIt.name = "potato chips";

	Ed.SqueakyWheels.AddItemToCart(LemmeSeeIt);

	// Ed's second item is coffee
	LemmeSeeIt.name = "coffee";
	LemmeSeeIt.price = (float)8.99;


	Ed.SqueakyWheels.AddItemToCart(LemmeSeeIt);

	// Ed is now ready to check out.  Gladys will look in Ed's cart and figure the total.

	HowMuchEdOwes = Gladys.FigureTotal(&Ed.SqueakyWheels);

	cout << "\n Ed owes Gladys " << HowMuchEdOwes;

	PayOut = Ed.GetMoneyFromWallet(HowMuchEdOwes);

	cout << "\n Ed can pay Gladys " << PayOut;

	cout << "\n\n Shopping is hard work! \n";

	return 0;
}


