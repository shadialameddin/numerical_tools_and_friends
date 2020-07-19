//Program 6-6 Who Do You Love?
//Using cin.getline and cin to read character strings.
#include <iostream.h>
int main()
{
	char text1[15], text2[15] ;
	cout << "\n Using getline(text1,14)   Enter ==> I love C++!  ";
	cin.getline(text1,14);

	cout << "\n Using cin >> text3  Enter ==> I love C++!  ";
	cin >> text2;

	cout << "\n Text1 = " << text1 ;
	cout << "\n Text2 = " << text2 << endl;
	return 0;
}
