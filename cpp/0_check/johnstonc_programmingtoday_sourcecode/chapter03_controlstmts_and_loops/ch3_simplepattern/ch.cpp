//Program 3-14 Writing a Simple Pattern
#include <iostream.h>
#include <iomanip.h>			//for setw()
int main()
{
	int NumRows, i, j;
	char MyChar;

	cout << "\n Write a simple pattern.  ";

	cout << "\n Enter the character for your pattern     ";
	cin >> MyChar;
	cout << "\n How many rows?   1 - 20      ";
	cin >> NumRows;

// The initial pattern for loops

	for(i = 1; i <= NumRows; ++i)
	{
		cout << endl;		//start on a new line

		for(j = 0; j < i; ++j)
		{
			cout << MyChar;		// write the char
		}
	}   

// Code for reversing the pattern
/*	for(i = 1; i <= NumRows; ++i)
	{
		cout << endl;		//start on a new line

		for(j = 0; j < NumRows - i; ++ j)	//write blanks
		{
			cout << " ";
		}

		for(j = 0; j < i; ++j)
		{
			cout << MyChar;		// write the char
		}
	} 
*/

	cout << "\n\n Oh, what a pretty pattern!       \n\n";
	return 0;
}
