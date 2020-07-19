//Program 9-12 Football Players

//File: Ch9FootballPlayers.cpp

#include "Ch9FootballPlayers.h"
#include <iostream.h>
#include <iomanip.h>
                                   
bool FPlayer::operator > (FPlayer p)
{
    // if two players are the same height, the heavier player is "bigger"

    if(feet > p.feet) return true;

    if(feet == p.feet)
    {
        if(inches > p.inches) return true;
        else if(inches == p.inches)
        {
            if(weight > p.weight) return true;
            else return false;
        }
        else return false;
    }
    else
        return false;
}                                             

void FPlayer::SetHeight(int ft, int in)
{
    feet = ft;
    inches = in;

}

void FPlayer::WriteInfo()
{
    cout << endl << setw(25) <<  name << setw(8) << feet << "' " << setw(3) <<
        inches << "\" "  << setw(8) << weight << " pounds";
}

    