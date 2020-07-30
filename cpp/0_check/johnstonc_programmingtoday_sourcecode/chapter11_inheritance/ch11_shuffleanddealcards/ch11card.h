//Program 11-12   Deal the Cards and Inheritance

//File: Ch11Card.h

#ifndef _CH11CARD_H
#define _CH11CARD_H

enum Suit { club, diamond, heart, spade};
enum Rank { two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace};

class Card 
{
private:
	Suit color;
	Rank number;
public:
	Card();
	void SetSuit(Suit s ){ color = s; }
	void SetRank(Rank r ){ number = r; }
	void ShowCard();
	int operator > (Card N);
};

#endif