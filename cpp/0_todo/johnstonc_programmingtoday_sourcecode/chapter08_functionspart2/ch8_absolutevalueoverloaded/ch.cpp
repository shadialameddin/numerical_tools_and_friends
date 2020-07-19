//Program 8-9 Using overloaded functions for absolute value 

//File: Ch8AbsoluteValueOverloaded.cpp

#include <iostream.h>
#include <stdlib.h>        //for the abs and labs functions
#include <math.h>		//for the fabs function

int AbsoluteValue(int);    //three different prototypes, same function name
double AbsoluteValue(double);
long AbsoluteValue(long);

int main()
{
	double x = -7.345, y;
	int a = -3, b;
	long l = -44000, n;

	y = AbsoluteValue(x);   //the call is to AbsoluteValue for all 3
	b = AbsoluteValue(a);
	n = AbsoluteValue(l);

	cout << "\n The positive values are " << y << " and " << b << " and " << n;
	cout << "\n I'm positive about that! ;-)   \n";

	return 0;
}

int AbsoluteValue(int x)       //Here are the 3 different functions
{
	return(abs(x));
}


double AbsoluteValue(double a)
{
	return(fabs(a));
}


long AbsoluteValue(long l)
{
	return(labs(l));
}
