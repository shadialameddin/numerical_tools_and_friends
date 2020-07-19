//Program 3-1  Knick-Knack Example program with if else
#include <iostream.h>
int main()
{
	int number;  
	cout << "\n Please enter an integer for knick-knacking.  ";
	cin >> number;
	cout << "\n He played knick-knack ";
	if(number == 1)  //write out knick-knack information
	{
		cout << "with his thumb.  \n";
	}
	else if(number == 2)
	{
		cout << "with my shoe.  \n";
	}
	else if(number == 3)
	{
		cout << "on his knee.  \n";
	}
	else if(number == 4)
	{
		cout << "at the door.  \n";
	}
	else                   // error check, any other number is not valid
	{
		cout << "\n Whoa! He doesn't play knick-knack there!\n\n";
	}
	return 0;
}
