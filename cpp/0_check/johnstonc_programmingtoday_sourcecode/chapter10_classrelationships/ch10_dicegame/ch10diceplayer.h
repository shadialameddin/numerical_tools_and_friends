// Program 10-4  Johnston's Dice Game

//File: Ch10DicePlayer.h

#ifndef _DICEPLAYER_H
#define _DICEPLAYER_H
#include "Ch10Die.h"
#include <iostream>

using namespace std;

class DicePlayer
{
private:
	string name;
	Die MyDice[5];
	int total;
public:
	DicePlayer(string n);		//constructor sets the player's name
	void RollTheDice();			// rolls all five dice and adds faces to total
	int ReportSum( ) { return total; }
	void TellWhoAndHowMuch(); 
	int operator !();			// return a 1 if the total is 100
};

#endif
