//Program 9-2 DayTime      class declaration with constructor functions

//File: Ch9Daytime.h

#ifndef _CH9DAYTIME_H
#define _CH9DAYTIME_H


enum Day {Sun, Mon, Tues, Wed, Thur, Fri, Sat};

class DayTime
{
    private:
        int hr, min, sec;
        Day whichday;

    public:
        DayTime();     // constructor, will set to Sun 0:0:1
        DayTime(Day WD, int h, int m, int s);  // will set to WD h:m:s
        void ShowDayTime();                          
        void ResetDayTime(Day WD, int h, int m, int s);
};

#endif
                                     