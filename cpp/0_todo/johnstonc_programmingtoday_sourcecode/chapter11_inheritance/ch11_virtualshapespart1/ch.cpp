//Program 13 Virtual Shapes Part1

// Ch11VirtualShapes.cpp

#include <iostream.h>
#include "Ch11VirtualShapes.h"


int main()
{

	cout << "\n The Virtual Shapes Program " << endl;

	Shape *ptr_to_base, MyShape;
	Sphere MySphere;
	Pyramid MyPyramid;

	ptr_to_base = &MyShape;	// base pointer points to Base class
	ptr_to_base->WhatAmI();

	ptr_to_base = &MySphere; // pointer now points to the Sphere
	ptr_to_base->WhatAmI();

	ptr_to_base = &MyPyramid; // pointer now points to the Pyramid
	ptr_to_base->WhatAmI();

	cout << "\n Ohhh This is hard! \n\n";
	return 0;
}