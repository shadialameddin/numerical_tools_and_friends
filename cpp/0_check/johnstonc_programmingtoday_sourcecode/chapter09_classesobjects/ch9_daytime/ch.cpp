//Program 9-2  DayTime  class declaration with constructor functions

//File: Ch9_DayTime.cpp 

#include <iostream.h>              //needed for cout
#include "Ch9DayTime.h"

DayTime::DayTime()            //  1st constructor
{
    hr = min = 0;
    sec = 1;
    whichday = Sun;
}

DayTime::DayTime(Day WD, int h, int m, int s)   // 2nd constructor
{
    hr = h;
    min = m;
    sec = s;                               
    whichday = WD;
}


void DayTime::ShowDayTime()
{
    char days[7][8] = {"Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat" };

    cout << "\n The Day and Time is: " << days[whichday]
        << " " << hr << ":" << min << ":" << sec;

}


void DayTime::ResetDayTime(Day WD, int h, int m, int s)
{
    hr = h;
    min = m;
    sec = s;                                                                whichday = WD;
}                           
