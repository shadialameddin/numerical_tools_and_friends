//Program I-4 Example showing formatted output

//File: AppIoutputWithFormatting.cpp

#include <iostream.h>
#include <iomanip.h>        // for the setw()

int main ()
{
	double cost = 5.00, price = 5.50, pi = 3.14159265;
	int count = 75;
	char symbol = '+';

	
	cout.precision(2);       
	cout.setf(ios::showpoint | ios::fixed); 
	
	cout << "\n Sample Output \n Cost = " << setw(6) << cost <<
	" Price = " << setw(5)<< price;
	cout.precision(5);
	cout <<"\n pi = " << setw(10) <<  pi << " and count = " 
	<< count<< "\n The symbol is " << symbol;

	return 0;

}

