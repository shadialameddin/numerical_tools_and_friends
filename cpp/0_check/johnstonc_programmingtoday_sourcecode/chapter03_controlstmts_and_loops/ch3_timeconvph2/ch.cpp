//Program 3-12 Practice! Time Conversion
#include <iostream.h>
int main()
{
	int choice,hr, min, sec, totalsec;
	char colon;
	do{	
		
		cout << "\nPlease pick your choice:  \n1= Convert H:M:S to second" << "\n2= Convert second to H:M:S  \n3 = Exit\n\n";
		cin >>choice;
		switch(choice)
		{
			case 1:
				cout << "\n Enter time in H:M:S format, such as 3:26:33 ";
				cin >> hr >> colon >> min >> colon >> sec;
				totalsec = hr*3600 + min*60 + sec;
				cout << "\n Your time in seconds is " << totalsec;
				break;
			case 2:
				cout << "\n Enter total seconds, such as 3440 ";
				cin >> totalsec;
				hr = totalsec/3600;
				totalsec = totalsec - hr*3600;
				min = totalsec/60;
				totalsec = totalsec - min*60;
				sec = totalsec;
				cout << "\n Your time is " << hr << ":" << min << ":" << sec;
				break;
			case 3:
				cout << "\n You have chosen to exit.  \n";
				break;
			default:
				cout << "\n Oh I don't do that choice! Try again! ";
		}
	}while(choice != 3);
	
	cout << "\n Bye Bye! \n";
	return 0;
}

