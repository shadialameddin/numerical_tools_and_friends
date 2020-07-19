//Program 12-9 Exception Handling and new
#include <iostream>
using namespace std;
int main()
{
	int *int_pointer, size;
	
	cout << "\n Enter the size for your 1D array      ";
	cin >> size;
	try
	{
		int_pointer = new int[size];		//memory for a lot of ints
		if(int_pointer == NULL) throw 100;

		cout << "\n If we made it to this line, no exception was thrown. \n";
	}
	catch(int i)
	{
		cout << "\n Not enough memory, sorry.";
	}

	cout << "\n Check out that catch!" << endl;
	return 0;
}
