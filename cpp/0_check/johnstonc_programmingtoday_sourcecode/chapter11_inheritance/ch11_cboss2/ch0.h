//Program 11-6 CBoss2  CBoss class  derived from CEmployee 

//File:  Ch11CEmployee.h

#ifndef  _CEMPLOYEE_H
#define  _CEMPLOYEE_H


class CEmployee
{
protected:
	char name[50],SSN[15];
	float salary;
	int dept;
public:
	CEmployee();
	void GetEmpInfo();
	void WriteEmpInfo();
};

#endif