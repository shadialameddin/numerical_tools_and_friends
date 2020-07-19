//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

//File: Ch10Clerk.cpp

#include "Ch10Cart.h"
#include "Ch10Clerk.h"

float Clerk::FigureTotal(Cart *pCart)
{
	int i, CheckOutTotal;
	Item TheItem;
	CheckOutTotal = pCart->HowManyInCart();

	for (i = 0; i < CheckOutTotal; ++i)
	{
		TheItem = pCart->RetrieveNextItem();
		total = TheItem.price + total;
	}
	return total;
}