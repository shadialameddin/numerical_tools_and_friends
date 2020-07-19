//Program 8-7 Cats and Dogs Call by Reference-using reference parameters 

//File: Ch8CatsAndDogs.cpp

#include <iostream.h>

void GetPetInfo(bool&, int&, bool&, int&);   // dog data, cat data using reference
void WritePetInfo(bool, int, bool, int);

int main()
{
	bool bDog, bCat;    //flags that are set true or false
	int DogNum, CatNum;
	
	// These 2 call statements look identical, but GetPetInfo, sends the addresses of the
	// variables to the function, and WritePetInfo sends copies of the variables.
	GetPetInfo(bDog, DogNum, bCat, CatNum); 
	WritePetInfo(bDog, DogNum, bCat, CatNum);    

	if(bDog || bCat) 
		cout << "\n Don't you just LOVE owning pets? \n ";
	return 0;
}

 void GetPetInfo(bool &rbDog, int &rDogNum, bool &rbCat, int &rCatNum)
{
	char answer;
	// first assume the answers will be no & set flags to false and nums to zero
	rbDog = false;
	rbCat = false;
	rDogNum = 0;
	rCatNum = 0;

	// Now, ask the questions
	cout << "\n Do you have any dogs?  y = yes, n = no   ";
	cin >> answer;
	if(answer == 'y')
	{
		cout << "\n How many dogs do you have?   ";
		cin >> rDogNum;
		rbDog = true;
	}
	cout << "\n Do you have any cats?  y = yes, n = no   ";
	cin >> answer;
	if(answer == 'y')
	{
		cout << "\n How many cats do you have?   ";
		cin >> rCatNum;
		rbCat = true;
	}
}

void WritePetInfo(bool bDog, int DogNum, bool bCat, int CatNum)
{
	cout << "\n\n Dog and cat ownership data: ";
	if(bDog == true)
		cout << "\n You own " << DogNum << " dogs. ";
	else 
		cout << "\n You don't own any dogs. ";
	
	if(bCat == true)
		cout << "\n You own " << CatNum << " cats. \n";
	else
		cout << "\n You don't own any cats.\n ";
}
