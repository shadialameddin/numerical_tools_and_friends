//Program 7-3 Array of Student data structures.

//File: Ch7StudentArray

#include <iostream.h>
#include <string.h>

struct Student    // The tag is created as a single structure.
{
    char name[40];
    char address[80];
    char ID_Num[15];
    int dept;
    int major;
};

int main()
{
    Student MyStudents[100];   //create an array of 100 Student structs
	// We'll ask the user to enter the information into the first array element
    cout << "\n Enter the student's name:   ";
    cin.getline(MyStudents[0].name,40);
    cout << "\n Enter the student's address:   ";
    cin.getline(MyStudents[0].address, 80); 

	cout << "\n Enter the student's ID number:   ";
    cin.getline(MyStudents[0].ID_Num, 15);
    cout << "\n Enter the student's department and major code:   ";
    cin >> MyStudents[0].dept >> MyStudents[0].major;
    cin.ignore(10,'\n');

	// write out the info
    cout << "\n Student's name: " << MyStudents[0].name;
    cout << "\n Address:  " << MyStudents[0].address;
    cout << "\n ID Num:  " << MyStudents[0].ID_Num;
    cout << "\n Dept Code: " << MyStudents[0].dept;
    cout << "\n Major Code: " << MyStudents[0].major <<  endl;

    return 0;
}                                                      