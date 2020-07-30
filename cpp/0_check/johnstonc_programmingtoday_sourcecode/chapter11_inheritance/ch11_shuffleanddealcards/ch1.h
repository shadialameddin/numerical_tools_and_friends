//Program 11-12   Deal the Cards and Inheritance

//File: Ch11CDealer.h

#ifndef _CH11CDEALER_H
#define _CH11CDEALER_H

#include "Ch11Card.h"
#include "Ch11CPlayer.h"

class CDealer: public CPlayer
{
private:
	Card card[52];
	int index[52];
	int top_card;  // index that points at the top card in the deck
		
public:

	CDealer() ;

	void Shuffle();
	void ShowOrigCards();
	void ShowShuffledCards();
	void Deal4Cards(CPlayer* X);
	int WhereIsTheTop() { return top_card;}

};

#endif


