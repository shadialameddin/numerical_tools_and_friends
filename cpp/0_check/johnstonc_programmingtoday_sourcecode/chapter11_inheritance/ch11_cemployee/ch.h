//Program 11-3  CEmployee        CEmployee class and file organization

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