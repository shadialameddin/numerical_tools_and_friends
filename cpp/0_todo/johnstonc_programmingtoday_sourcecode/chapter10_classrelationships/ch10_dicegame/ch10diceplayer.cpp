// Program 10-4  Johnston's Dice Game

//File: Ch10DicePlayer.cpp

#include "Ch10DicePlayer.h"
#include <iostream>

using namespace std;

DicePlayer::DicePlayer(string n)
{
	name = n;
	total = 0;
}
	

void DicePlayer::RollTheDice()
{
	int i;
	for (i = 0; i<5; ++i)
	{
		MyDice[i].RollDie();
		total = total + MyDice[i].FaceUp();
	}
}

void DicePlayer::TellWhoAndHowMuch()
{
	cout << endl << name << " has " << total << " points.";
}
int DicePlayer::operator ! ()
{
	if (total==50)return 1;
	else return 0;
}
