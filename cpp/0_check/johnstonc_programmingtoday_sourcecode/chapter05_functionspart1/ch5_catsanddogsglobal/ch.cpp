//Program 5-14 Cats and Dogs with Global variables 


/* This program will use global variables.
The program will call the function GetPetInfo, which asks the user
whether he or she owns dogs and cats (and if so, asks how many of each). 

Boolean flags are used to keep track of the yes's and no's. 

The program then calls WritePetInfo, which writes the pet information results 
to the screen. 

Since the data is global,the data is not passed between functions.*/ 


#include <iostream.h>

void GetPetInfo();
void WritePetInfo();

bool bDog, bCat;    //global variables, all functions see/access them
int DogNum, CatNum;

int main()
{
	
	GetPetInfo();
	WritePetInfo();

	if(bDog || bCat) 
		cout << "\n Don't you just LOVE owning pets? \n ";
	
	return 0;
	
}


void GetPetInfo()
{
	
	char answer;

	// first assume the answers will be no & set flags to false and nums to zero
	bDog = false;
	bCat = false;
	DogNum = 0;
	CatNum = 0;

	// Now, ask the questions

	cout << "\n Do you have any dogs?  y = yes, n = no   ";
	cin >> answer;
	
	if(answer == 'y')
	{
		cout << "\n How many dogs do you have?   ";
		cin >> DogNum;
		bDog = true;
	}

	cout << "\n Do you have any cats?  y = yes, n = no   ";
	cin >> answer;
	
	if(answer == 'y')
	{
		cout << "\n How many cats do you have?   ";
		cin >> CatNum;
		bCat = true;
	}

}

void WritePetInfo()
{
	cout << "\n\n Dog and cat ownership data: ";
	
	if(bDog)
		cout << "\n You own " << DogNum << " dogs. ";
	else 
		cout << "\n You don't own any dogs. ";

	
	if(bCat)
		cout << "\n You own " << CatNum << " cats. \n";
	else
		cout << "\n You don't own any cats.\n ";

}


