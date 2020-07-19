//Program 3-7   while loop and Poetry program
#include <iostream.h>

int main()
{
	char answer = 'y';   //initialize answer to y(yes)  

	while(answer == 'y' || answer == 'Y')   //keep going until not yes
	{
		cout << "\n Roses are red \n Violets are blue" <<
		"\n I Love C++  \n How about you?";

		cout << "\n\nWant to see my poem again?  y=yes, n=no  ";
		cin >> answer;
	}
	cout << "\n OK, all done. Goodbye.";
	return 0;
}
