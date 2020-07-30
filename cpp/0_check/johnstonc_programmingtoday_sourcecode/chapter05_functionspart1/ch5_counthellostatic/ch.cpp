//Program 5-6 Count Hellos using a static variable.
#include <iostream.h>
int Say_Hello();        // prototype

int main()
{
	int how_many, i;
	for(i = 0; i < 10; ++i)
	{
		how_many = Say_Hello();
	//	if(i == 0)
	//		cout << "\n We have said hello " << how_many << " time.";
	//	else
	//		cout << "\n We have said hello " << how_many << " times.";

		cout << "\n Number of hellos we've seen: " << how_many;
		
	}
	cout <<endl;
	return 0;
}

int Say_Hello()	//static int count will maintain its value until program terminates
{
	static int count = 0;         //count is set to zero 1st time 
	cout << "\n HELLO!";
	count++;
	return count;
}
