//Program 8-8 How Big is your Box?  With Reference Variables (Correct method)

//File: Ch8HowBigIsYourBox.cpp

#include <iostream.h>

void GetBoxSize(float&, float&, float&);  //prototypes
inline float CalcBoxVol(float,float,float);

void main()
{
	//// Declare and initialize the array
	float wide,length,height,vol;
	
	GetBoxSize(wide,length,height);
	vol=CalcBoxVol(wide,length,height);
	cout << "\n Your box dimensions are: " << wide << " by " <<
		length << " by " <<  height;
	cout << "\n The volume is " << vol << endl;
}

void GetBoxSize(float& w_ref, float& l_ref, float& h_ref)
{
	cout << "\n Enter the width, length and height of your box. \n ";
	cin >> w_ref >> l_ref >> h_ref;


}

inline float CalcBoxVol(float w, float l, float h)
{
	return (w*l*h);
}