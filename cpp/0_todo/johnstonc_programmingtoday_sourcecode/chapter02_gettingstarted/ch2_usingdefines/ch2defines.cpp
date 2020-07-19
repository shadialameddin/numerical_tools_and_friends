//Program 2-9 Using #defines
#include <iostream.h>

#define PI 3.14159265
#define  MyPay  25.00
int main()
{
	float area_circle, r = 10.0, TotalPay;
	area_circle = PI * r * r;
	TotalPay = MyPay * 40.0;
	cout << "\n The value for pi is " << PI;
	cout << "\n The value for MyPay is " << MyPay<<endl;
	return 0;
}