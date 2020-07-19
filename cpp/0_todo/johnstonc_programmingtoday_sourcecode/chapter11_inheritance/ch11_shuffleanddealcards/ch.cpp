//Program 11-12   Deal the Cards and Inheritance

//File: Ch11Card.cpp

#include <iostream.h>
#include "Ch11Card.h"

Card::Card()
{
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

int Card::operator >(Card N)
{
	if(number > N.number)return 1;
	if(number == N.number)
	{
		if(color > N.color)return 1;
		else return 0;
	}
	return 0;
}
