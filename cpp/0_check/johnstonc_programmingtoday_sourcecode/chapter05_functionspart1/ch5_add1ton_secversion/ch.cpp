//Program 5-5 Add Values from 1 to N 2nd Version
#include <iostream.h>

int Get_Number(void);         //Prototypes
void Add_1_to_N(int);
void Write_Values(int, int);

int main()
{
	int x;
	x = Get_Number();   //Get_Number returns user's number
	Add_1_to_N(x);      //Now send user's number to Add function 

	return 0;
}

int Get_Number()         //Function header line
{
	int number;
	cout <<"\n Enter a number ";
	cin >> number;
	return number;
}

void Add_1_to_N(int n)
{
	int total = 0,i;
	for(i = 1; i <= n; ++i)
	{
		total = total + i;
	}
	Write_Values(n,total);         // call the Write Results function here
}

void Write_Values(int n,int total)
{
	cout << "\n The result from adding 1 + 2 + ... + " << n <<
		" is " << total << endl;
}
