//Program 12-4  Two-Dimensional Array Using Offset Multiplier
//File Ch12TwoDArrayScheme1.cpp

#include <iostream>
using namespace std;

int main()
{
	int rowsize,colsize, totalsize;
	int index, i,j;
	
	cout << "\n Enter the row and column size for your 2D array  ";
	cin >> rowsize >> colsize;

	totalsize = rowsize * colsize;

	int *pArray;

	pArray = new int[totalsize];

	//fill the array with integers from 0 to totalsize
	// fill across the rows, moving down the columns  

	int arrayvalue = 0;
	//use nested for loops 
	for (i= 0; i < rowsize; ++i)	//outer loop--traverse down the "rows"
	{
		for (j = 0; j < colsize; ++j)	//inner loop--move across each "column"
		{	
			// calculate array index
			index = rowsize * j + i;
			pArray[index] = arrayvalue;
			cout << "\n i (row) = " << i << " j (col) = " << j <<
				" Array Value = " << pArray[index];
			++ arrayvalue;
		}
	}

	cout << "\n The End. "  << endl;

	delete [] pArray;

	return 0;
}


