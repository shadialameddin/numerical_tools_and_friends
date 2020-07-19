//Program 7-16 Dog Shows 

//File: DogShow.cpp

#include <iostream.h>
#include <stdlib.h>    //for atoi function

enum Breed { husky, heeler, shepherd, pointer, chow, terrier, other};

struct Name 
{
	char first[25];
	char last[25];
};

struct Dog
{
	char fido_name[40];
	Breed type;
	int age;
};

struct Contestant
{
	Name owner;
	Dog fido;
};

              // for both functions we'll pass the char strings for enums

void AskUser4Info(Contestant *, char [][15]);  //we will use a pointer here
void WriteInfo(Contestant, char[][15] );    // no pointers, just send struct to function

int main()
{
	Contestant Joe;    // Joe is our contestant

	char breedlist[7][15] = {"husky", "heeler", "shepherd", "pointer",
		"chow", "terrier", "other"};

	AskUser4Info(&Joe, breedlist);
	WriteInfo(Joe,breedlist);

	cout << "\n All Done with Dogs! \n";
	return 0;
}

void AskUser4Info(Contestant *ptr, char breedlist[][15])
{
	char buf[20];

	cout << "\n Please enter the owner's first name ";
	cin.getline(ptr->owner.first, 25);
	cout << "\n Please enter the owner's last name ";
	cin.getline(ptr->owner.last, 25);

	cout << "\n Please enter the Dog's name ";
	cin.getline(ptr->fido.fido_name,40);

	cout << "\n How old is the dog? ";
	cin.getline(buf,20);
	ptr->fido.age = atoi(buf);

	
	int i,choice;
	cout << "\n Please select the number of the Dog's breed type: \n\n";
	for(i = 0; i<7; ++i)
	{
		cout << i+1 << "  " << breedlist[i] << endl;
	}
	cin.getline(buf,20);
	choice = atoi(buf);

	ptr->fido.type = (Breed)(choice-1);

}


void WriteInfo(Contestant Joe, char breedlist[][15] )
{
	cout << "\n\n This is what you entered:" <<
		"\n     Owner : " << Joe.owner.first << " " << Joe.owner.last <<
		"\n Dog's Name: " << Joe.fido.fido_name <<
		"\n        Age: " << Joe.fido.age <<
		"\n      Breed: "  << breedlist[Joe.fido.type] << endl;

	
}


