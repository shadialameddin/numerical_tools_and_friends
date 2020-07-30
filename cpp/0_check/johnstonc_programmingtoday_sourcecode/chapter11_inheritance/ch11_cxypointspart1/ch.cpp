//Program 11-9   Famous Points    Part 1

// File:  Ch11CXYPoint.cpp


// No derived class constructor required. Uses the base class constructor.

#include <iostream.h>

class CXYPoint
{
protected:
    double x, y;
public:
    CXYPoint()
    {
        cout << "\n In CXYPoint constructor x=y=0";
        x = 0.0; y = 0.0;
    }
    CXYPoint(double x1, double y1)
    {
        cout << "\n In CXYPoint constructor x=x1, y=y1";       
        x = x1;
        y = y1;
    }
    void ShowThePoint()
    {
        cout << "\n (" << x << "," << y << ")";
    }
};

class CCustomDataPoint: public CXYPoint
{
public:
//  no constructor function here, but assume there are custom functions

};



int main()                         
{

    cout << "\n Welcome to the Infamous Point Program  Part 1 \n\n";

    CCustomDataPoint point1;    //derived object, base class constructor called
    CCustomDataPoint point2;

    cout << "\n Point 1 is ";
    point1.ShowThePoint();
    cout << "\n Point 2 is ";
    point2.ShowThePoint();

    cout << "\n\n This works famously!!!  \n\n";
    return 0;
}                     