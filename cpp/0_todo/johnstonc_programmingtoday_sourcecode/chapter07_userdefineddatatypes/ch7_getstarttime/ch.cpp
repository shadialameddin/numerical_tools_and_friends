//Program 7-9 Time structure returned from a function.

//File: GetStartTime.cpp

#include <iostream.h>

struct Time
{
	int hr, min, sec;
};

Time GetStartTime(void);  //prototype (must be after structure Tag)

int main()
{
	Time start;
	
	start = GetStartTime(); //function call, expecting a Time struct in return

	cout << "\n The starting time is " << start.hr << ":" << start.min << 
	":" << start.sec << endl;

	cout << "\n Time's Up! \n ";
	return 0;

}

Time GetStartTime(void)
{
	Time input;  //this local variable for the function

	cout << "\n Enter start time in hours, minutes, and seconds, such as 9 45 0 ";

	cin >> input.hr >> input.min >> input.sec;

	return(input);  //now return the input Time structure
}
