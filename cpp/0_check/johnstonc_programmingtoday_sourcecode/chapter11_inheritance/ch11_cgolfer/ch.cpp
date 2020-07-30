//Program 11-8 CGolfer   CGolfer is derived from CPerson

// File:  Ch11CGolfer.cpp

#include "Ch11CGolfer.h"
#include <iostream>
#include "Ch11CPerson.h"
using namespace std;

/*

CGolfer::CGolfer(string n, int a, int h) //Route 1 this inits all
{
	name = n;
	age = a;
	cout << "\nIn the CGolfer constructor \n";
	handicap = h;

}*/

CGolfer::CGolfer(string n, int a, int h) : CPerson(n, a) // Route 2 calls CPerson
{
	cout << "\nIn the CGolfer constructor \n";
	handicap = h;
}


void CGolfer::WriteGolfer()
{
	CPerson::WritePerson();
	cout << "\n Handicap:  " << handicap;
}
