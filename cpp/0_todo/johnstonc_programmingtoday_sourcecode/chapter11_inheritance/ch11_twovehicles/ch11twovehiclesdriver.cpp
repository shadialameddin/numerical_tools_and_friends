//Program 11-15 Two Vehicles

// Ch11TwoVehiclesDriver.cpp

#include <iostream>
#include "Ch11TwoVehicles.h"

using namespace std;

int main()
{

	cout << "\n The Two Vehicles Program \n " << endl;

	int i;

	Vehicle *base[2];	//2 pointers to the base class
	RV HaveFun;
	Semi GoToWork;

	base[0] = &HaveFun;	//assign RV and Semi addresses into base class pointers
	base[1] = &GoToWork;

	//obtain the information using the virtual functions
	for(i = 0; i < 2; ++i)
	{
		base[i]->GetInfo();
	}

	//now write the information
	for(i = 0; i < 2; ++i)
	{
		base[i]->WriteInfo();
	}

	cout << "\n\n Let's go camping!  \n\n";
	return 0;
}