//Program 11-14 Virtual Shapes Part2

//File: Ch11VirtualShapesPart2.cpp

#include <iostream.h>
#include "Ch11VirtualShapesPart2.h"


int main()
{

	cout << "\n The Virtual Shapes Program -- Part 2" << endl;

	Shape *ptr_to_base[4];
	Sphere MySphere;
	Pyramid MyPyramid;
	Cone MyCone;
	Box MyBox;

	ptr_to_base[0] = &MyCone;
	ptr_to_base[1] = &MySphere; 
	ptr_to_base[2] = &MyPyramid; 
	ptr_to_base[3] = &MyBox;

	for(int i = 0; i < 4; ++i)
	{
		ptr_to_base[i]->WhatAmI();
	}

	cout << "\n Ohhh This is getting easier! \n\n";
	return 0;
}