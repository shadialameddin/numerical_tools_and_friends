//Program 7-8    Character Strings and enum lists Input and Output

//File: Ch7BirdChoices.cpp

#include <iostream.h>

enum BirdType {robin, rooster, canary, sparrow, roadrunner, finch, eagle };

int main()
{
	char birdlist[7][12] = {"robin", "rooster", "canary", "sparrow", "roadrunner", 
							"finch", "eagle"};
	int i, choice;
	BirdType MyBird;    // One BirdType variable

	cout << "\n Please enter the type of bird  \n";
	for(i = 0; i < 7; ++i)
	{
		cout << i+1  << "  " << birdlist[i] << endl;  //writes 1-7 with bird types
	}

	cout << "\n =======>  ";
	cin >> choice;
	MyBird = (BirdType)(choice-1);
	
	cout << "\n You entered a(n) " << birdlist[MyBird] << endl;
	return 0;
}
