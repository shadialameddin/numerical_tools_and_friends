//Program F-5 More with Binary Files 

//File: AppFMoreBinaryFiles.cpp 

#include <iostream.h>
#include <fstream.h>             //required for file I/O
#include <stdlib.h>              // required for exit() and atoi
#include <string.h>

#define FILE_IN "BinaryOutput2.dat"  //we'll write and read the same file
#define FILE_OUT "BinaryOutput2.dat"

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

	int numbers[4] = {23, 235, 36, 9433 };
	int counter = 43;


	//first must set up streams for output

	ofstream output;                 //setup output stream object

	output.open(FILE_OUT, ios::out|ios::binary);
	output.write((char *) &people, sizeof(Person) );
	output.write((char *) &numbers, sizeof(numbers) );
	output.write((char *) &counter, sizeof(int) );


	cout << "\n All done writing data to the file! \n";
	output.close();

	//Now lets open and read the file

	cout << "\n\n Now let's read our file. \n ";
	Person Newperson;
	int Newnums[4];
	int Newcounter;


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
	input.read((char *) &Newnums, sizeof(Newnums) );
	input.read((char *) &Newcounter, sizeof(int) );


	cout << "\n The new person is " << Newperson.name;
	cout << "\n His/Her sex is " << Newperson.sex;
	cout << "\n His/Her age is " << Newperson.age;

	cout << "\n Newnumbers are " << Newnums[0] << "," << Newnums[1]
		<< "," << Newnums[2] << "," << Newnums[3];
	cout << "\n Newcounter is " << Newcounter;


	input.close();

	cout << "\n\n WOW!  More amazing file feats! " << endl;

	return 0;
}

