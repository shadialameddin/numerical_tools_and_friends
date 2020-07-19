//Program 2-15  Casting Chars into Ints, Octals and Hex
#include <iostream.h>

int main ()
{
	char character;
	int int_char;

	cout << "\n Enter the character to be converted ==> ";
	cin >> character;

	cout << "\n\n Your Character  " << character << " is  " ;
	
	int_char = int(character);    //cast into an integer
	
	cout << int_char << " (in decimal)  ";
	cout.setf(ios::oct);
	cout << int_char << " (in octal)  ";
	cout.unsetf(ios::oct);
	cout.setf(ios::hex);
	cout << int_char << " (in hex)  "<<endl;
	cout.unsetf(ios::hex);
	
	return 0;
}
