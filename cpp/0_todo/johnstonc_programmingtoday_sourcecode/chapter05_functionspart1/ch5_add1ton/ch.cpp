//Program 5-4 Add Values from 1 to N 
#include <iostream.h>

int Get_Number();         //Prototypes
int Add_1_to_N(int);

void main(void)
{
	int x,sum;
	x = Get_Number();                  //call to function to get the user's number
	sum = Add_1_to_N(x);               //call to adder function, it returns the sum 
	cout << "\n The result from adding 1 + 2 + ... + " << x << 
		" is " << sum << endl;
}

int Get_Number()         //Function header line
{
	int number;
	cout <<"\n Enter a number ";
	cin >> number;
	return number;
}

int Add_1_to_N(int n)
{
	int total = 0,i;

	for(i = 1; i <= n; ++i)
	{
		total = total + i;
	}
	return total;
}

