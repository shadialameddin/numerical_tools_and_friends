// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10TrackCoach.cpp

#include "Ch10TrackCoach.h"
#include <iostream.h>

void Track_Coach::YellOutTime()
{
	cout << "\n YOUR ELASPED TIME IS ";
	Watch.ReportTime();
}
