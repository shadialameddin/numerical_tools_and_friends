//Program 7-5  Point structure returned from a function.

//File: AvePoints.cpp

#include <iostream.h>

struct Point
{
	double x, y;
};

Point AverageTwoPoints(Point, Point);  //prototype, receives 2 Points, returns 1

int main()
{
	Point First, Second, Average;
	cout << "\n Please enter the X and Y value for the first point.   ";
	cin >> First.x >> First.y;
	cout << "\n Now enter the X and Y value for the second point.   ";
	cin >> Second.x >> Second.y;
	Average = AverageTwoPoints(First,Second);
	cout << "\n The average point is (" << Average.x << "," << Average.y << ")";

	cout << "\n Don't you wish you were still in high school? \n";
	return 0;
}

Point AverageTwoPoints(Point First, Point Second)
{
	Point temp;		//local copy of a Point
	temp.x = (First.x + Second.x)/2.0;
	temp.y = (First.y + Second.y)/2.0;
	return temp;
}
