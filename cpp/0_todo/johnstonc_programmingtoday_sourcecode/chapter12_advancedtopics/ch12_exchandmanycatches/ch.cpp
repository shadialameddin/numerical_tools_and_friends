//Program 12-8  Exception Handling can have several catches
//File Ch12ExcHandManyCatch.cpp
//we'll throw one exception if the color is not red
//we'll throw a second exception if the color is not red, blue or green

#include <iostream>
#include <string>
using namespace std;

int main()
{
	cout << "\n An Exception-Handling Program with Several Catches\n";
	
	char input_color[10];
	string color;

	cout << "\n Please enter one of these colors: red, blue, or green   ";
	cin.getline(input_color,10);

	color.assign(input_color);	// assign the user's color to the string



	try		
	{
		if(color == "red")
			cout << "\n Oh Happy Day! You entered my favorite color!  \n ";
		else if(color == "blue" || color == "green")
			throw 100;	//throw an exception--we can just use an integer
		else
			throw color; // throw an exception--we pass the string
	}

	

	catch (int i)	//catch the exception, we pass the number to the catch statement
	{
		cout << "\n You entered blue or green. \n";
	}

	catch (string s)
	{
		cout << "\n You entered " << s << " and that wasn't a choice! \n";
	}

	cout << "\n\n Throwing and Catching is Fun!"  << endl;
	return 0;
}
