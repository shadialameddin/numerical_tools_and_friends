//Program 5-9 Calculate Cylinder Volume 2nd Version
// Call by Reference using pointers to functions.

#include <iostream.h>
const double pi = 3.14159265;

void GetCylinderDimensions(float*,float*);  //Prototypes pointers here
float CalcCylinderVolume(float,float);     // Call by value here

int main()
{
	float radius, height,volume;
	GetCylinderDimensions(&radius, &height);   //send addresses 
	volume = CalcCylinderVolume(radius,height);  //send values
	cout << "\n Cylinder Volume = " << volume  << endl;
}

void GetCylinderDimensions(float *r_ptr, float *h_ptr)  //pointers 
{
	
	// use indirection operator with ptrs to have cin put the 
	// values where the pointers are pointing

	cout << "\n Enter radius and height   ";
	cin >> *r_ptr >> *h_ptr;

}

float CalcCylinderVolume(float rad, float hgt)
{
	return (pi * rad * rad * hgt);  //shortcut by doing calcs in return () 
}
