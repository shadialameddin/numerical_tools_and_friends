//Program 3-8  HowManyHellos and while loop 
#include <iostream.h>

int main()
{
	int counter, howmany; 
	
	cout << "\n How many hellos would you like to see?    ";
	cin >> howmany;

	counter = 0;
	
	while(counter < howmany)   //loop executes howmany times
		{
			cout << "\n Hello!";
			++counter;
		}
	
	cout << "\n That's a lot of hello's!   \n";
	
	return 0;
}
