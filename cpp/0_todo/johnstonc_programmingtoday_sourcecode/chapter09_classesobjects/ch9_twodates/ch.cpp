//Program 9-3   Two Date Objects and Constructor functions

//File: Ch9TwoDates.cpp

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
    year = 2001;
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
    cout << "\n The Two Dates Program.  \n";

    CDate MyDate;       //calls the default constructor, sets date to 1/1/2000
    CDate YourDate(5,5,1955);   //calls overloaded constructor, sets date to 5/5/1955

    cout << "\n\n The original dates are: ";

    cout << "\n The MyDate date is  ";
    MyDate.ShowDate();                      

  cout << "\n The ShowDate date is ";
    YourDate.ShowDate();


    cout << "\n Now we'll change the dates.";

    MyDate.SetDate(1,2,1956);
    YourDate.SetDate(3,14,1994);

    cout << "\n\n The new dates are: ";

    cout << "\n The MyDate date is  ";
    MyDate.ShowDate();

    cout << "\n The ShowDate date is ";
    YourDate.ShowDate();

    cout << "\n No more dates for you. "  << endl;
    return 0;
}                                                                   