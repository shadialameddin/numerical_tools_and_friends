//Program 2-14 Convert Total inches to feet & inches.
#include <iostream.h>
int main()
{
	int user_inches,in, ft;
	cout<< "\n Enter Inches (whole number) ==>";
	cin >>user_inches;

	ft = user_inches/12;		//integer division gives us feet
	in = user_inches%12;		//modulus give us inches
	
	cout <<"\n Result "<<ft<<" ft and " << in << " inches. " <<endl;
	
	return 0;
}


	