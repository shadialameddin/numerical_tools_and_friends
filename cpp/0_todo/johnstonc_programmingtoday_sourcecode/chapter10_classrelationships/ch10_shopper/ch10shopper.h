//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

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

	Cart SqueakyWheels;   // our shopper has a cart called SqueekyWheels
	float GetMoneyFromWallet(float);

};

#endif