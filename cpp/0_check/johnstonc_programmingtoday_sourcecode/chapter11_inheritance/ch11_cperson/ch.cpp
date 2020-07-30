//Program 11-7 CPerson   CPerson base class

//File: CPerson.cpp


#include "Ch11CPerson.h"

CPerson::CPerson(string n, int a)
{ 
	cout << "\nIn the CPerson constructor \n"; 
	name = n;
	age = a;
	WritePerson();
	cout << "Leaving the CPerson constructor  \n";

}

