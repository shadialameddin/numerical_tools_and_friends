//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

//File: Ch10Cart.cpp

#include "Ch10Cart.h"

Item Cart::RetrieveNextItem()
{
	Item next;
	next = stuff[WhichItem];
	++WhichItem;
	return next;
}

void Cart::AddItemToCart(Item newthing)
{
	stuff[HowMany] = newthing;
	++ HowMany;
}
