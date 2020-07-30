// Program G-2   String Class Example Program using Editing Functions

//File: AppGStingEdit.cpp

#include <iostream>   //C++ header style since using C++ string class
#include <string>

using namespace std;


int main()
{
	string S1("It is a rainy day.");
	string S2("very ");
	string S3("sunny ");
	
	//Write the initial string values

	cout << "\n          S1 = " << S1;
	cout << "\n          S2 = " << S2;
	cout << "\n          S3 = " << S3;

	// Insert "very " into S1
	S1.insert(8,S2);
	cout << "\n          S1 = " << S1;
	
	// Replace "rainy" with "sunny" in S1
	S1.replace(13, 6, S3);
	cout << "\n          S1 = " << S1;

	// Erase "very" from S1
	S1.erase(8, 5);
	cout << "\n          S1 = " << S1;

	S1 = "\nAll done with strings.";
	cout << S1 << endl;

	return 0;
}


