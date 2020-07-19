//Program 4-4  Variables, Addresses and Pointers 
#include <iostream.h>
#include <iomanip.h>
int main()
{
	int a = 75;
	double b = 82;
	int *a_ptr;
	double *b_ptr;
	a_ptr = &a;          //assign addresses of variables into pointers
	b_ptr = &b;
	cout << "\nVARIABLE    VALUES    ADDRESSES\n" <<
        "\n a     " << setw(12) << a << setw(12) << &a << 
		"\n b     " << setw(12) << b << setw(12) << &b << 
		"\n a_ptr "  << setw(12)<< a_ptr << setw(12) << &a_ptr << 
		"\n b_ptr "  << setw(12)<< b_ptr << setw(12) << &b_ptr << endl;

	return 0;
}

 