//Program 8-13 WriteYourName Default Parameter List

//File: Ch8WriteYourNameDefault.cpp

#include <iostream.h>

void WriteYourName(char* name = "Barbara", int count = 5);

int main()
{
	WriteYourName();
	WriteYourName("Wayne", 3);
	WriteYourName("Mark");

	return 0;

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
