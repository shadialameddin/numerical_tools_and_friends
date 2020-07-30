//Program 11-11 The Animals

//File: Ch11Animals.cpp

#include <iostream>
#include <string>

#include "Ch11Animals.h"

using namespace std;

void Date::SetDate(int m, int d, int y)
{
	mon = m;   day = d;  yr = y;
}

void Date::ShowDate()
{
	cout <<  mon << "/" << day << "/" << yr ;
}

Animal::Animal(Category t, Species s, string n, Date b)
{
	name = n;   birth = b;   type = t, whatIam = s;
}

void Animal::Write()
{
	char AnimalType[6][15] = {"mammal", "fish", "bird", "reptile", "amphibian", "insect"};
	char SpeciesTypes[6][15] = { "dog", "cat", "scrubjay", "sparrow", "frog", "toad" };
	cout << "\nThis animal is a(n) " << AnimalType[type] <<
		" (" << SpeciesTypes[whatIam] << ")";
	cout << "\nName: " << name << " born on ";
	birth.ShowDate();
}


Mammal::Mammal(Category t, Species s, string n, Date b, double h):Animal(t, s, n, b)
																	
{
	height  = h;
}

void Mammal::SayHello()
{
	if(whatIam == dog)
		cout << "\n Bark Bark hello!";
	else if( whatIam == cat)
		cout << "\n Meeeeooowwww hello! ";

	cout << " and I'm " << height << " feet tall. ";
}

void Mammal::FavoriteFood()
{
	if(whatIam == dog)
		cout << "\n I love to eat cookies! \n";
	else if( whatIam == cat)
		cout << "\n I love to eat birds! \n" ;
}

void Bird::SayHello()
{
	if(whatIam == scrubjay)
		cout << "\n SqqqquuuuAAAAKKK hello! "; 
	else if( whatIam == sparrow)
		cout << "\n Cheep cheep hello! ";
	
	cout << " and my wingspan is " << wingspan << " feet";
}

void Bird::FavoriteFood()
{
	if(whatIam == scrubjay)
		cout << "\n I love to eat peanuts! \n";
	else if( whatIam == cat)
		cout << "\n I love to eat suet! \n";
}


void Amphibian::SayHello()
{
	if(whatIam == frog)
		cout << "\n Ribbit hello  SPLASH!";
	else if( whatIam == toad)
		cout << "\n Croak, don't step on me hello! ";

	cout << " and I'm " << length << " feet long.";
}

void Amphibian::FavoriteFood()
{
	if(whatIam == frog)
		cout << "\n I love to eat flies! \n";
	else if( whatIam == toad)
		cout << "\n I love to eat bugs! \n";
}

Bird::Bird(Category t, Species s, string n, Date b, double w):Animal(t, s, n, b)
	
{
	wingspan = w;
}

Amphibian::Amphibian(Category t, Species s, string n, Date b, double l):Animal(t, s, n, b)
	
{
	length = l;
}
