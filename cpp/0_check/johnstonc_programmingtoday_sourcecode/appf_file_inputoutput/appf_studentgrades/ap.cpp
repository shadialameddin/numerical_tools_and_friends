//Program F-2  Calculate Student Grades

//File: AppFStudentGrades.cpp

#include <iostream.h>
#include <iomanip.h>             // required for setw
#include <fstream.h>             //required for file I/O
#include <stdlib.h>              // required for exit() and atoi

#define FILE_IN "student_gd.dat"  //be sure to place the data file in the project file
#define FILE_OUT "Grades.out"

float FindAve(float[], int);


int main()
{
	float grades[8], ave;
	char name[25];
	int total_students, total_grades = 8;

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

	output.open(FILE_OUT, ios::out);

	//Write a header out to the output file before we begin reading

	output << "\n The Most Fantastic Grading Program Ever Written  ;-) \n\n"
		<< "Student Name          Average Grade\n";


	//Read the first line to determine number of students
	//Use the getline so it will pull out the end of line character.
	char buf[15];
	input.getline(buf,15);
	total_students = atoi(buf);


	// Set the numeric output flags for 3 decimal digits of precision
	output.precision(3);
	output.setf(ios::fixed);

	// Now read each line of student data and calculate and print ave.
	char junk;  
	int i, j;
	for(i=0; i<total_students; ++i)
	{
	
		input.get(name,25);    // read in the name

		//use a for loop to read in the 8 grades
		for(j = 0; j < 8; ++j)
		{
			input >> grades[j];
		}
		input.get(junk); //pull out end of line char

		ave = FindAve(grades, total_grades);
	
		//now write date to output file
		output << name << setw(10) << ave << endl;
	}
	
	output << "\n How do you like them apples??? Bye! ";
    
	cout << "\n All Done! \n";
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

