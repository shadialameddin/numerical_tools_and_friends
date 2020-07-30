/*Program 9-11 Set a Time Object-by passing the 
address of the Time object to a SetTimeObject function.

The SetTimeObject function uses the functions in time.h to access the
system time. 
*/

//File: Ch9SetTime.cpp

#include <iostream.h>
#include <time.h>		//This is the C++ library time.h file

class Time
{
private:
	int hr, min, sec;
public:
	Time();    //sets the time object to 0:0:1
	void Reset(int h, int m, int s); // resets time to h:m:s
	void ShowTime();
	
};

Time::Time()
{
	hr = min = 0;
	sec = 1;
}

void Time::Reset(int h, int m, int s)
{
	hr = h;
	min = m;
	sec = s;
}

void Time::ShowTime()
{
	cout << "\n The time object: " << hr << ":" << min << ":" << sec;
}


void SetTimeObject(Time *pWatch);	//Function prototype, receives ptr to Time object

int main()
{
	Time MyWatch;  // create an object of class Time

	cout << "\n What time is it?  \n\n";
	
	SetTimeObject(&MyWatch);   //pass the object's address to function
	MyWatch.ShowTime();        // now use the object's function to show the time
	
	cout << "\n\n OK  Thanks!  \n\n";
	
	return 0;
}

//Demonstrates two ways to access the computer system time.
void SetTimeObject(Time *pWatch)
{

	char time_right_now[20];   // char string for time

// The _strtime function fills a character string with the system time.
// First, place system time in character string

	_strtime(time_right_now);  
	cout << "\n The system time is " << time_right_now ; 

// We need to get integer values for hr, min, sec. 
// Need to use a time_t struct that is defined in time.h

	time_t SystemTime;         // UTC time format variable


// Passing the address of SystemTime to time function. 
// The time function fills the SystemTime with UTC seconds

	time(&SystemTime);  

// Need to convert UTC to something we can use.
// The localtime function does that.
// Declare struct tm ptr to hold individual time info

	struct tm *OStime;      

// Pass the address of SystemTime to localtime to convert to tm struc
// and it fills OStime with all we need.

	OStime = localtime(&SystemTime);  

/* Now we can access the hr, min, sec of system time, and 
send them to the object's Reset function. (whew)  
The tm struct has tm_hour, tm_min and tm_sec variables. */

	pWatch->Reset(OStime->tm_hour, OStime->tm_min,OStime->tm_sec);

}

