//Program 8-6 GiveMe2Structs in a Call by Reference 

//File: Ch8GiveMe2StructsReference.cpp

#include <iostream.h>

struct Struct1
{
	int a,b;
};

struct Struct2
{
	int d,e;
};

void GiveMe2Structs(Struct1 &, Struct2 &);  //Prototype includes reference data types

int main( )
{
	cout << "\n The GiveMe2Structs using pointers program.\n";
	Struct1 First;
	Struct2 Second;
	GiveMe2Structs( First, Second);  /* the call uses just the variable names
	but the addresses are sent to the function */

	cout << "\n The first structure contains " << First.a << " and " <<  First.b;
	cout << "\n The second structure contains " << Second.d << " and " << Second.e;
	cout << "\n All Done \n";
	return 0;
}

void GiveMe2Structs(Struct1 &rStr1, Struct2 &rStr2)
{
	rStr1.a = 7;        //members accessed via dot operator
	rStr1.b = 1;
	rStr2.d = 3;
	rStr2.e = 5;
}
