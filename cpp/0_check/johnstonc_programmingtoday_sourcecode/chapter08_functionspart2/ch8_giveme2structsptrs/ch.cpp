//Program 8-3 Review Call by Reference-Pointers with structures

//File: Ch8GiveMe2StructsPtrs

#include <iostream.h>

struct Struct1
{
	int a,b;
};

struct Struct2
{
	int d,e;
};

void GiveMe2Structs(Struct1 *, Struct2 *);  //Prototype includes pointers variables

int main( )
{
	cout << "\n The GiveMe2Structs using pointers program.\n";

	Struct1 First;
	Struct2 Second;
	GiveMe2Structs( &First, &Second);

	cout << "\n The first structure contains " << First.a << " and " << First.b;
	cout << "\n The second structure contains " << Second.d << " and " << Second.e;
	cout << "\n All Done \n";
	return 0;
}

void GiveMe2Structs(Struct1 *ptr1, Struct2 *ptr2)
{
	ptr1->a = 7;        //indirection operator w/ pointer
	ptr1->b = 1;
	ptr2->d = 3;
	ptr2->e = 5;
}
