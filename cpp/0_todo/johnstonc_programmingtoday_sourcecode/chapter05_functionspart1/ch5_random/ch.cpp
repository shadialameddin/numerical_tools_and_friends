//Program 5-11 Random Numbers

#include <iostream.h>
#include <stdlib.h>    // needed for random number generator
#include <iomanip.h>   // needed for setw()

void Find_100_Random_Num(int);   // pass the seed to the function

int main()
{
	int seed = 123;
	srand(seed);		//"seed" the random number generator
						// only need to do this once

	Find_100_Random_Num(seed);
	
	cout <<endl;

	return 0;
}

void Find_100_Random_Num(int seed)
{


	int i, rand_num, zero_to_nine;

	for (i = 0; i < 100; ++i)
	{
		rand_num = rand();
		zero_to_nine = rand_num%10;
		cout << "\n " << i+1 << setw(5) << zero_to_nine;
	}
}

