// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10TrackCoach.h

#ifndef _TRACKCOACH_H
#define _TRACKCOACH_H

#include "Ch10StopWatch.h"

class Track_Coach
{
public:
	StopWatch Watch;     // the watch must be public to be able to access it
	void YellOutTime();  // reports the elasped time
};

#endif