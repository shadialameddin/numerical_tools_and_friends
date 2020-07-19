//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

//File:  Ch11CCEO.h

#ifndef  _CCEO_H
#define  _CCEO_H

#include "Ch11CBoss.h"


class CCEO: public CBoss
{
protected:
	int stock_options;
public:
	void HowManySharesDoIGet();
	void WriteShares();
};

#endif
