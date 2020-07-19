//Program 3-11 SemiColons and Warnings!!!!   DOES NOT RUN CORRECTLY
#include <iostream.h>
int main()
{
	char answer;
	int count = 0;
	if(count == 50);		//<===YIKES!  ();		
	{
		cout << "\n Count is too big" <<
				"\n You won't get a hello from me.";
	}
	cout << "\n Did you like them apples?  y or n  ";
	cin >> answer;
	cout << "\n Now you get 10 hellos.\n";

	while(count < 10);				//infinite loop here!
	{
		cout << "\n hello world ";
	}
	return 0;
}

