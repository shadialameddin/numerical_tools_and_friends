//Program 8-14 WriteYourName   Overloaded Functions

//File: Ch8WriteYourNameOverloaded.cpp

#include <iostream.h>

void WriteYourName(); 
void WriteYourName(char*, int);
void WriteYourName(char*);

int main()
{
	WriteYourName();
	WriteYourName("Wayne", 3);
	WriteYourName("Mark");

	return 0;

}

void WriteYourName()
{

	int i;
	cout << endl;
	for(i=0; i < 5; ++i)
	{
		cout << "Barbara";
	}
	cout << endl;
	
}


void WriteYourName(char *name, int count)
{
	int i;
	cout << endl;
	for(i=0; i < count; ++i)
	{
		cout << name;
	}
	cout << endl;
	
}


void WriteYourName(char *name)
{
	int i;
	cout << endl;
	for(i=0; i < 5; ++i)
	{
		cout << name;
	}
	cout << endl;
}
