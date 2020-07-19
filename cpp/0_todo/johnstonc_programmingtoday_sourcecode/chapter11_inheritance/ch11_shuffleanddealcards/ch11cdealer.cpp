//Program 11-12   Deal the Cards and Inheritance

//File: Ch11CDealer.cpp

#include <iostream.h>
#include <stdlib.h>   //for srand and rand
#include "Ch11Card.h"
#include "Ch11CDealer.h"


CDealer::CDealer()  
{
	//The CDealer constructor will set up the 52 cards and set top of deck to zero

	cout << "\n In the Dealer constructor.  ";

	top_card = 0;
	int i, j, card_ctr = 0;  // array index for cards

	  for (i = 3; i >= 0; --i)  // this loop is for the 4 suits
	  {
		for(j = 14; j >=2; --j)
		{
			 card[card_ctr].SetSuit((Suit) i); 
			 card[card_ctr].SetRank((Rank) j);
			 ++ card_ctr;
		}
	}

	for (i=0; i<52; ++i) index[i]=i;  // fill index array w/ integers
}

void CDealer::Shuffle()
{
	
	int i, random, top_card = 0;
	
	bool check[52];
	
	//zero all values in the check array--this will keep track of #'s we've used
	for(i=0; i<52; ++i) check[i] = false;

	int got_a_good_one = 0;

	for(i=0; i < 52 ; ++i)    // we will get a random number for each index value
	{	
		while( got_a_good_one == 0)   // loop until we get a non-used number
		{	
			random = rand()%52;   // gives us a number between 0 - 51						
			if(check[random] == false)
			{
				
				index[i] = random;     // set the indexput random into index array
				check[random] = true;   // set check on--this number has been used
				got_a_good_one = 1;
			}
		}
		got_a_good_one = 0;  // ready for next one
	}

}


void CDealer::ShowOrigCards()
{

	// write out the cards by use the ASCII symbol for card suits
	int i, card_ctr = 0;
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
}

void CDealer::ShowShuffledCards()
{

	// write out the cards using the index array--shuffled order
	int i, card_ctr = 0;
	for(i = 0;  i < 52; ++i)
	{
		card[ index[i] ].ShowCard();
		card_ctr++;
		
		if( card_ctr == 13 )
		{
			cout << endl;   // newline if new suit
			card_ctr = 0;
		}
	}

}

void CDealer::Deal4Cards(CPlayer *who)
{

	int i;
	for(i = 0; i<4; ++i)
	{

		who->GetCard(card[index[top_card]]) ;
		this->Hand[i] = card[index[top_card + 1]];
		top_card += 2;

	}
	this->cards_in_hand = 4;

}

