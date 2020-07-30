//Program 12-7  Exception Handling
//File Ch12ExcHandPosNumber.cpp

#include <iostream>
using namespace std;



int main()
{
	cout << "\n A Simple Exception-Handling Program\n";
	
	int number;

	cout << "\n Please enter a positive number  ";
	cin >> number;
	try			//we test for our error in the try block
	{
		if(number <= 0)
			throw number;	//WHOA! not positive, throw an exception!
		else
			cout << "\n You entered a " << number;

	}

	catch (int i)	//catch the exception, we pass the number to the catch statement
	{
		cout << "\n You entered " << i << " that is not positive! \n";
	}


	cout << "\n\n That wasn't so bad, was it? "  << endl;
	return 0;
}
