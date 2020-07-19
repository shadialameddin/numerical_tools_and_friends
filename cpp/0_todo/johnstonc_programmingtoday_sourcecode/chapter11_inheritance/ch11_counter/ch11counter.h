//Program 11-1 Counter

// File:  Counter.h

#ifndef _COUNTER_H
#define _COUNTER_H
#include <iostream.h>

class Counter
{
private:
	int count;
public:
	Counter(){count = 0;}
	void operator ++(){ ++count; }
	int GetCount() { return count; }
	void SetCount( int c ) { count = c; }
	void PrintCount() { cout << "\n The count is " << count; }
};

#endif
