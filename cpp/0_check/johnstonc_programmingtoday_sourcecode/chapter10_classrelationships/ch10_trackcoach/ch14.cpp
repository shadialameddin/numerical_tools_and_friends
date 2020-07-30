// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10MasterClock.cpp

#include "Ch10MasterClock.h"
#include "Ch10Time.h"
#include <time.h>

void MasterClock::SetTimeObject(Time *N)
{
	
	time(&SystemTime);  // fill the time_t structure w/ system time info

	struct tm *OStime;
	OStime = localtime(&SystemTime);  //convert system time to tm struct

	N->Reset(OStime->tm_hour, OStime->tm_min,OStime->tm_sec);
}

