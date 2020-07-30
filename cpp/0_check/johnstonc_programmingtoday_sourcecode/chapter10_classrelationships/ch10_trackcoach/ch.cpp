// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10Time.cpp

#include "Ch10Time.h"
#include <iostream.h>


Time::Time()
{
	hr = min = 0;
	sec = 1;
}

void Time::Reset(int h, int m, int s)
{
	hr = h;
	min = m;
	sec = s;
}

void Time::ShowTime()
{
	cout <<  hr << ":" << min << ":" << sec << endl;
}

Time Time::operator - (Time N)
{
	Time temp;
	temp.hr = hr - N.hr;
	temp.min = min - N.min;
	temp.sec = sec - N.sec;
	return temp;
}