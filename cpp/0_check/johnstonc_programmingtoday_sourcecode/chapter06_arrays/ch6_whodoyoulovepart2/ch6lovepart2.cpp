
//Program 6-7 Who Do You Love? Part Two
//We will use three different ways to read a phrase.
//1.  cin.getline with a delimiter
//2.  cin 
//3.  cin.getline 
//We use a cin.ignore to flush the enter key from the input queue.

#include <iostream.h>
int main()
{
	char text1[15], text2[15], text3[15];

	cout << "\n Who Do You Love? Part Two \n";

	cout << "\n Using getline(text1,14,'C') Enter ==> I love C++!  ";
	cin.getline(text1, 14, 'C');
	cin.ignore(20,'\n');	

	cout << "                      Output Text1 ==> " << text1;


	cout << "\n\n Using cin >> text2          Enter ==> I love C++!  ";
	cin >> text2;
	cin.ignore(20,'\n');

	cout << "                      Output Text2 ==> " << text2;

	
	cout << "\n\n Using getline(text3,14)      Enter==> I love C++!  ";
	cin.getline(text3, 14);

	cout << "                      Output Text3 ==> " << text3;

	cout << "\n\n\n      Don't you love C++?" << endl;

	return 0;
}
