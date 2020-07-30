// Program 11-2 NewCounter   A program that uses the class NewCounter 
// that is derived from Counter and private count variable.

//File: Ch11NewCounter.cpp

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



class NewCounter:public Counter
{
public:
	void operator --();  
	
};

void NewCounter::operator --()
{
	int c = GetCount();
	--c;
	SetCount(c);
} 


int main()
{

	NewCounter nctr;  // new counter object

	cout << "\n Sample program with class NewCounter \n";

	cout << "\n What is in the nctr?";
	
	nctr.PrintCount();

	cout << "\n Increment the new counter object twice: ";
	++nctr;
	++nctr;

	nctr.PrintCount();

	cout << "\n Now decrement the new counter: ";
	--nctr;
	nctr.PrintCount();
	cout << "\n\n All finished counting! \n";
	return 0;
}
