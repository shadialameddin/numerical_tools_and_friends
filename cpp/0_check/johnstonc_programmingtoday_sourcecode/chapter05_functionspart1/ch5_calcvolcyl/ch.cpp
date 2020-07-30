//Program 5-8 Calculate the volume of a cylinder.
// Call by Value 
#include <iostream.h>
const double pi = 3.14159265;		//pi is global variable

float CalcCylinderVolume(float,float);  //Prototype

int main()
{
	float radius, height,volume;

	cout << "\n Please enter the radius and height of your cylinder.  ";
	cin >> radius >> height;

	volume = CalcCylinderVolume(radius,height); //call by value
	cout << "\n Your Cylinder Volume = " << volume << endl;

	return 0;
}

float CalcCylinderVolume(float rad, float hgt)  //rad and hgt local variables
{
	float vol;
	vol = (float)pi * rad * rad * hgt;          //casting to avoid truncation
	return vol;
}
