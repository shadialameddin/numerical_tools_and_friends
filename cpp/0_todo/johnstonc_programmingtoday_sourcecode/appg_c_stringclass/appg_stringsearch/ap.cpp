// Program G-3   String Class Example Program using Search Functions

//File: AppGStringSearch.cpp

#include <iostream>   //C++ header style since using C++ string class
#include <string>
#include <valarray>

using namespace std;


int main()
{
	string S1("One potato, two potato, three potato, four.");
	string S2("potato");
	
	string S3("apples" );
	string S4("bananas");
	//char Mystring[20] = "fruit and nuts"; 
	//	int flag = S3.compare(11, 7, S4);
	//S3.append(Mystring,8, 9);
	cout << endl << S3;

	int flag;
	flag= S3.compare(1, 1, S4);
	int First_pos, Last_pos;
	
	//Write the initial string values

	cout << "\n          S1 = " << S1;
	cout << "\n          S2 = " << S2;


	// Search S1 for "potato" from start of the string
	First_pos = S1.find(S2,0);
	cout << "\n The first \"potato\" is at " << First_pos;

	// string::npos is defined as the length of the string
	Last_pos = S1.rfind(S2,string::npos);  
	cout << "\n The last \"potato\" is at " << Last_pos;

	S1 = "\nAll done with strings.";
	cout << S1 << endl;

	return 0;
}


