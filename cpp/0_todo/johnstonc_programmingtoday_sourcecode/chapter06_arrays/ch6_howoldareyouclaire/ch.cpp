//Program 6-8 Broken PROBLEM PROGRAM  DOES NOT WORK CORRECTLY
//Using cin.getline and cin to read user information.
#include <iostream.h>
int main()
{
char name[20], football_team[25];
	int age, num_kids;

// ask user for name, age, football team and number of kids
	cout<< "\n  Enter your name:  ";
	cin.getline(name,20);
	cout << "\n  Enter your age:  ";
	cin >> age;
	cout << "\n  What is your favorite football team?  ";
	cin.getline(football_team,24);
	cout << "\n  How many kids do you have?    ";
	cin >> num_kids;

// write info out to screen
	cout << endl << name << ",  your team is " << football_team << 
	"\nYou are " << age << " years old and have " << num_kids << " kids." << endl;

	return 0;
}
