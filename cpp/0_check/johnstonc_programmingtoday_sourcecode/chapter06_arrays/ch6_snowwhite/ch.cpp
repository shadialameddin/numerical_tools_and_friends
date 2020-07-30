//Program 6-10 Snow White and Character String Array.

#include <iostream.h>
void WriteNames( char [][15]);  //prototype

int main()
{
	// Declare and initialize the array
	char dwarfs[7][15] = { "Doc", "Sleepy", "Dopey", "Grumpy", "Sneezy", 
		"Bashful", "Happy" };

	WriteNames(dwarfs);

	return 0;
}

void WriteNames(char dwarfs[][15])
{
	int i;
	for (i = 0; i < 7; ++i) 
	{   
		cout << "Dwarf # " << i+1 << " is " << dwarfs[i] << endl;
	}
}
