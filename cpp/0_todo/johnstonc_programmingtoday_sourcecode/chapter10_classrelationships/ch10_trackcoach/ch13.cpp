// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10StopWatch.cpp

#include "Ch10StopWatch.h"
#include "Ch10Masterclock.h"
#include <iostream.h>
#include <time.h>

void StopWatch::Start()
{
	MasterClock clock;
	clock.SetTimeObject(&Begin);   // we create a temp MasterClock and use it to set the time
	cout << "\n The starting time is:  ";
	Begin.ShowTime();
}

void StopWatch::Stop()
{
	MasterClock clock;
	clock.SetTimeObject(&Finish);   // we create a temp MasterClock and use it to set the time
	
	cout << "\n The stopping time is:  ";
	Finish.ShowTime();

	Elapsed = Finish - Begin;       // calculate elapsed time
}

void StopWatch::ReportTime()
{
	Elapsed.ShowTime();
}