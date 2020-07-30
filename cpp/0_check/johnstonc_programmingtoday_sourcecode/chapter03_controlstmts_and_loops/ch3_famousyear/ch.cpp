//Program 3-4  Famous Year Program with switch
#include <iostream.h>
int main()
{
	int year;  
	cout << "\n Please enter your favorite year   ";
	cin >> year;

	cout << "\n Your year: " << year << " is famous for  ";
	switch(year)  //check for a famous year
	{
		case 1492:
			cout << " Columbus and his boat ride! \n";
			break;
		case 1776:
			cout << " a convention is Philadelphia! \n";
			break;
		case 1969:
			cout << " a guy taking a walk on the moon! \n";
			break;
		default:
		cout << "\n ...too bad. Nothing famous happened in that year.\n"; 
	}
	return 0;
}
