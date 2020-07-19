//Program 11-8 CGolfer   CGolfer is derived from CPerson

// File:  Ch11CPerson.cpp

#include "Ch11CPerson.h"



CPerson::CPerson(string n, int a)
{ 
	cout << "\nIn the CPerson constructor \n"; 
	name = n;
	age = a;
 	WritePerson();   
	cout << "Leaving the CPerson constructor  \n";

}