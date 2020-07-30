//Program 10-2 Shopper and Check-out Clerk   The Shopper has a Cart

//File: Ch10Clerk.h

#ifndef _CH10CLERK_H
#define _CH10CLERK_H

class Clerk
{
private:
	float total;

public:
	Clerk() { total = 0.0; }
	float FigureTotal(Cart*);
};

#endif