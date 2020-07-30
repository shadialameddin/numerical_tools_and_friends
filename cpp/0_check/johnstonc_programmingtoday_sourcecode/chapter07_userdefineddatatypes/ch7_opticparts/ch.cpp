//Program 7-14 Optics Parts, functions, enums, error codes

//File: Ch7OpticParts.cpp

#include <iostream.h>
#include <iomanip.h>

enum Part {lens , mirror, prism, error };   // set up the enum data

int WhichPart(Part * );       //prototypes for functions
void DoOptics(Part );


int main()
{
	cout << "\n\nOptics Parts\n";
	int error_code;      // 0 = OK, -1 = input error
	Part MyPart;
	error_code = WhichPart( &MyPart );
	
	if(error_code == 0) 
		DoOptics(MyPart);  //only call if no input error
	else
		cout << "\n I don't know what that part is!!! \n\n";


	cout << "\n All done with parts! \n";
	return 0;
}

int WhichPart(Part *P_ptr )
{
	int i,choice, error_code = 0;   //assume no error to start

	char Partname[4][10] = {"lens", "mirror", "prism", "error"};
	
	cout.setf(ios::left);
	cout << "\nPlease enter the number of your optics part:\n";
	for(i = 0; i < 3; ++i)
	{
		cout <<setw(2) << i+1 << setw(10) <<Partname[i] << endl;
	}
	cout << "\n =====> ";
	cin >> choice;

	if(choice >= 1 && choice <=3) 
	{
		*P_ptr = (Part)(choice-1);	//valid part
	}
	else
	{
		*P_ptr = error;
		error_code = -1;	//Whoa!  Had an input error; set the error flag.
	}
		
	return error_code;
}

void DoOptics(Part new_optic)  
{
	switch(new_optic)  {
		case lens:
			cout << "\n I'm doing lens stuff." << endl;
			break;
		case mirror:
			cout << "\n I'm doing mirror stuff." << endl;
			break;
		case prism:
			cout << "\n I'm doing prism stuff." << endl;
	}
}
