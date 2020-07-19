/*Program 11-12   Deal the Cards and Inheritance

File: Ch11ShuffleAndDealCardsDriver.cpp

This program will use a class Card and class Dealer that will shuffle and deal
the cards. 

The Dealer is a Player   */

#include <iostream.h>
#include <stdlib.h>
#include "Ch11CDealer.h"
#include "Ch11CPlayer.h"

int ShowMenu();

int main()
{
	cout <<"\n Welcome to the Shuffle and Deal Program!"
		<< "\n\n Please enter an integer for the random number generator seed.   ";

	char buf[10];
	int seed;cin.getline(buf,10);
	seed=atoi(buf);
	srand(seed);

	CDealer Bob;   // we have Bob, our Dealer Object, he has 52 Cards
	CPlayer Lucy;  // we have Lucy, our Player Object

	Bob.Shuffle();  // Our dealer shuffles the deck before we get started

	int choice, enough;
	bool goodbye = false;
	while (goodbye == false)
	{
		choice = ShowMenu();  // Shows user options

		switch(choice)
		{
		case 1:   // show cards
			Bob.ShowOrigCards(); 
			break;
		case 2:    // show shuffled card
			Bob.ShowShuffledCards(); 
			break;
		case 3:
			Bob.Shuffle();	
			Bob.ShowShuffledCards(); 
			break;	
		case 4:    // deal 4 cards to the dealer and player
			enough = Bob.WhereIsTheTop();
			if(enough < 43)
			{
				Bob.Deal4Cards(&Lucy);
				cout << "\n Player--Lucy's Hand: ";
				Lucy.ShowHand();  // Player shows her hand
				cout << "\n Dealer--Bob's Hand: ";
				Bob.ShowHand();  //Dealer shows his hand
			}
			else
				cout << "\n\n Not enough cards to deal, sorry.  \n";
		
			break;
		
		case 5:
			goodbye = true;
			break;
		default:
			cout << "\n I don't do that option!  \n ";
		}
	}
	cout << "\n Good bye!!  \n";

	return 0;
}

int ShowMenu()
{
	int choice;
	char buf[6];
	cout << "\n Pick your option:"
		<< "\n\n 1 Show Original Deck         3 New Shuffle"
		<< "\n 2 Show Shuffled Cards        4 Deal 4 Cards and Show Hands    5 Exit  \n\n" ;
	cin.getline(buf,6);
	choice = atoi(buf);
	return choice;
}
	
