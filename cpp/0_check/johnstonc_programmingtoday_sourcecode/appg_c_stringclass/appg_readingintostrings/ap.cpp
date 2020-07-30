// Program G-5  Reading into a String 

//File: AppGReadingIntoStrings


#include <iostream>   
#include <string>
using namespace std;

int main()
{
	string S1;

	char MyArray[50]; 

	cout << "\n Enter your favorite string saying " << endl;
	cin.getline(MyArray,50);


	//Assign the array contents into S1
	S1.assign(MyArray);



	cout << "\n Here is your saying twice! "<< endl;
	cout << MyArray << endl;
	cout << S1 << endl;

	return 0;
}
