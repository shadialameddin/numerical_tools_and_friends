//Program 9-12 Football Players

//File: Ch9FootballPlayers.h
                               
#ifndef _CH9FOOTBALLPLAYERS_H
#define _CH9FOOTBALLPLAYERS_H

#include <string.h>
#include <iostream.h>

class FPlayer
{
private:
    int weight, feet, inches, totalinches;
    char name[25];
public:
    FPlayer(){ cout << "\n I'm in the constructor. ";};
    void SetName(char* n) { strcpy(name,n);}
    void SetWeight(int w) { weight = w;}
    void SetHeight(int ft, int in);
    void WriteInfo();

    bool operator > (FPlayer p);
                                      
};

#endif
