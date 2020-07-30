//Program 7-2 Jack's Race Program with Person data structures.

//File: JacksRace.cpp

#include <iostream.h>
#include <string.h>

struct Person
{
    char name[40];
    char sex;            // m = male, f = female
    int age;
    int category;    // racers grouped by age, such as 1 = 0-9, 2 = 10-19,etc.

    int race;        // races have an integer code   1 = 5K, 2 = 10K, 3 = marathon

};

int main()
{
    Person runner;

    cout << "\n On your marks, get set....\n\n";
    // We fill the runner and time information in assignment statements.
    strcpy(runner.name, "Jack Rabbit");
    runner.sex = 'm';
    runner.age = 17;
    runner.category = 2;
    runner.race = 1;

    // write out runner's info

    cout << "\n Runner's name: " << runner.name;
    cout << "\n Sex:  " << runner.sex << "\n Age: " << runner.age;
    cout << "\n Age Category:  " << runner.category;
    cout << "\n Race Code: " << runner.race << endl;

    cout << "\n\n GO! \n\n";

    return 0;
}                            
                                                                         