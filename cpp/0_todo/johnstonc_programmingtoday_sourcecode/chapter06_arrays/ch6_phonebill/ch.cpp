//Program 6-1 A complete program for finding utility bill average for a year.
#include <iostream.h>
int main()
{
	// Declare variables
	float phone_bills[12];        // sets up an array of 12 elements
	float sum = 0.0, ave;
	int i;                // loop index will be used to access array elements

	// Obtain monthly billing information 
	for(i = 0; i < 12; ++i) 
	{
		cout << "\n Please enter bill for month number: " << i+1 << "=>$ ";
		cin >> phone_bills[i];
	}

	// Now calculate the average value. First obtain the sum.
	for(i = 0; i < 12; ++i)  
	{
		sum = sum + phone_bills[i];
	}
	ave = sum/(float)12.0;
	cout << "\n Your average phone bill for 12 months is $ "
		 << ave << endl;

	return 0;
}
