//Program F-4 Binary Files

//File: AppFBinaryFiles.cpp  

#include <iostream.h>
#include <fstream.h>             //required for file I/O
#include <stdlib.h>              // required for exit() and atoi
#include <string.h>

#define FILE_IN "TestBinaryOutput.dat"  //we'll write and read the same file
#define FILE_OUT "TestBinaryOutput.dat"

struct Person
{
	char name[50];
	int age;
	char sex;	// M or F
};



int main()
{
	Person people;
	
	strcpy(people.name,"Claire J");
	people.age = 25;
	people.sex = 'F';

	cout << "\n Our person is " << people.name;
	cout << "\n His/Her sex is " << people.sex;
	cout << "\n His/Her age is " << people.age;

	//first must set up streams for output

	ofstream output;                 //setup output stream object

	output.open(FILE_OUT, ios::out|ios::binary);
	output.write((char *) &people, sizeof(Person) );


	cout << "\n All done writing our person to the file! \n";
	output.close();

	//Now lets open and read the file

	cout << "\n\n Now let's read our file. \n ";
	Person Newperson;

	ifstream input;                 //setup output stream object

	//open for input and don't create if it is not there 
	input.open(FILE_IN, ios::out|ios::binary); 

	//Check to be sure file is opened.  One way, use the fail function.
	if(!input )  
	{
		cout << "\n Can't find input file " << FILE_IN;
		cout << "\n Exiting program, bye bye \n ";
		exit(1);
	}

	input.read((char *) &Newperson, sizeof(Person) );

	cout << "\n The new person is " << Newperson.name;
	cout << "\n His/Her sex is " << Newperson.sex;
	cout << "\n His/Her age is " << Newperson.age;

	input.close();

	cout << "\n\n WOW!  Wasn't that amazing? " << endl;

	return 0;
}

