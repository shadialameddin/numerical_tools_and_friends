//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

//File:  Ch11CBoss.h

#ifndef  _CBOSS_H
#define  _CBOSS_H

#include "Ch11CEmployee.h"


class CBoss: public CEmployee
{
protected:
	float bonus;
public:
	void WhatsMyBonus();
	void WriteBonus();
};

#endif
