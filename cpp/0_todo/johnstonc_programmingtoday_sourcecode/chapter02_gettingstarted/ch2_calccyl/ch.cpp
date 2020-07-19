//Program 2-13 Practice with Input/Output to calc volume of a cylinder.
#include <iostream.h>		//needed for cout and cin
#include <iomanip.h>		//needed for setw()

int main()
{
	float pi = 3.14159265, radius, height, volume;

	cout << "\nPlease enter the height and radius of a cylinder: ";
	cin	>>height >>radius;
	
	volume = pi * radius *radius *height;	//calculate volume
	
	cout.setf(ios::fixed | ios::showpoint); //write w/ 4 digits of prec
	cout.precision(4);
	cout <<"\n\n Cylinder Volume Results" << endl << setw(12) <<
	  "Radius" << setw(12) <<"Height" <<setw(12) <<"Volume" << endl<< 
	  setw(12) <<radius<<setw(12) <<height << setw(12) <<volume <<endl;
	return 0;
}
