//Program 11-1 Counter   Sample program with a counter object

//File: Ch11Counter.cpp

#include "Ch11Counter.h"
#include <iostream.h>

int main()
{
	Counter HowMany;    // constructor sets HowMany count = 0
	cout << "\n Sample program with class Counter  \n";
	HowMany.PrintCount();
	cout << "\n Increment HowMany twice: ";
	++HowMany;
	++HowMany;
	HowMany.PrintCount();
	cout << "\n Now set the count back to zero. ";
	HowMany.SetCount(0);  // set count value back to zero
	HowMany.PrintCount();
	cout << "\n\n All finished counting! \n";
	return 0;
}
