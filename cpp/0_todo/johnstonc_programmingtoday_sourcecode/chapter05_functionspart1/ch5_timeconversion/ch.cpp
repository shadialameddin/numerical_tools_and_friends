//Program 5-12  Time conversion  H:M:S to seconds


#include <iostream.h>
#include <stdlib.h>

void GetTime(int*, int*, int*);
int CalcSeconds(int, int, int);


int main()
{
	int hr, min, sec;
	char another;
	int total_sec;

	cout << "\n\n Welcome to a time conversion program!  \n\n";

	do
	{
		GetTime(&hr, &min, &sec);
		total_sec = CalcSeconds(hr, min, sec);

		cout << "\n\n You entered " << hr << ":" << min << ":" << sec;
		cout << "\n It is " << total_sec << " seconds ";
	
		cout << "\n\n Do another?  y or n ";
		cin >> another;

	} while(another == 'y'|| another == 'Y');

	cout << "\n Thanks for Playing! \n";

	return 0;
}


void GetTime(int *h_ptr, int *m_ptr, int *s_ptr)
{
	int ask_them_again = 1;
	char colon;

	while(ask_them_again == 1)
	{
		cout << "\n Please enter the time in hours minutes seconds ";
		cout << "\n Such as  4:15:34  (Note: Minutes and Seconds less than 60)\n\n==>  ";
		cin >> *h_ptr >> colon >> *m_ptr >> colon >> *s_ptr;

		ask_them_again = 0;  //assuming time is OK,
			   
		if(*m_ptr > 59 || *s_ptr > 59)
		{
			cout << "\n WHOA!!! Invalid Time !!! ";

			ask_them_again = 1;   //need to ask them again

		
		}
	
		
	}
}
   

int CalcSeconds(int hr, int min, int sec)
{
	int total_sec;

	total_sec = hr*3600 + min*60 + sec;
				  
	return total_sec;

}