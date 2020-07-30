//Program 10-3 Shopper and Check-out Clerk     Shoppper uses a Cart 
  
//File: Ch10Shopper.h

#ifndef _CH10SHOPPER_H
#define _CH10SHOPPER_H
#include "Ch10Cart.h"

class Shopper
{
private:
	float wallet;

public:
	Shopper() { wallet = 100.00; }   

	float GetMoneyFromWallet(float);
	void PutItemInCart(Item, Cart*);
};

#endif