/*Program 9-6   Show Me the Cards 
This program will use a class Card that represents playing card objects. */

//File: Ch9CardsDriver.cpp

#include "Ch9Cards.h"
#include <iostream.h>

int main()
{
	Card card[52];   // we have 52 cards, each card will have a suit and rank

	//now use the integer enumeration values to initialize the array element

	  int i, j, card_ctr = 0;  // array index for cards

	  for (i = 0; i < 4; ++i)  // this loop is for the 4 suits
	  {
		for(j = 2; j < 15; ++j)
		{
			 card[ card_ctr].SetSuit((Suit) i); 
			 card[ card_ctr].SetRank((Rank) j);
			 ++ card_ctr;
		}
	}

	//now lets write out the cards by use the ASCII symbol for card suits
	card_ctr = 0;
	for(i = 0;  i < 52; ++i)
	{
		card[i].ShowCard();
		card_ctr++;
		
		if( card_ctr == 13 )
		{
			cout << endl;   // newline if new suit
			card_ctr = 0;
		}
	}

	return 0;
}

