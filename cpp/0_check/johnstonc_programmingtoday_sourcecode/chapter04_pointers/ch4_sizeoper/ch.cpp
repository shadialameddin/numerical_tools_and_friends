//Program 4-1  sizeof

#include <iostream.h>

int main()
{
	char c;
	double d;
	float f;
	int i;
	long  l;

	//Use sizeof with data types

	cout << "Number of bytes for these data types in Visual C++."
		<< "\n Using sizeof with data types:"
		<< "\n    char  " << sizeof(char) 
		<< "\n  double  " << sizeof(double) 
		<< "\n   float  " << sizeof(float) 
		<< "\n     int  " << sizeof(int) 
		<< "\n    long  " << sizeof(long) << endl;
	
	//Use sizeof with variables 

	cout << "\n\n Now use sizeof with data variables:"
		<< "\n    char  " << sizeof c 
		<< "\n  double  " << sizeof d 
		<< "\n   float  " << sizeof f 
		<< "\n     int  " << sizeof i 
		<< "\n    long  " << sizeof l << endl;

	return 0;
}
