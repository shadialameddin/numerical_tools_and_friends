//Program 4-7  Write Hello and Pointers

#include <iostream.h>

int main()
{
	int number_of_times, go_again;
	int *num_ptr, *go_again_ptr;

	int i, *i_ptr;

	//assign the addresses into the pointers

	num_ptr = &number_of_times;
	go_again_ptr = &go_again;
	i_ptr = &i;


	//use the indirection operator and pointer to initialize loop variable
	*go_again_ptr = 1;

	while(go_again == 1 )
	{
		cout << "\n Please enter your desired number of Hellos   ";
		cin >> *num_ptr;

		for(*i_ptr = 0; i < number_of_times; ++(*i_ptr)  )
		{
			cout << "\n Hello! ";
		}

		cout << "\n\n Want to see more hellos?  1 = YES, 0 = NO ";
		cin >> *go_again_ptr;

	}
	cout << "\n\n Here is a goodbye for you.  \n GOODBYE!  \n ";

	return 0;
}