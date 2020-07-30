//Program 11-15 Two Vehicles

// File:  Ch11TwoVehicles.cpp

#include <iostream>
#include "Ch11TwoVehicles.h"


void Vehicle::GetInfo()
{
	cout << " \nEnter owner's name:  ";
	cin.getline(owner,50);
	cout << "\nEnter license plate such as NM 123 ABC :  ";
	cin.getline(license,50);
}

void Vehicle::WriteInfo()
{
	char TypeNames[2][15] = { "recreational","commercial" };
	cout << "\n\n        Owner: " << owner <<
		    "\n      License: " << license;

}

void RV::GetInfo()
{

	cout << "\n Please enter information for the recreational vehicle.";
	Vehicle::GetInfo();		//call the base class GetInfo first
	char enter;
	cout << "\nEnter RV category  1, 2 or 3 ";
	cin >> category;
	cin.get(enter);			// pull off enter key left by cin

}

void RV::WriteInfo()
{
	Vehicle::WriteInfo();
	cout << "\n This RV is a category " << category;

}

void Semi::GetInfo()
{
	cout << "\n Please enter information for the commercial vehicle.";
	Vehicle::GetInfo();
	char enter;
	cout << " \n Enter the weight capacity ";
	cin >> weight_cap;
	cin.get(enter);		// pull off enter key left by cin

}

void Semi::WriteInfo()
{
	Vehicle::WriteInfo();
	cout << "\n This commercial vehicle has a weight capacity of " << weight_cap;
}
