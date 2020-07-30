//Program 4-8  Knick-knack Program with pointers and switch

#include <iostream.h>
int main()
{
	int number;
	int *num_ptr;

	num_ptr = &number;

	cout << "\n Please enter an integer for knick-knacking     ";
	cin >> *num_ptr;

	cout << "\n\n He played knick-knack ";

	switch(number)   // the number was assigned using the pointer
	{
		case 1:
			cout << "with his thumb  \n";
			break;
		case 2:
			cout << "with my shoe  \n";
			break;
		case 3:
			cout << "on his knee  \n";
			break;
		case 4:
			cout << "at the door   \n";
			break;
		default:
	cout << "\n whoa! He doesn't play knick-knack there!  \n";
	}
return 0;
}
