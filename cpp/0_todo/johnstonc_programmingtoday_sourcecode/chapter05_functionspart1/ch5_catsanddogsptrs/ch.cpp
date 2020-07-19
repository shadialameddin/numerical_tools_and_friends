//Program 5-13 Cats and Dogs with bool operators and pointers 

/* This program will call the function GetPetInfo, which asks the user
whether he or she owns dogs and cats (and if so, asks how many of each). 
This function must return 4 data items to the main, so pointers are needed.

 Boolean flags are used to keep track of the yes's and no's. 
 
 The data is then  sent to WritePetInfo, which writes the pet information results 
to the screen. Since the function is not returning anything, pointers are not needed.*/ 


#include <iostream.h>

void GetPetInfo(bool*, int*, bool*, int*);   // dog data, cat data
void WritePetInfo(bool, int, bool, int);

int main()
{
	bool bDog, bCat;    //flags that are set true or false
	int DogNum, CatNum;
	
	GetPetInfo(&bDog, &DogNum, &bCat, &CatNum);
	WritePetInfo(bDog, DogNum, bCat, CatNum);

	if(bDog || bCat) 
		cout << "\n Don't you just LOVE owning pets? \n ";
	
	return 0;
	
}


void GetPetInfo(bool *p_bDog, int *p_DogNum, bool *p_bCat, int *p_CatNum)
{
	
	char answer;

	// first assume the answers will be no & set flags to false and nums to zero
	*p_bDog = false;
	*p_bCat = false;
	*p_DogNum = 0;
	*p_CatNum = 0;

	// Now, ask the questions

	cout << "\n Do you have any dogs?  y = yes, n = no   ";
	cin >> answer;
	
	if(answer == 'y')
	{
		cout << "\n How many dogs do you have?   ";
		cin >> *p_DogNum;
		*p_bDog = true;
	}
	cout << "\n Do you have any cats?  y = yes, n = no   ";
	cin >> answer;
	
	if(answer == 'y')
	{
		cout << "\n How many cats do you have?   ";
		cin >> *p_CatNum;
		*p_bCat = true;
	}

}

void WritePetInfo(bool bDog, int DogNum, bool bCat, int CatNum)
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


