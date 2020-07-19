//Program 2-11		Data Casting Stomps Conversion Warning
#include <iostream.h>		
int main()
{
	double x = 3.5;
	int y;
	
	y = (int)x; //cast x into an int

	cout << "\n The value in x is " << x<<" and y is "<<y<<endl;

	return 0;
}
