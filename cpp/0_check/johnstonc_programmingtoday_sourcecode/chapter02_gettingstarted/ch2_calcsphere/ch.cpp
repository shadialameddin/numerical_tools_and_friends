// Program 2-8  Two Ways to Calculate Sphere Volume

#include <iostream.h>     
#include <math.h>             //needed for power function

int main ()             
{ 
	double radius = 1.0;
	double volumeOK, volumeNOTOK;
	double pi = 3.14159265;

	cout << "\n Two Sphere Volume Calculations"
		"\n The volume of a sphere of radius = 1 is 4.1888";

	volumeOK = 4.0/3.0 * pi * pow(radius,3);        // 4.0/3.0 used
	volumeNOTOK = 4/3 * pi * pow(radius,3);

	cout << "\n\n Using correctly coded  4.0/3.0 ==> vol = " << volumeOK;


	cout << "\n Using incorrectly coded 4/3 ==>    vol = " << volumeNOTOK;

	cout << "\n\n WOW, another subtle error! \n\n";

	return 0;
}
