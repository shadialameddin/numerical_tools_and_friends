//Program 6-5 Gimme Five Numbers-Second Attempt
// Declare the array in the calling function.
#include <iostream.h>

void Gimme5Numbers(int [] );  //prototype passes an array to the function

int main()
{
	int five_nums[5], i;

	cout << "\n Welcome to Gimme5Numbers Program \n\n";
	Gimme5Numbers( five_nums );

	cout << "\n The 5 values in the five_nums array are: \n";
	for(i = 0; i < 5; ++i)
	{
		cout << "Element # " << i << " = " << five_nums[i] << endl;
	}
	return 0;
}

void Gimme5Numbers( int five_nums[] )
{
	int i;
	for(i = 0; i < 5; ++i)   
	{
		cout << "\n Enter Number " << i+1 << "==> ";
		cin >> five_nums[i];
	}
}
