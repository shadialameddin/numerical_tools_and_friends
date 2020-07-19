//Program 11-15 Two Vehicles

// File:  Ch11TwoVehicles.h

#ifndef  _CH11TWOVEHICLES_H
#define  _CH11TWOVEHICLES_H
#include <iostream>

using namespace std;

class Vehicle
{
protected:
	char owner[50], license[20];
	char TypeNames[2][15];
public:
	Vehicle(){};
	virtual void GetInfo();  
	virtual void WriteInfo();
};

class RV:public Vehicle
{
private:
	int category;		//RV size 1, 2 or 3

public:
	RV(){};
	void GetInfo() ;
	void WriteInfo() ;

};

class Semi:public Vehicle
{
private:
	double weight_cap;			//weight capacity
public:
	Semi(){};
	void GetInfo(); 
	void WriteInfo();

};


#endif
