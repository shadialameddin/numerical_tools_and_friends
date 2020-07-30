// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10MasterClock.h

#ifndef _MASTERCLOCK_H
#define _MASTERCLOCK_H
#include "Ch10Time.h"
#include <time.h>

class MasterClock
{
private:
	time_t SystemTime;         // time_t format 
public:
	MasterClock() {} ;
	void SetTimeObject(Time *N);
};

#endif
