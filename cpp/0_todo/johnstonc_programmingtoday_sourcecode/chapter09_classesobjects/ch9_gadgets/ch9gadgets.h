//Program 9-4 Gadgets   ???????

//File:  Ch9Gadgets.h

#ifndef _GADGETS_H
#define _GADGETS_H

class Gadget
{
private:
	int x,y,z,sum;
	bool good;			//set to true if data is valid
	void Validate();	//check to see if x,y,z are positive
	void SumData(){ sum = x + y + z; }

public:
	Gadget();			//constructor
	~Gadget();			//destructor
	bool GetData();		//asks for x,y,z and returns true if data is good
	void WriteData();	//writes data to the screen
};

#endif