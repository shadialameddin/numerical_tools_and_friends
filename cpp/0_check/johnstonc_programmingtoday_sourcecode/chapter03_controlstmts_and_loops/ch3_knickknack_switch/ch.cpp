//Program 3-3  Knick-knack Example program with switch
#include <iostream.h>
int main()
{
	int number;  
	cout << "\n Please enter an integer for knick-knacking  ";
	cin >> number;

	cout << "\n He played knick-knack ";
	switch(number)  //write out area that will be knick-knacked.
	{
		case 1:
			cout << "with his thumb.  \n";
			break;
		case 2:
			cout << "with my shoe.  \n";
			break;
		case 3:
			cout << "on his knee.  \n";
			break;
		case 4:
			cout << "at the door.  \n";
			break;
		default:
			cout << "\n whoa! He doesn't play knick-knack there!  \n";
	}
	
	return 0;
}
