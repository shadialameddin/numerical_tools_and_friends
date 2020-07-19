//Program 11-4  CEmployee and CBoss    CBoss class is derived from CEmployee class  

//File:  Ch11CEmployee.cpp

#include "Ch11CEmployee.h"
#include <iostream.h>
#include <string.h>

CEmployee::CEmployee()
{
	name[0] = '\0';
	SSN[0] = '\0';
	salary = 0;
	dept = 0;
}

void CEmployee::GetEmpInfo()
{
	char extra_enter;
	cout << "\n Enter the employee's name    ";
	cin.getline(name,50);
	cout << "\n Enter the employee's SSN   ";
	cin.getline(SSN,15);
	cout << "\n Enter the dept code and salary   ";
	cin >> dept >> salary;
	cin.get(extra_enter);
}

void CEmployee::WriteEmpInfo()
{
	cout << "\n Employee: " << name <<  "\n      SSN: " << SSN;
	cout << "\n     Dept:  " << dept << "\n   Salary:  $" << salary;

}