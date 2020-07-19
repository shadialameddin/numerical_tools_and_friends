//Program 9-4 Gadgets   ???????

//File: Ch9Gadgets.cpp

#include <iostream.h>
#include "Ch9Gadgets.h"

Gadget::Gadget()
{
	cout << "\n I'm in the Gadget constructor, setting all values to 0 ";
	x = y = z = sum = 0;
	good = false;
}

Gadget::~Gadget()
{
	cout << "\n I'm in the Gadget destructor. "
		    "\n Nothing to do but say Goodbye. Goodbye! \n";

}

bool Gadget::GetData()
{
	good = false;	//set to false initially 

	cout << "\n Please enter your Gadget's x, y and z integers => ";
	cin >> x >> y >> z;

	Validate();			//call to Validate, to check values
	if(good == true)
	{
		SumData();		//if data is good, then sum values
	}
	return good;
		
}

void Gadget::Validate()
{
	//data is valid as long as all three integers are positive
	if(x > 0 && y > 0 && z > 0)
		good = true;
	else
		good = false;
}


void Gadget::WriteData()
{
	cout << "\n Gadget Data:  x = " << x << " y = " << y << " z = " << z;
	cout << "  The sum is " << sum << endl;
}

	


