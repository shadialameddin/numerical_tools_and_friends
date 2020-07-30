// Program 10-5  TrackCoach has a stopwatch, which uses a masterclock

//File: Ch10Time.h

#ifndef _TIME_H
#define _TIME_H

class Time
{
private:
	int hr, min, sec;
public:
	Time();    //sets the time object to 0:0:1
	void Reset(int h, int m, int s); // resets time to h:m:s
	void ShowTime();
	Time operator -(Time N);  // need to be able to subtract times
	
};

#endif