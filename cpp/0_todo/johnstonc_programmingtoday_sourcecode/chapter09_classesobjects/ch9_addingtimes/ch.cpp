/*Program 9-8   Adding Times with overloaded operator +

This program uses a time object that is based on the 24 hour clock 
0:0:1 is one minute after midnight
24:0:0 is midnight*/

//File: Ch9AddingTimes.cpp

#include <iostream.h>

class Time
{
private:
	int hr, min, sec;
public:
	Time();    //sets the time object to 0:0:1
	Time(int h, int m, int s);   //sets the time object to h:m:s
	void Reset(int h, int m, int s); // resets time to h:m:s
	void ShowTime();
	Time operator + (Time N);
	
};

Time::Time()
{
	hr = min = 0;
	sec = 1;
}

Time::Time(int h, int m, int s)
{
	hr = h;
	min = m;
	sec = s;
}

void Time::Reset(int h, int m, int s)
{
	hr = h;
	min = m;
	sec = s;
}

void Time::ShowTime()
{
	cout << "\n The time is: " << hr << ":" << min << ":" << sec;
}

Time Time:: operator +(Time N)
{
	Time result;
	int divisor;

	result.sec = sec + N.sec;           // add the seconds

/*if more than 60, divide to get minutes, remainder will be new seconds 
	add additional minutes to new minute  */
	divisor = result.sec/60;      
	result.sec= result.sec%60;
	
	result.min = min + N.min + divisor;

// same thing if minutes is over 60 

	divisor = result.min/60;
	result.min = result.min%60;

	result.hr = hr + N.hr + divisor;

	return (result );
}


int main()
{
	Time First(3,4,5), Second(10,11,12), Third;
	
	Third = First + Second;

	Third.ShowTime();

	First.Reset(15,30,55);
	Second.Reset(3,45,15);

	Third = First + Second;
	Third.ShowTime();


	cout << "\n All done adding Time objects!  \n\n";
	return 0;
}