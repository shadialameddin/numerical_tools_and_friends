//Program 8-5 GiveMe3Floats in a Call by Reference with Reference Parameters

//File: Ch8GiveMe3FloatsReference.cpp

#include <iostream.h>

void GiveMe3Floats(float&,float&,float&);  //Prototype has reference variables types

int main( )
{
	float a,b,c;
	cout << "\n The GiveMe3Floats using reference parameters program.\n";

	GiveMe3Floats(a,b,c);  /* the call just uses the names of the variables, 
	but the addresses are being passed to the function. */

	cout << "\n The three floating point values are  " << a << " and " << b << 
			" and " << c << endl;
	return 0;
}

void GiveMe3Floats(float &a_ref, float &b_ref, float &c_ref)   //ref vars are really pointers
{
	a_ref = (float)6.7;        //values actually being assigned into main's a,b,c 
	b_ref = (float)8.1;
	c_ref = (float)33.7;
}
