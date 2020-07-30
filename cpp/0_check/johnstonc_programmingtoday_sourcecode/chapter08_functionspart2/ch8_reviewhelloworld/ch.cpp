//Program 8-1 Review standard C function, Call by Value. 

//File: Ch8ReviewHelloWorld.cpp

#include <iostream.h>

float GetNumber();         //Prototypes
void WriteNumber(float);
void Hello(void);

int main( )
{
	float num;
	Hello();             //Call statements 
	num = GetNumber();
	WriteNumber(num); 
	cout << "\n All Done. \n";
	return 0;
}

float GetNumber()         //Function header line
{
	float num;
	cout <<"\n Please enter a floating point number  ";
	cin >> num;
	return num;
}
void WriteNumber(float num)
{
	cout << "\n The number you entered was " << num;
}
void Hello(void)
{
	cout << "\n A simple program to say \"hello world\"\n";
}
