//Program 11-8 CGolfer   CGolfer is derived from CPerson

// File:  Ch11CPerson.h

#ifndef _CH11CPERSON_H
#define _CH11CPERSON_H

#include <iostream>
#include <string>
using namespace std;

class CPerson
{
protected:
	string name;
	int age;
public:
	CPerson(string n, int a);
	CPerson(){ cout << "\nIn the do-nothing CPerson constructor \n"; }
	void WritePerson(){	cout <<  name << " is " << age << " years old.  \n"; }
	~CPerson() { cout << "\nDestructing CPerson object \n"; }
};

#endif

