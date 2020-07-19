// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10TrackCoachDriver.cpp

#include "Ch10MasterClock.h"
#include "Ch10StopWatch.h"
#include "Ch10Time.h"
#include "Ch10TrackCoach.h"
#include <iostream.h>
#include <time.h>

int main()
{
	Track_Coach John;    // John is our track coach. He has a stopwatch.
	
	// John is going to time us doing 100,000,000 floating point multiplication

	int i;
	double result;

	John.Watch.Start();  // John starts his watch.
	for(i=0; i < 100000000 ; ++i)
	{
		result = 5.234 * 4.23546;  // multiply 2 numbers 100,000,000 times
	}
	John.Watch.Stop();

	John.YellOutTime();
	

	
	return 0;
}