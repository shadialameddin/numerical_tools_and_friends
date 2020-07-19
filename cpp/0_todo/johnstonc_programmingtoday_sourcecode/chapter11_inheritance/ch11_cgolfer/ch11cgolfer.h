//Program 11-8 CGolfer   CGolfer is derived from CPerson

// File:  Ch11CGolfer.h

#ifndef _CH11CGOLFER_H
#define _CH11CGOLFER_H
#include "Ch11CPerson.h"
#include <iostream>

using namespace std;

class CGolfer:public CPerson
{
private:
	int handicap;
public:
	CGolfer(string n, int a, int h);
	void WriteGolfer();

	~CGolfer() { cout << "\nDestructing Golfer object \n"; }
};

#endif