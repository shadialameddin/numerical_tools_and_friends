//Program 5-10  Is It Prime?

#include <iostream.h>

int GetNum();         //prototypes
void IsItPrime(int);
bool CheckIt(int);


int main()
{
	int n;
	n = GetNum();
	IsItPrime(n);

	return 0;
}


int GetNum()
{
	int num;
	bool OK;

	do {
		cout << "\n Please enter a positive integer \n\n==>  ";
		cin >> num;

		OK = CheckIt(num);  // returns 1 if within range, 0 if not

		if(OK == false)
		 {
			cout << "\n Value out of range, please re-enter ";
		}
	}while(OK == false);

	return(num);
}

bool CheckIt(int number)
{
	if(number <= 0)	return false;
	else	return true;
}


void IsItPrime(int number)
{

	int result,divisor = 0,ctr=2;
	
	while(ctr < number )  //loop from 2 to n-1 and check remainder from modulus
	{
		 result = number%ctr;
		 if(result == 0)  // if a number goes into the user's n evenly, not prime
		 {
			  divisor = ctr;
			  cout << "\n\n The value " << number << " is NOT prime.";
			  cout << "\n One divisor is " << divisor << endl;

			  return;   // WE'RE all done, get outta here!
		 }
		 ++ctr;
	}

	cout << "\n\n The value " << number << " is prime.  \n\n";

}
