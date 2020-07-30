//Program 9-4 Gadgets   A simple example with 2 objects

//File: GadgetsDriver.cpp

#include <iostream.h>
#include "Ch9Gadgets.h"

int main()
{

	cout << "\n\n The Gadgets Program!  \n\n";
	
	Gadget red,blue;			//declare 2 Gadget objects
	bool goodred, goodblue;

	cout << "\n Red Gadget:  ";	// write out Red message, then call red's GetData();
	goodred = red.GetData();

	cout << "\n Blue Gadget:  ";// same idea for the Blue Gadget
	goodblue = blue.GetData();

	if(goodred == true && goodblue == true) 
	{
		cout << "\n Both sets of gadget data are good! ";

		cout << "\n Red Gadget: ";	//call to red's WriteData();
		red.WriteData();

		cout << "\n Blue Gadget:  ";
		blue.WriteData();			//call to blue's WriteData();
	}
	else if(goodred && !goodblue)
	{
		cout << "\n The red data is good, but the blue data is bad. ";
		cout << "\n Red Gadget: ";
		red.WriteData();
	}
	else if(!goodred && goodblue)
	{
		cout << "\n The red data is bad, but the blue data is good. ";
		cout << "\n Blue Gadget: ";
		blue.WriteData();
	}
	else
	{
		cout << "\n BAD GADGET DATA  :-(   ";

	}

	cout << "\n\n What to do with all these gadgets????  \n\n";
	return 0;
}

