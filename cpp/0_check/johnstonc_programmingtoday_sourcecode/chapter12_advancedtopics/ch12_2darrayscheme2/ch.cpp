//Program 12-5  Two-Dimensional Array Using An Array of Pointers
//File Ch12TwoDArrayScheme2.cpp

#include <iostream>
using namespace std;

int main()
{
	int rowsize,colsize, totalsize;
	int  i,j;
	
	cout << "\n Enter the row and column size for your 2D array  ";
	cin >> rowsize >> colsize;

	totalsize = rowsize * colsize;

	int *pArray;				//pointer to an integer
	int **pPointerArray;		//pointer to an integer pointer

	pArray = new int[totalsize];		//memory for totalsize integers
	pPointerArray = new int* [rowsize];	//memory for rowsize # of int pointers

	//fill the pointer array with the pArray[i][0] addresses

	int index = 0;
	for (i= 0; i < rowsize; ++i)	//outer loop--traverse down the "rows"
	{
		pPointerArray[i] = &pArray[index];  //place the address into the pointer
		index = index + colsize;
	}

	//now fill the pArray by using the pPointerArray to access elements.
	int arrayvalue = 0;
	for (i= 0; i < rowsize; ++i)	//outer loop--traverse down the "rows"
	{
		for (j = 0; j < colsize; ++j)	//inner loop--move across each "column"
		{	
		
			pPointerArray[i][j] = arrayvalue;
			cout << "\n i (row) = " << i << " j (col) = " << j <<
				" Array Value = " << pPointerArray[i][j];
			++ arrayvalue;
		}
	}

	cout << "\n The End. "  << endl;

	delete [] pArray;
	delete [] pPointerArray;

	return 0;
}


