//Program I-6   Formatted output using manipulators

//File: AppIOutputWithManipulators.cpp

/* Manipulators can be set directly in the stream.  Once an IOS formatting
flag is set, it remains set until you unset it.            
Character strings are covered in Chapter 6. */



#include <iostream.h>
#include <iomanip.h>

int main()
{

	double pi = 3.141592653589793;
	double feet_in_a_mile = 5280.0;
	int sq_ft_in_acre = 43560;
	char Getty[15] = "4 score and 7";

	cout << "\nExample 2:  Output using manipulators " << endl;

	//First, just write out all 4 values to see what we get
	cout << "\n1. Write out the values" <<endl;
	cout<< "\n  Pi = " << pi <<   " Sq Feet in Acre = " << sq_ft_in_acre << 
		"\n  Feet in a mile = " << feet_in_a_mile << " Gettyburg = " << Getty <<endl;


	//Next, set fixed flags
	cout << "\n2. Set fixed, showpoint and precision=4  \n ";
	cout<< setiosflags(ios::fixed | ios::showpoint) << setprecision(4) << 
		"\n  Pi = " << pi << " Sq Feet in Acre = " << sq_ft_in_acre << 
		"\n  Feet in a mile " << feet_in_a_mile << " Gettysburg = " << Getty << endl;

	//Next, work on justification
	cout.setf(ios::left);

	cout << "\n3. Text to be written always left just, ios::left works on variables \n "
		 << "\n=========|=========|=========|=========|=========|=========|=========|";
	cout << setw(20) << "\nGettysburg = " <<  setw(20)<< Getty 
		 << setw(20) << "\nSqFt/AcresPi = " << setw(20)<<  sq_ft_in_acre << endl;

	//Next, work on justification
	cout.unsetf(ios::left);
	cout.setf(ios::right);
	cout << "\n4. Unset left, set right \n "
		<< "\n=========|=========|=========|=========|=========|=========|=========|";
	cout<< setw(20) << "\nGettysburg = " <<  setw(20)<< Getty 
		<< setw(20) << "\nSqFt/AcresPi = " << setw(20)<<  sq_ft_in_acre << endl<<endl;

	return 0;

}
