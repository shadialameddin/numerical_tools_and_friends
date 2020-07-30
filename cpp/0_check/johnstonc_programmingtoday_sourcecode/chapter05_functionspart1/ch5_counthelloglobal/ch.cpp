//Program 5-7 Count Hellos using a global variable.
#include <iostream.h>
void Say_Hello();        // prototype is now void return type
int count = 0;          // global count variable, all can see it

int main()
{
	int i;
	for(i = 0; i < 10; ++i)
	{
		Say_Hello();
		cout << "\n Number of hellos we've seen: " << count ;
	}
	cout <<endl;
	return 0;
}
void Say_Hello()
{
	cout << "\n HELLO!";
	count++;                     //global variable
}
