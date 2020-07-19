//Program 11-12   Deal the Cards and Inheritance

//File: Ch11CPlayer.H


#ifndef _CH11CPLAYER_H
#define _CH11CPLAYER_H

#include "Ch11Card.h"


class CPlayer 
{
protected:
	Card Hand[4];    // the players have a hand of cards
	int cards_in_hand;
	
public:
	CPlayer();
	void GetCard( Card X );
	void ShowHand();
	
};

#endif