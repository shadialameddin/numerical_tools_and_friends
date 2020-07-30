//Program F-1 Weather Statistics

//File: AppFWeatherStats.cpp

#include <iostream.h>           //required for cout
#include <fstream.h>            //required for file I/O
#include <stdlib.h>             // required for exit

#define FILE_IN "wthr_sum.dat"    // place the data file in the project folder
#define FILE_OUT "report.out"

int main()
{
	//first must set up streams for input and output
	ifstream input;  //setup input stream object
	ofstream output; //setup output stream object

	//open for input and don't create if it is not there 
	input.open(FILE_IN, ios::in|ios::nocreate); 

	//Check to be sure file is opened.  Use the ! operator with input object.
	if(!input )
	{
		cout << "\n Can't find input file " << FILE_IN;
		cout << "\n Exiting program, bye bye \n ";
		exit(1);
	}

	//Open the output file for the output
	output.open(FILE_OUT, ios::out); 

	//Now the two files are open and ready for reading
	char date[25], station[50];
	int high,low;
	float humidity, rain;


	//Read the first 2 lines into character strings
	input.getline(date,25);
	input.getline(station,50);


	//Set up a character string temporary buffer
	char buf[15];

	//Read each line of numeric values into buffer and use atoi and atof functions.
	input.getline(buf, 15);
	high = atoi(buf);
	input.getline(buf, 15);
	low = atoi(buf);
	input.getline(buf,15);
	humidity = (float)atof(buf);
	input.getline(buf,15);
	rain = (float)atof(buf);

	//Now write the output file
	output << "Date:" << date << "\nStation:" << station;
	if(rain == 0.0) 
		output << "\n   No Rain";
	else 
		output << "\n   It rained today.";

	int range = high - low;
	output << "\nThe temperature range was " << range;

	if(humidity < 0.33)
		output << "\nDry";
	else if(humidity < 0.66) 
		output << "\nNice";
	else 
		output << "\nMuggy";

	//Now close the files.
	input.close();
	output.close();

	return 0;
}
