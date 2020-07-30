//Program 12-6  Addresses to Functions to Functions
//File Ch12PointertoFuncToFunc.cpp

#include <iostream>
using namespace std;

void GetXandY(double *x_ptr, double *y_ptr);
void GetX(double *x_ptr);
void GetY(double *y_ptr);

int main()
{
	double x,y;

	GetXandY(&x, &y);	// pass the address of x and y

	cout << "\n X = " << x << " and Y = " << y << endl;
	
	cout << "\n Missouri is the Show Me! state. "  << endl;


	return 0;
}


void GetXandY(double *x_ptr, double *y_ptr)
{
	GetX(x_ptr);		//x_ptr & y_ptr contains the addresses
	GetY(y_ptr);		//just pass the value in x_ptr and y_ptr
}

void GetX(double *x_ptr)
{
	cout << "\n Please enter the value for X ";
	cin >> *x_ptr;
	
}

void GetY(double *y_ptr)
{
	cout << "\n Please enter the value for Y ";
	cin >> *y_ptr;
	
}
