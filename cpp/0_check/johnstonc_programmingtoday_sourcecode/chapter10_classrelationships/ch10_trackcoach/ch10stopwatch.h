// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10StopWatch.h

#ifndef _STOPWATCH_H
#define _STOPWATCH_H
#include "Ch10Time.h"

class StopWatch
{
private:
	Time Begin, Finish, Elapsed;

public:
	StopWatch() {};  //constructor 
	void Start();  // starts the watch--obtains the Beginning time
	void Stop();   // stops the watch--obtains the Finish time and calc Elaped time
	void ReportTime(); 
};

#endif
