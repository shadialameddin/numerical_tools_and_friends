//Program new with nothrow option
#include <iostream>
#include <new>		//for the nothrow new operator
using namespace std;
int main()
{
	int *int_pointer;
	


	int_pointer = new(nothrow) int[100];		//memory for 100 ints
	if(int_pointer == NULL)			//check the value in the pointer
	{
		cout << "\n NO MEMORY, BAIL OUT!";
		exit(1);
	}
	return 0;
}
