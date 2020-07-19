// Program 10-4  Johnston's Dice Game

//File: Ch10DiceGameDriver.cpp

#include "Ch10DicePlayer.h"
#include "Ch10Die.h"
#include <iostream>	
#include <string>		// will use C++ string class
#include <time.h>		// will obtain system time as UTC for seeding rand # gen.

using namespace std;

int main()
{
	cout << "\n Welcome to Johnston's Dice Game \n\n";
	 
	DicePlayer First("Richard"), Second("Steve");    // We have 2 DicePlayers
	
	time_t ltime;
	time( &ltime );   // fills the ltime struct with the UTC time, a large integer value

	int seed = (int)ltime;

	srand(seed);   // seed the random number generator with 123

	bool go = true;

	int score1, score2;

	while(go)
	{
		First.RollTheDice();
		Second.RollTheDice();

		score1 = First.ReportSum();
		score2 = Second.ReportSum();

		First.TellWhoAndHowMuch();
		Second.TellWhoAndHowMuch();

	 
		if(!First || !Second)
		{
			cout << "\n SOMEONE HAS EXACTLY 50 POINTS! ";
			if(!First) First.ReportSum();
			else  Second.ReportSum();
			cout << " AND WINS $1,000,000!!  \n";
			go = false;
		}

		else if(score1 >= 100 && score2 >= 100)
		{
			cout << "\n BOTH PLAYERS ARE OVER 100, IT'S A TIE";
			go = false;
		}
		else if(score1 >= 100 || score2 >= 100)
		{
			cout << "\n SOMEONE HAS REACHED 100 POINTS! \n\n  ";

			if(score1 >= 100) First.TellWhoAndHowMuch();
			else Second.TellWhoAndHowMuch();
			cout << " He/She is the winner! \n";
			go = false;
		}
	}
	cout << "\n Game Over " << endl;
	return 0;
}