//Program 9-9   Compare Two Cards--Array of Objects

//File: Ch9ComparisonOfCards.cpp

#include "Ch9ComparisonOfCards.h"
#include <iostream.h>

int Card::operator > (Card X)
{
                        // first check the number
    if( number > X.number) return 1;

    else if(number < X.number)return 0;

    //now if the numbers are the same, check the suit
    if( color > X.color)return 1;
    else return 0;


}

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
        case spade:     cout << char(6) << " ";  break;
        case heart:     cout << char(3)<< " ";   break;
        case diamond:   cout << char(4)<< " ";   break;
        case club:      cout << char(5)<< " ";   break;
    }                                                       
}



