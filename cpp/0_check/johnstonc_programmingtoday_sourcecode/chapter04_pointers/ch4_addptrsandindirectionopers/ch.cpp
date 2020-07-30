//Program 4-5  Addition, Pointers and Indirection Operator
#include <iostream.h>

int main()
{
	int a, b, c;
	int *a_ptr = &a, *b_ptr = &b, *c_ptr = &c;  //declare and assign addresses

	*a_ptr = 5;   //assign values where pointers are pointing
	*b_ptr = 7;
	*c_ptr = *a_ptr + *b_ptr;   /* using pointers to access the values in a and b  add them and place answer into c, using *c_ptr  */

	//write out values using 
	cout << "\nAddition using pointers to access variables. \n" <<
         *a_ptr << "  +  " <<  *b_ptr << "  =  " << *c_ptr <<endl;

	return 0;
}

 