//Program 7-1 Assigning and printing data structure information.  

//File: Ch7AssignDataStruct

#include <iostream.h>
#include <string.h>

struct Student    // Using a structure Tag for program
{
	char name[40];
	char address[80];
	char ID_Num[15];
	int dept_code;
	int major;
};

int main()
{
	Student MyStudent;   //create a single variable, named MyStudent

	strcpy(MyStudent.name,"Melissa Williams");
	strcpy(MyStudent.address, "123 Main Street, C-Ville, USA");
	strcpy(MyStudent.ID_Num, "123-45-6789");
	MyStudent.dept_code = 7;
	MyStudent.major = 2;


	cout.setf(ios::fixed);  //set output flags 
	cout.precision(2);
	cout << "\n Our student is " << MyStudent.name << "\n Address is " << 
	MyStudent.address << "\n ID number = " << MyStudent.ID_Num <<
	"\n Dept Code = " << MyStudent.dept_code << "\n Major Code = " << MyStudent.major <<endl;

	return 0;
}
