//Program 3-6 Writing the ABC's
#include <iostream.h>
#include <iomanip.h>

int main()
{
	int letter_ctr, i;
	cout << "\n We're going to write our ABC's   \n\n";

	letter_ctr = 0;
	for(i = 65; i < 91; ++i)		//A = 65, Z = 90
	{
		cout << setw(6) << (char)i;	// write a letter
		letter_ctr++;				// incr letter counter
		if(letter_ctr == 7) 		// newline if we've written 7
		{
			cout << endl;
			letter_ctr = 0;
		}
	}
	cout << "\n\n Now I've said my ABC's. Won't you sing along with me? \n\n";
	return 0;
}
