//Program 6-12 Weather, Arrays, Data File I/O

#include <iostream.h>
#include <fstream.h>             //required for file I/O
#include <stdlib.h>              // required for exit()

#define FILE_IN "weather.in"  //be sure to place the data file in the project file
#define FILE_OUT "report.out"

float FindAve(float[], int);
void HighLow(float[], float[], float*, float*, int);

int main()
{
	float high[31],low[31], high_ave, low_ave, hottest, coldest;
	char date[25],location[50];
	int total_days, i=0;

	//first must set up streams for input and output
	ifstream input;                  //setup input stream object
	ofstream output;                 //setup output stream object

	//open for input and don't create if it is not there 
	input.open(FILE_IN, ios::in|ios::nocreate); 


	//Check to be sure file is opened.  One way, use the fail function.
	if(!input )  
	{
		cout << "\n Can't find input file " << FILE_IN;
		cout << "\n Exiting program, bye bye \n ";
		exit(1);
	}

	output.open(FILE_OUT, ios::out); //since we found input file, now open output
	cout << "\nOK found the file, keep going ...";

	//Read the first 2 lines into character strings
	input.getline(date,24);
	input.getline(location,49);

	while(!input.eof() )//read until we reach the end of file
	{ 
		input >> high[i] >> low[i];
		++i;
	}

	total_days = i;   // value is i 1 larger than total # of days read in

	cout << "\n All Done Reading!   "<<endl;

	high_ave = FindAve(high, total_days);
	low_ave = FindAve(low, total_days);
	HighLow(high, low, &hottest, &coldest, total_days);

	//now write date to output file

	output << "Monthly Weather Report\n\nLocation: " << location <<
		   "\n    Date: " << date;
	output << "\n\nAverage Temperatures:  High " << high_ave << " Low  " << low_ave;
	output << "\n\nHottest Temperature:  " << hottest <<
			"\nColdest Temperature:  " << coldest;
	
	input.close();
	output.close();
	return 0;
}

float FindAve(float x[], int total)
{
	float sum = 0.0;
	int i;
	for(i = 0; i < total; ++i)
	{
		sum = sum + x[i];
	}
	return(sum/total);
}

void HighLow(float high[], float low[], float *h_ptr, float *l_ptr, int total)
{
	//declare variables needed for rest of the program
	float hottest = high[0], coldest = low[0];
	int i;

	// traverse both arrays, looking for max high and min low, summing for average
	for(i=0; i < total; ++i)	
	{
		if(high[i] > hottest) *h_ptr = high[i];
		if(low[i] < coldest) *l_ptr = low[i];
	}

}
