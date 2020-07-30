//Program 5-2 Calculating Averages using Loops
#include <iostream.h>
int main()
{
	// Declare variables
	float sc1, sc2, sc3, ave;
	char answer = 'y';          // initialize for while loop

	while(answer == 'y')
	{                        // Obtain 3 scores and calculate average.
		cout << "\n Please enter your 3 scores.  ";
		cin >> sc1 >> sc2 >> sc3;
	
	    ave = (sc1 + sc2 + sc3)/(float)3.0;  //casting to avoid truncation
		
		cout << "\n Your average is " << ave;
		cout << "\n Do another calculation?  y = yes  n = no  ";
		cin >> answer;
	}
	return 0;
}
