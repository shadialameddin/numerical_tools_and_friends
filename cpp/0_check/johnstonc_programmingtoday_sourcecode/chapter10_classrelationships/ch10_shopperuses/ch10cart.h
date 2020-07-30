//Program 10-3 Shopper and Check-out Clerk     Shoppper uses a Cart 
  
//File: Ch10Cart.h

// set up structs for a Shopping Cart and Items that will go in the cart

#ifndef _CH10CART_H
#define _CH10CART_H

#include <iostream>

using namespace std;

struct Item
{
	string name;
	float price;
};


class Cart
{
private:
	Item stuff[50];
	int HowMany;
	int WhichItem;

public:
	Cart() { HowMany = 0;  WhichItem = 0;}  // constructor zeros out counter
	void AddItemToCart(Item newthing);
	Item RetrieveNextItem();
	int HowManyInCart(){return HowMany; }

};

#endif