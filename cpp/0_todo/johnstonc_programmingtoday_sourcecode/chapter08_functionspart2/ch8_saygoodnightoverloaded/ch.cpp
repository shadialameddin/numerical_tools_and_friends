//Program 8-10  Using overloaded functions to say goodnight. 

//File: Ch8SayGoodnightOverloaded.cpp

#include <iostream.h>

void SayGoodnight();    //three different prototypes, same function name
void SayGoodnight(char [] );
void SayGoodnight(char [], char[]);

int main()
{
	char dog[25] = "Jack Russell", cat[25] = "Miss Kitty ";

	SayGoodnight();
	SayGoodnight(cat);
	SayGoodnight(dog,cat);

	cout << "\n\n All done saying Goodnight!  \n";
	return 0;
}


void SayGoodnight()
{
	cout << "\n Goodnight!";
}


void SayGoodnight(char one[] )
{
	cout << "\n Goodnight, " << one << "!";
}


void SayGoodnight(char one[], char two[] )
{
	cout << "\n Goodnight, " << one << " and " << two << "!";
}
