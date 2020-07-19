// Program 10-4  Johnston's Dice Game

//File: Ch10Die.h

#ifndef _CH10DIE_H
#define _CH10DIE_H

#include <string>

using namespace std;

enum Color {red, white, blue };
class Die
{
private:
	int face;
	Color color;
public:	
	
// constructor--sets the face to 1 and color to red
	 Die();				

	//
// RollDie uses rand() to obtain a random value from 1 to 6 
	void RollDie(){ face = rand()%6+1; }	

// FaceUp returns the face value
	int FaceUp() { return face;}  	 
};



#endif