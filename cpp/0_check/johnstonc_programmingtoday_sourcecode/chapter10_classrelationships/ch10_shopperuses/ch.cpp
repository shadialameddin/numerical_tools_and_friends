//Program 10-3 Shopper and Check-out Clerk     Shoppper uses a Cart 
  
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
