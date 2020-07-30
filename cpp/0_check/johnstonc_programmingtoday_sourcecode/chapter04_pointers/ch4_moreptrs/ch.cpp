//Program 4-6  What are pointers pointing to?
#include <iostream.h>
#include <iomanip.h>

int main()
{
	
//set up variables and assign addresses into pointers
	int m , *m_ptr = &m;    
	float p, *p_ptr = &p;
	
//assign values where the pointers are pointing
	*m_ptr = 4;             
	*p_ptr = (float)3.14159;

	
//write each pointer's value, address and what the pointer is pointing to 
	
	cout << "\nPtr Name    Value    Address    Pointing to  \n" <<
	    	"\n m_ptr   " << m_ptr << setw(12) << &m_ptr 
			<< setw(10) << *m_ptr << 
	        "\n p_ptr   " << p_ptr << setw(12) << &p_ptr 
			<< setw(10) << *p_ptr << endl;

	return 0;
}
