// Program G-1   String Example Program with Overloaded Operators

//File: AppGStringOperators.cpp

#include <iostream>   //C++ header style since using C++ string class
#include <string>

using namespace std;


int main()
{
	string S1("What a great day."), S2, S3;
	char MyOldString[25] = "Howdy Partner";

	string S4(MyOldString);

	S2 = "Do you love C++?";//assignment

	S3 = S1 + S2;

	//Write the initial string values

	cout << "\n          S1 = " << S1;
	cout << "\n          S2 = " << S2;
	cout << "\n          S3 = " << S3;
	cout << "\n          S4 = " << S4;
	cout << "\n MyOldString = " << MyOldString << endl;

	if(S1 > S2)cout << "\n S1 is greater than S2";
	else cout << "\n S1 is not greater than or the same as S2";

	S1 = "\nAll done with strings.";
	cout << S1 << endl;

	return 0;
}


