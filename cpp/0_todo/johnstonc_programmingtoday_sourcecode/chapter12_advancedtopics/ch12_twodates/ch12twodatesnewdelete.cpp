//Program 12-2   Two Date Objects from Chapter 9 
//Reworked using new and delete operator.
//File Ch12TwoDatesNewDelete.cpp

#include <iostream.h>

class CDate
{
private:
	int mon, day, year;
public:
	CDate();
	CDate(int m, int d, int y);
	void ShowDate();
	void SetDate(int m, int d, int y);
};

CDate::CDate()
{
	cout << "\n I'm in the default constructor.";
	mon = 1; 
	day = 1; 
	year = 2000;
}

CDate::CDate(int m, int d, int y)
{
	cout << "\n I'm in the constructor where we pass m/d/y to me.";
	mon = m; 
	day = d; 
	year = y;
}

void CDate::ShowDate()
{
	cout <<  mon << "/" << day << "/" << year << endl;
}

void CDate::SetDate(int m, int d, int y)
{
	mon = m;
	day = d;
	year = y;
}


int main()
{
	cout << "\n The NEW Two Dates Program.  \n";
	
	CDate *pMyDate, *pYourDate;	//sets up 2 pointers to CDatecalls the default constructor, sets date to 1/1/2000

	pMyDate = new CDate;		//calls the default constructor
	pYourDate = new CDate (5,5, 1955);		//calls the overloaded constructor

	cout << "\n\n The original dates are: ";
	cout << "\n The MyDate date is  ";
	pMyDate->ShowDate();

	cout << "\n The ShowDate date is ";
	pYourDate->ShowDate();


	cout << "\n Now we'll change the dates.";

	pMyDate->SetDate(1,2,1956);
	pYourDate->SetDate(3,14,1994);

	cout << "\n\n The new dates are: ";

	cout << "\n The MyDate date is  ";
	pMyDate->ShowDate();

	cout << "\n The ShowDate date is ";
	pYourDate->ShowDate();


	cout << "\n No more dates for you. "  << endl;

	delete pMyDate;
	delete pYourDate;

	return 0;
}


