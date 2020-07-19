//Program 11-8 CGolfer   CGolfer is derived from CPerson

// File:  Ch11CGolferDriver.cpp

#include "Ch11CPerson.h"
#include "Ch11CGolfer.h"
#include <iostream>
#include <string>

using namespace std;

int main()
{

	CGolfer AlmostPro("Vincent", 29, 15); 
	AlmostPro.WriteGolfer();

	cout << "\n\n Head over to the 19th hole! \n\n";
	return 0;
}
