//Program 8-15  Mix and Match Overloaded function with and without
//a default parameter list

//File: Ch8WriteYourNameMixAndMatch.cpp

#include <iostream.h>

int WriteYourName(char * = "Barbara", int = 5 );  //name, # of times
void WriteYourName(double);				//this just writes out a number


int main()
{
	int OK;
	double x = 3.4;

	OK = WriteYourName();
	OK = WriteYourName("Wayne", 3);
	OK = WriteYourName("Mark");
	WriteYourName(x);
	
	return 0;

}


int WriteYourName(char *name, int count)
{
	int i;
	cout << endl;
	for(i=0; i < count; ++i)
	{
		
			cout << name;
	}
	cout << endl;
	return 1;
}


void WriteYourName(double x)
{
	cout << "\nBarbara, you passed me " << x<<endl;

}
