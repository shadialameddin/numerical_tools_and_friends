//Program 11-5 CCEO      CCEO class with CEmployee and CBoss

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