/*Program 9-5   Array of Objects  
This program will use a class PhoneList that represents a telephone book entry.
Then it read 5 entries from a data file, filling the array of objects. */

//File: Ch9ArrayOfObjects.cpp

#include <iostream.h>       // for cout
#include <string.h>         // for strcpy
#include <iomanip.h>		// for setw()
#include <fstream.h>		// for file i/o
#include <stdlib.h>			// for exit();

#define FILE_IN "phonebook.dat"

class PhoneList
{
private:
	char name[25], address[30];
	int areacode, exchange, number;
public:
	PhoneList();
	void SetName(char n[]) { strcpy(name, n); }
	void SetAddress(char addr[]) { strcpy(address, addr); }
	void SetPhone(int a, int ex, int num );
	void ShowListing();

};

PhoneList::PhoneList()   // constructor null's strings and zero's integers
{
	name[0] = '\0';
	address[0] = '\0';
	areacode = exchange = number = 0;
}

void PhoneList::SetPhone( int a, int ex, int num)
{
	areacode = a;
	exchange = ex;
	number = num;
}

void PhoneList::ShowListing()
{
	cout << endl << setw(25) << name << setw(30) << address << "  ";
	cout << areacode << " - " << exchange << "-" << number;

}

int main()
{
	PhoneList mylist[5];   // we have 5 entries in our phone book
	
	//first must set up streams for input and output
	ifstream input;                  //setup input stream object

	//open for input and don't create if it is not there 
	input.open(FILE_IN, ios::in|ios::nocreate); 
 
	//Check to be sure file is opened.  One way, use the fail function.
	if(!input)  
	{
		cout << "\n Can't find input file " << FILE_IN;
		cout << "\n Exiting program, bye bye \n ";
		exit(1);
	}

	int i, a, ex, num; 
	char buf[35];

	for (i = 0; i < 5; ++i)  // this loop reading each entry in phone book file
	{
		input.getline(buf,25);
		mylist[i].SetName(buf);

		input.getline(buf,30);
		mylist[i].SetAddress(buf);

		input.getline(buf,4);    // need to read in each part of the number
		a = atoi(buf);
		input.getline(buf,5);
		ex = atoi(buf);
		input.getline(buf,7);
		num = atoi(buf);
		mylist[i].SetPhone(a,ex,num);
	}

	cout.setf(ios::left);    //left justify the output

	cout << "\n Your Address Book contains these listings: \n\n";
	for(i=0; i< 5 ; ++i)
	{
		mylist[i].ShowListing();
	}

	input.close();

	cout << "\n\n And a gracious Goodbye!  \n";

	return 0;
}
