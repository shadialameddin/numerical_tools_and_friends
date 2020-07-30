//Program 11-11 The Animals

//File: Ch11Animals.cpp

#include <iostream.h>
#include "Ch11Animals.h"

using namespace std;

int main()
{

	cout << "\n The Animals Program " << endl;


	Date temp;
	temp.SetDate(12,25,1995);
	Mammal Fido(mammal, dog, "Noel", temp, 2.5);
	Fido.Write();
	Fido.SayHello();
	Fido.FavoriteFood();

	temp.SetDate(6,10,1999);
	Amphibian GreenGuy(amphibian, frog, "Spooky", temp, 0.4);
	GreenGuy.Write();
	GreenGuy.SayHello();
	GreenGuy.FavoriteFood();
	temp.SetDate(4,25,1998);

	Bird Noisy(bird, scrubjay, "Mrs Blue", temp, 1.8);
	Noisy.Write();
	Noisy.SayHello();
	Noisy.FavoriteFood();

	cout << "\n What a busy place! \n\n";
	return 0;
}