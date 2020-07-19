//Program 9_2 Daytime   class declaration with constructor functions 

//File: Ch9_DaytimeDriver.cpp

#include <iostream.h>
#include "Ch9DayTime.h"


int main()
{
    cout << "\n Welcome to the DayTime Program!  \n ";

    DayTime Initial;
    DayTime Later(Tues, 12, 0, 0);

    cout << "\n\n Writing out the values in Initial Object. ";
    Initial.ShowDayTime();                                          
    cout << "\n\n Writing out the values in Later Object. ";
    Later.ShowDayTime();

    cout << "\n\n Changing Initial Object to Fri 3:15:30 and writing out.";
    Initial.ResetDayTime(Fri, 3, 15, 30);
    Initial.ShowDayTime();

    cout << "\n\n Changing Later Object to Wed 23:35:40 and writing out.";
    Later.ResetDayTime(Wed, 23, 35, 40);
    Later.ShowDayTime();

    cout << "\n\n All done \n";
    return 0;
}                                                