//Program 6-2 Compression Ratios
#include <iostream.h>
int main()
{
	// Declare variables
	double comp_ratio[4];        // sets up an array of 4 elements
	comp_ratio[0] = 3.21;
	comp_ratio[1] = 5.32;
	comp_ratio[2] = 0.87;
	comp_ratio[3] = 8.33;

	int i;         // loop index will be used for accessing array elements
	
	cout << "\n The compression ratio array contains these four values: \n";

	for(i = 0; i < 4; ++i)  
	{
		cout << " comp_ratio[" << i << "] = " << comp_ratio[i] << endl;
	}
	return 0;
}
