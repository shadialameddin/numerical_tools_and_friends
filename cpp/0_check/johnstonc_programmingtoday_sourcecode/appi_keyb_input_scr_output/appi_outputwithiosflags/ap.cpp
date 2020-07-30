//Program I-5  Practice with iosflags

//File: AppIOutputWithIOSFlags.cpp


#include <iostream.h>

int main()
{

	double pi = 3.141592653589793;
	double feet_in_a_mile = 5280.0;
	int sq_ft_in_acre = 43560;

	cout << "\n  Example 1  Output and cout functions " << endl;

	//First, just write out all 3 values to see what we get
	cout << "\n\n First, write out the values" <<endl;
	cout<< "\nPi = " << pi <<   "     Sq Feet in Acre = " << sq_ft_in_acre << 
		"    Feet in a mile " << feet_in_a_mile << endl;

	//Second set showpoint to see the feet in a mile decimal point
	cout << "\n\n Now set show point to see the dec.pt in feet in a mile\n";
	cout.setf(ios::showpoint); 
	cout<< "\nPi = " << pi <<   "     Sq Feet in Acre = " << sq_ft_in_acre << 
		"    Feet in a mile " << feet_in_a_mile << endl;

	//Next, set fixed flag and 3 precision
	cout << "\n\n Now set fixed and precision of 3. We'll see .xxx in doubles.  \n ";
	cout.setf(ios::fixed);	   
	cout.precision(3);		  
	cout<< "\nPi = " << pi <<   "     Sq Feet in Acre = " << sq_ft_in_acre << 
		"    Feet in a mile " << feet_in_a_mile << endl;

	//Now, unset the fixed flag and we'll just see 3 digits
	cout << "\n\n Now, unset fixed, we'll just see 3 digits \n ";
	cout.unsetf(ios::fixed);	
	cout<< "\nPi = " << pi <<   "     Sq Feet in Acre = " << sq_ft_in_acre << 
		"    Feet in a mile " << feet_in_a_mile << "\n\n";


	return 0;
}
