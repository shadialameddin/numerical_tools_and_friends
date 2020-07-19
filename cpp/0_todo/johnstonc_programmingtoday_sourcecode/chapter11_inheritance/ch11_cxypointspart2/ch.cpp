//Program 11-10    Famous Points  Part 2

// File:  Ch11CXYPoint.cpp

// No derived class constructor required. Uses the base class constructor.

#include <iostream.h>

class CXYPoint
{
protected:
    double x, y;
public:
    CXYPoint();
    CXYPoint(double x1, double y1);
    void ShowThePoint() {cout << "\n (" << x << "," << y << ")"; }
};

CXYPoint::CXYPoint()
{
    cout << "\n In CXYPoint constructor x=y=0";  
    x = 0.0; y = 0.0;
}

CXYPoint::CXYPoint(double x1, double y1)
{
    cout << "\n In the CYXPoint constructor x=x1, y=y1";
    x = x1; y = y1;
}


class CCustomDataPoint: public CXYPoint
{
public:
    CCustomDataPoint(double x1, double y1): CXYPoint(x1, y1) {}
    CCustomDataPoint(){}
};


int main()                            
{

    cout << "\n Welcome to the Infamous Point Program  Part 2 \n\n";

    CCustomDataPoint point1;
    CCustomDataPoint point2(10,12);

    cout << "\n Point 1 is ";
    point1.ShowThePoint();
    cout << "\n Point 2 is ";
    point2.ShowThePoint();

    cout << "\n\n This works famously!!!  \n\n";
    return 0;
}
                                          