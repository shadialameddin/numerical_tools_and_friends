
//Program 2-12  Correct Equation Statement Placement
#include <iostream.h>
#define PI 3.14159265

int main()
{
	float area_circle, diameter,radius;
	
	cout << "\n Enter the radius value for the circle.  ";
	cin >> radius;

	area_circle = PI * radius * radius;   //Equations Statements  :-)
	diameter = 2.0 * radius;
	cout << "\n The diameter of the circle is " << diameter;
	cout << "\n The area of the circle is " << area_circle <<endl;
	return 0;
}
