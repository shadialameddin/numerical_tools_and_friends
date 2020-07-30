/*Program 9-6   Show Me The Cards 
This program will use a class Card that represents playing card objects. */

//File: Ch9Cards.cpp

#include "Ch9Cards.h"
#include <iostream.h>

Card::Card()
{
	cout << " Hi, I'm in the constructor.\n";
	color = club;
	number = two;
}

void Card::ShowCard()
{
	if(number < 11) cout << number;
	else if(number == jack) cout << "J";
	else if(number == queen) cout << "Q";
	else if(number == king) cout<< "K";
	else cout << "A";
		
	switch(color)
	{
		case spade:		cout << char(6) << " ";  break;  
		case heart:		cout << char(3)<< " ";	 break;   
		case diamond:	cout << char(4)<< " ";	 break;  
		case club:		cout << char(5)<< " ";	 break; 
	}
}