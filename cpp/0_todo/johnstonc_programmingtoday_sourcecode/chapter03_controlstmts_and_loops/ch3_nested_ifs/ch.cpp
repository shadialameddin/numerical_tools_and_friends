//Program 3-2  Nested if statements sample program
#include <iostream.h>
int main()
{
	int number;  
	cout << "\n Please enter an integer   ";
	cin >> number;
	if(number > 0)  //positive number
	{
		cout << "\n The number is positive " << endl;
			
		if(number >= 1 && number <= 10)
		{
			cout << " and it is between 1 and 10" << endl;
		}
				
	}
	else
	{
		cout << "\n The number is zero or negative" << endl;
	}
	return 0;
}
