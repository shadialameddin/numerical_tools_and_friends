//Program 2-10 const versus #define
#include <iostream.h>

#define APPLE  12
int main()
{
	const int banana = 8;  

	cout << "\n  Apple = " << APPLE;
	cout << "\n Banana = " << banana<<endl;

	return 0;
}
