//Program F-3 Read Until EOF

//File: AppFAddAllThoseNumbers

#include <iostream.h>
#include <fstream.h>             //required for file I/O
#include <stdlib.h>              // required for exit() and atoi

#define FILE_IN "Whole_Lotta_Numbers.dat"


int main()
{
	int total_numbers = 0, number_du_jour, sum;


	//first must set up stream for input 
	ifstream ILoveNumbers;                  //setup input stream object

	//open for input and don't create if it is not there 
	ILoveNumbers.open(FILE_IN, ios::in|ios::nocreate); 

 
	//Check to be sure file is opened.  One way, use the fail function.
	if(!ILoveNumbers )  
	{
		cout << "\n Can't find input file " << FILE_IN;
		cout << "\n Exiting program, bye bye \n ";
		exit(1);
	}

	sum = 0;
	while(!ILoveNumbers.eof() )    //read until we reach the end of file
	{
		ILoveNumbers >> number_du_jour;
		sum = sum + number_du_jour;
		++total_numbers;
	}

	cout << "\n           The file is " << FILE_IN;
	cout << "\n Total Numbers in file " << total_numbers;
	cout << "\n            The sum is " << sum;
	
	cout << "\n\n How do you like them numbers??? Bye! " << endl;
    

	ILoveNumbers.close();

	return 0;
}
