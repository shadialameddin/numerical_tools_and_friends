//Program 3-13 Numbers and More Practice!
#include <iostream.h>
int main()
{
	int number, mod2,mod3;
	char answer = 'y';
	while(answer == 'y')
	{
		cout << "\nPlease enter a number from 1 to 1000  ==> ";
		cin >> number;
		if(number > 0 && number < 1001)        //number is within range
		{
			mod2 = number%2;               // is it divisible by 2 or 3?
			mod3 = number%3;
			
			if(mod2 == 0 || mod3 == 0)
			{
				cout << "\n Your number " << number << " is divisible by ";
				if(mod2 == 0) cout << "2 !";
				if(mod3 == 0) cout << "3 !";
			}
		}
		else
		{
			cout << "\n Your number is out of range!!  ";
		}
		cout << "\n Want to go again?  y = yes, n = no  ";
		cin >> answer;
	}
	cout << "\n Bye Bye!  \n";
	return 0;
}
