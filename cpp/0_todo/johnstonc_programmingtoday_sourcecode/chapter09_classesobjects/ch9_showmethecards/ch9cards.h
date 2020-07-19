/*Program 9-6   Show Me The Cards 
This program will use a class Card that represents playing card objects. */

//File: Ch9Cards.h

#ifndef _CH9CARDS_H
#define _CH9CARDS_H

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
};

#endif