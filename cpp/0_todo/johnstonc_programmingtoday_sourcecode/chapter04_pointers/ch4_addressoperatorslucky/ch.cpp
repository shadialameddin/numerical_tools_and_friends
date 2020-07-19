//Program 4-3 Address Operators with lucky, pi and money variables

#include <iostream.h>

int main()
{
	int lucky = 13;
	double pi = 3.14159265;
	float money = (float)39.95;
	
	cout << "\n Here are just the addresses!";
	cout << "\n &lucky = " << &lucky << 
		    "\n    &pi = " << &pi << 
            "\n &money = " << &money << endl;

	return 0;


}
