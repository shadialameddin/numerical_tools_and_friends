//Program 11-12   Deal the Cards and Inheritance

//File: Ch11Player.cpp

#include <iostream.h>
#include "Ch11Card.h"
#include "Ch11CPlayer.h"



CPlayer::CPlayer()
{
	cout << "\n In the CCPlayer constructor. ";
	cards_in_hand = 0;;

} 

void CPlayer::GetCard(Card newcard)
{
	Hand[cards_in_hand] = newcard;
	++cards_in_hand;

}
void CPlayer::ShowHand()
{
	int i;

	for(i=0; i < cards_in_hand; ++i) Hand[i].ShowCard();

	cards_in_hand = 0; //reset count for next hand
}
