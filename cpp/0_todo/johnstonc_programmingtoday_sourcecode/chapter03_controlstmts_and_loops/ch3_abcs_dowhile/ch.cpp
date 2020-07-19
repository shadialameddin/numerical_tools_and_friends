//Program 3-10 Writing the abc's with a do while loop
#include <iostream.h>
#include <iomanip.h>			//for setw()
int main()
{
	int letter_ctr, int_to_ascii;
	cout << "\n We're going to write our abc's   \n";

	letter_ctr = 0;
	int_to_ascii = 97;
	do
	{
		cout << setw(6) << (char)int_to_ascii;	// write a letter
		int_to_ascii++;				// incr integer to ASCII number
		letter_ctr++;				// incr letter counter
		if(letter_ctr == 6) 		// newline if we've written 7
		{
			cout << endl;
			letter_ctr = 0;
		}
	}	
	while(int_to_ascii < 123);  	//keep looping until we reach one past z

	cout << "\n\n Now I've said my abc's. Won't you sing along with me? \n\n";
	return 0;
}
