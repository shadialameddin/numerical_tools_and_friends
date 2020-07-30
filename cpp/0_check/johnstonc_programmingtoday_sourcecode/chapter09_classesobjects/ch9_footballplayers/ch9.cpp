//Program 9-12 Football Players

//File: Ch9FootballPlayersDriver.cpp


#include "Ch9FootballPlayers.h"
#include <iostream.h>
#include <fstream.h>
#include <stdlib.h>

int ReadFootballPlayers(char *input, FPlayer team[], int* total);
void SortEm(FPlayer [], int total);

int main()
{
    FPlayer team[5];  // a team of football player objects
    int total;

    cout << "\n\n Sorting Football Player Objects  \n" <<
        "\n Hit an enter to continue:  ";

    char enter;                      
    cin.get(enter);
    char* input = "Players.dat";

    int error = ReadFootballPlayers(input, team, &total);
    if(error)
    {
        cout << "\n\n couldn't find file " << input;
        exit(1);
    }

    cout << "\n\n The original Players.dat file is: ";
    for (int i= 0; i < total; ++ i)
    {
        team[i].WriteInfo();
    }

    SortEm(team, total);

    cout << "\n\n The sorted Players array is: ";
                                                       
   for ( i= 0; i < total; ++ i)
    {
        team[i].WriteInfo();
    }

    cout << "\n\n These are big fellows! \n\n";

   
    return 0;
}

void SortEm(FPlayer team[], int total)
{
// a classic bubble sort, using FPlayers object, sorts from low to high

    int i, j;
    FPlayer temp;
    for(i = 0; i < (total - 1) ; ++i)           
    {
        for(j = 1; j < total; ++j)
        {
            if(team[j-1] > team[j] )
            {
                temp = team[j];
                team[j] = team[j-1];
                team[j-1] = temp;
            }
        }
    }
}

int ReadFootballPlayers(char *filename, FPlayer team[], int *total)
{                           
    //opens and reads the input filename, and fills the team data

    int wt, ft, in;

    ifstream input;
    input.open(filename, ios::in|ios::nocreate);

    if(!input)return 1;

    char buf[50], junk;

    input.getline(buf,50);
    *total = atoi(buf);

    for(int i = 0; i < *total; ++ i)
    {
        input.getline(buf,50);
        team[i].SetName(buf);
        input >> ft >> in >> wt;         
        input.get(junk);
        team[i].SetWeight(wt);
        team[i].SetHeight(ft,in);
    }

    input.close();

    return 0;
}
