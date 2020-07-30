//Program 6-4  Average Value of 1D Array
#include <iostream.h>

float Ave1D( float [], int);  //prototype passing array to this

int main()
{
	float x[100], average,num = 1000.0;
	int i, total = 100;

//we'll fill x with values 1000 - 1100
	for (i = 0; i < 100; ++ i)
	{
		x[i] = num;
		num++;           // num starts at 1000, incr each time 
	}

	average = Ave1D( x , total);
	cout << "\n The average value of the array is " << average << endl;

	return 0;
}

float Ave1D( float temp[], int total)
{
	int i;
	float sum = 0.0, ave;
	for(i = 0; i < total; ++i)	{
		sum = sum + temp[i];
	}
	ave = sum/total;
	return ave;
}

