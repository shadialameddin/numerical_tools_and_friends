//Program 3-5  HowManyHellos and for loop 
#include <iostream.h>

int main()
{
	int counter, howmany; 
	cout << "\n How many hellos would you like to see?    ";
	cin >> howmany;

	for(counter = 0; counter < howmany; ++counter)   //loop executes howmany times
	{
		cout << "\n Hello!";
	}

	cout << "\n That's a lot of hello's!   \n";
	return 0;
}
