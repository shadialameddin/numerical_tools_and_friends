//Program 7-15 What Time Is It?

//File: WhatTimeIsIt.cpp

#include <iostream.h>


struct Time
{
	int hr,min,sec;
};


Time GetTime();				//prototypes
bool ValidTime(Time);
void WriteTime(Time);

int main()
{
	Time MyTime;
	bool GoodTime;

	MyTime = GetTime();
	GoodTime = ValidTime(MyTime);

	WriteTime(MyTime); // write out the time
	if(GoodTime)
	   cout << " is a VALID time. \n";
	else
		cout << " is an INVALID time. \n\n";
	

	cout << "\n No more time for this program. \n";
	return 0;
}


Time GetTime()
{
	char colon;        //use colon for the input :
	Time local;        // local copy of time structure

	cout << "\n Please enter a time in the format:  HR:MIN:SEC "
	"\n Such as 5:14:43   or 8:33:14  \n\n";
	cin >> local.hr >> colon >> local.min >> colon >> local.sec;

	return local;

}

bool ValidTime(Time T)
{
	// for the 24-hour clock, valid hours are 0 - 23, valid sec/min are 0-59
	// only valid time if hr is 24 is 24:0:0
	// 0:0:0 is invalid 

	// first check for the two "edge" times:
	if(T.hr == 0 && T.min == 0 && T.sec == 0) return false;
	if(T.hr == 24 && T.min == 0 && T.sec == 0) return true;
	

	// now check for all out of bounds cases
	if(T.hr > 24 || T.hr < 0) return false;
	if(T.min < 0 || T.min > 59 || T.sec < 0 || T.sec > 59) return false;

	// if we get to here, we know we have a valid time
	return true;
}

void WriteTime(Time MyTime)
{
// Write out the time. 
	
		cout << "\n\n Your Time: "<<MyTime.hr << ":" <<
		MyTime.min << ":"  << MyTime.sec ;
}
