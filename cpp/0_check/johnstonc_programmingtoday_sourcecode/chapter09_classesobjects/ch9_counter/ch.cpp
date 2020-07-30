// Program 9-7  Overloaded operators with the class Counter

//File: Ch9Counter.cpp

#include <iostream.h>

class Counter
{
private:
	int count;
public:
	Counter() {  count = 0;  }            // constructor initializes count to zero
	void operator ++ () { count++ ;  }    // defines the ++ to add one to count
	void operator -- ()  { count --;  }    // defines the -- to sub one from count
	void Reset() { count = 0;  }          // resets the counter to zero
	int GetCount () { return count; }     // returns the value in count
};


int main()
{
	Counter MyCount, YourCount;     // both objects are initialized to zero
	int number = 0;

	++MyCount;
	++YourCount;
	++number;
	cout << "\n MyCount = " << MyCount.GetCount();
	cout << "\n YourCount = " << YourCount.GetCount();
	cout << "\n Number = " << number;
	return 0;
}            


                                                                        