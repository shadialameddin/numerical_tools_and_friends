//Program 4-2  Address Operator Program and Output
#include <iostream.h>
int main()
{
	float x = 1, y = 2;
	int i = 3, j = 4;
	double q = 5, r = 6;
	
	cout.setf(ios::fixed);
	cout.precision(7);
	
	cout << "\n Value of x = " << x << " Address = " << &x;
	cout << "\n Value of y = " << y << " Address = " << &y;
	cout << "\n Value of i = " << i << " Address = " << &i;
	cout << "\n Value of j = " << j << " Address = " << &j;
	
	cout.precision(14);
	cout << "\n Value of q = " << q << " Address = " << &q;
	cout << "\n Value of r = " << r << " Address = " << &r <<endl;

	return 0;

}
