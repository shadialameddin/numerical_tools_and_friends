//Program 12-1  How big of an array would you like?
//File Ch12HowBigOfAnArray.cpp

#include <iostream>
using namespace std;

int main()
{
	int i, size, limit;
	
	cout << "\n What size array would you like?   ";
	cin >> size;
	cout << "\n\n Now, your random numbers should go from 0 to what integer? ";
	cin >> limit;

	int *pArrayOfRands;

	pArrayOfRands = new int[size];

	srand(123);	//seed the random number generator

	for (i= 0; i < size; ++i)
	{
		pArrayOfRands[i] = rand()%limit;
		cout << "\n i = " << i << "  Rand# = " << pArrayOfRands[i];
	}

	cout << "\n Wow. That was a lot of numbers. "  << endl;

	delete [] pArrayOfRands;

	return 0;
}


