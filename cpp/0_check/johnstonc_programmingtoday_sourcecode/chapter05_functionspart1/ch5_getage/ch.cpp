//Program 5-3 Simple Functions and How Old Are You?

#include <iostream.h>
void Write_Hello();		//The three prototypes for the user written functions.
int Get_Age();	//Remember, the format is return_type  name(input types list);
void Write_Age(int);

int main()
{
	int age;
	Write_Hello();         // call to Write_Hello, no return or inputs 
	age = Get_Age();       // call to Get_Age, the result is assigned into age
	Write_Age(age);        // call to Write_Age, age is passed to the function

	return 0;
}

//Write_Hello writes a greeting message to the screen
void Write_Hello()		//This is the function header line.
{
	cout << "\n Hello World!";
}

//Get_Age asks the user for his or her age, returns age.
int Get_Age()			//No input arguments, but returns an integer.
{
	int age;
	cout << "\n How old are you?  ";
	cin >> age;
	return age;
}
//Write_Age receives the age value, writes it to the screen
void Write_Age(int age)	//Input is an integer, no return value.
{
	cout << "\n You are " << age << " years old!  \n";
}

