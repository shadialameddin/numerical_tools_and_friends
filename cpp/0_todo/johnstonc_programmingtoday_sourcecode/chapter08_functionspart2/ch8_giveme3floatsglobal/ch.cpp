//Program 8-4 Global Variables

//File: Ch8GiveMe3FloatsGlobal.cpp

#include <iostream.h>

void GiveMe3Floats(void); 		//Prototype has void data types, nothing is passed

float a,b,c;  		//variables are global, both main and function sees them

int main( )
{

	cout << "\n The GiveMe3Floats using globals program.\n";
	GiveMe3Floats();
	cout << "\n The three floating point values are  " << a << " and " << b << 
			" and " << c << endl;

	return 0;
}

void GiveMe3Floats()
{
	a = (float)6.7;        //values placed in a,b,c
	b = (float)8.1;
	c = (float)33.7;
}
