//Program 7-15 Playing Cards

//File: PlayingCards.cpp

#include <iostream.h>
#include <iomanip.h>

enum Suit { club, diamond, heart, spade};
enum Rank { two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace};

struct Card
{
	Suit color;
	Rank number;
};

int main()
{
	Card cards[52];   // we have 52 cards, each card will have a suit and rank

	//now use the integer enumeration values to initialize the array element
	int i, j, card_ctr = 0;              // array index for cards
	for (i = 0; i < 4; ++i)             // this loop is for the 4 suits
	{
	  	for(j = 2; j < 15; ++j)         // this loop is for the card ranks
		{
			cards[ card_ctr].color = (Suit)i; //cast integer values to assign 
			cards[ card_ctr].number = (Rank) j;
			++ card_ctr;
		}
	}

	//now lets write out the cards and use the ASCII symbol for card suits
	int temp_rank;  // save some typing
	card_ctr = 0;  // reset card index to zero
	for(i = 0;  i < 4; ++i) 
	{
		for(j=2 ; j < 15; ++j)
		{                                     // first the number
			temp_rank = cards[card_ctr].number;
			if( temp_rank < 11) cout << cards[card_ctr].number;
			else if(temp_rank == jack) cout << "J";
			else if(temp_rank == queen) cout << "Q";
			else if(temp_rank == king) cout<< "K";
			else cout << "A";
		
			switch(cards[card_ctr].color)         //now the suit
			{
				case spade: cout << char(6) << " "; break;  //spades
				case heart: cout << char(3) << " "; break;  //hearts
				case diamond: cout << char(4) << " "; break;  //diamonds
				case club: cout << char(5) << " "; break;  //clubs
			}
			++ card_ctr;
		}
		cout << endl;
	}
	return 0;
}
