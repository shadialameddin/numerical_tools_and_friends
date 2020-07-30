//Program 8-12 WriteNumbers-Default Parameter List Functions

//File: Ch8WriteNumbers.cpp

#include <iostream.h>

void WriteNumbers(int = 10, int = 3, int = 1); //end, increment, start

void main()
{
	
	WriteNumbers();    // use default values

	WriteNumbers(20);   // now end at 20
	
	WriteNumbers(20, 5); // now go 1 - 20 and incr by 5

	WriteNumbers (15, 3, 0); // now write 0 - 15, incr 3


}

void WriteNumbers(int end, int incr, int start)
{
	int i;
	cout << "\n Writing Values Start = " << start << " End = " << end <<
		" Incr = " << incr << endl;

	for(i = start; i <= end; i = i+incr)
	{
		cout << i << ", ";
	}
	cout<<endl;
}
