//Program 11-4  CEmployee and CBoss    CBoss class is derived from CEmployee class  

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
