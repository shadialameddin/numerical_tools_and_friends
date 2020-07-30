/*Program 9-9   Compare Two Cards
This program will use a class Card that represents playing card objects. */

//File: Ch9ComparisonOfCardsDriver.cpp

#include "Ch9ComparisonOfCards.h"
#include <iostream.h>

int main()
{
    Card first_card, second_card;   // we will use 2 cards

    first_card.SetRank(ace);
    first_card.SetSuit(club);
    second_card.SetRank(ace);
    second_card.SetSuit(heart);

// the second card has a higher value than the first card

// Show the cards and compare

    cout << "\n First card is ";
    first_card.ShowCard();
    cout << "\n Second card is ";
    second_card.ShowCard();                       
    
	if(first_card > second_card)
        cout << "\n The first card is greater than the second card.\n";
    else
        cout << "\n The first card is not greater than the second card.\n";

// now set the card to two spades

    first_card.SetRank(ace);
    first_card.SetSuit(club);
    second_card.SetRank(king);
    second_card.SetSuit(spade);

    // Show the cards and compare

    cout << "\n First card is ";
    first_card.ShowCard();
    cout << "\n Second card is ";
    second_card.ShowCard();          
    
	if(first_card > second_card)
        cout << "\n The first card is greater than the second card.";
    else
        cout << "\n The first card is not greater than the second card.";

    cout << "\n\n Aren't overloaded operators great? \n";

    return 0;
}
                                      