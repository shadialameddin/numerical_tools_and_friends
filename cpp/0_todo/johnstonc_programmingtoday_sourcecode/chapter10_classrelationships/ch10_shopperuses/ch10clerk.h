//Program 10-3 Shopper and Check-out Clerk     Shoppper uses a Cart 
  
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