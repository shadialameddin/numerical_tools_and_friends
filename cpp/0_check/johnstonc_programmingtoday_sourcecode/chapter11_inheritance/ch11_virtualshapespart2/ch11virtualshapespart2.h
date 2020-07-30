//Program 11-14 Virtual Shapes Part2

//File: Ch11VirtualShapesPart2.h

#ifndef  _VIRT_SHAPE2_H
#define  _VIRT_SHAPE2_H


class Shape
{
public:
	virtual void WhatAmI() =0 ;  //purely virtual, no actual function exists

};

class Pyramid:public Shape
{
public:
	void WhatAmI() { cout << "\n I am a pyramid. \n"; }
};

class Sphere : public Shape
{
public:
	void WhatAmI() { cout << "\n I am a sphere. \n"; }
};

class Cone:public Shape
{
public:
	void WhatAmI() { cout << "\n I am a cone. \n"; }
};

class Box : public Shape
{
public:
	void WhatAmI() { cout << "\n I am a box. \n"; }
};

#endif
