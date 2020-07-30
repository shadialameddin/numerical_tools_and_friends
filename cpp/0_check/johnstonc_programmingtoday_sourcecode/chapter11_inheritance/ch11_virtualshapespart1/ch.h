//Program 13 Virtual Shapes Part1

//File:  Ch11VirtualShapes.h

#ifndef  _CH11VIRTUALSHAPES_H
#define  _CH11VIRTUALSHAPES_H
#include <iostream.h>


class Shape
{
public:
	virtual void WhatAmI() { cout << "\n I am the basic shape. \n "; }

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

#endif
