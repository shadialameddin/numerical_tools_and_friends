//Program 4-9  How Big Is Your Pyramid? and Pointers

#include <iostream.h>

int main()
{
	double length, width, height, volume;
	double *l_ptr, *w_ptr, *h_ptr, *v_ptr;
	
	//assign the addresses into the pointers

	l_ptr = &length;
	w_ptr = &width;
	h_ptr = &height;
	v_ptr = &volume;
	
	// ask user for pyramid dimensions
	cout << "\n\n Please enter the length and width of your pyramid base  ";
	cin >> *l_ptr >> *w_ptr;
	cout << "\n Great!  How tall is your pyramid?  ";
	cin >> *h_ptr;

	//calculate the volume, accessing all numeric values through their pointers

	*v_ptr = (*l_ptr) * (*w_ptr) * (*h_ptr) / 3.0;

	cout << "\n Your pyramid's base is " << length << " x " << width;
	cout << "\n The height is " << height;
	cout << "\n\n The volume is " << volume << endl;

	return 0;

}
