//Program 3-9  do while loop and Poetry
#include <iostream.h>

int main()
{
	char answer; /*no need to initialize since we'll ask the user
                             before we check the condition */  
	do
	{	
		cout << "\n Roses are red \n Violets are blue" <<
		"\n I Love C++   \n How about you?";

		cout << "\n\nWant to see my poem again?  y=yes, n=no  ";
		cin >> answer;
	} while(answer == 'y' || answer == 'Y');   //keep going until not yes

	cout << "\n OK, all done. Goodbye.";
	
	return 0;
}
