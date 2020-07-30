// Program G-4   Convert Between Strings and Character String Arrays

//File: AppGConvertBetween.cpp

#include <iostream>   //C++ header style since using C++ string class
#include <string>
using namespace std;

int main()
{
	string S1("I like the sea and C, you see.");
	string S2;
	char MyArray[50] = "Is C++ really a B-?"; 
	const char *MyOtherArray;

	cout << "\n The original string and array" << endl;
	cout << S1 << endl;
	cout << MyArray << endl;

	//First we place MyArray contents into S2 using the assign
	S2.assign(MyArray);

	//Next, we'll stuff the contents of S1 into MyOtherArray
	MyOtherArray = S1.c_str();

	cout << "\n The converted array and string" << endl;
	cout << MyOtherArray << endl;
	cout << S2 << endl;

	return 0;
}
