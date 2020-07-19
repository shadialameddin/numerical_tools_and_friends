//Program 11-11 The Animals

//File: Ch11Animals.cpp

#ifndef  _ANIMALS_H
#define  _ANIMALS_H


#include <string>
using namespace std;

class Date
{
private:
	int mon,day,yr;
public:
	Date(){mon = 1; day = 1; yr = 2000; };
	void SetDate(int m, int d, int y);
	void ShowDate();
};

enum Category { mammal, fish, bird, reptile, amphibian, insect };
enum Species { dog, cat, scrubjay, sparrow, frog, toad };

class Animal
{
protected:
	string name;
	Species whatIam;
	Date birth;
	Category type;
public:
	Animal(Category t, Species s, string n, Date b);
	void Write();
};

class Mammal : public Animal
{
private:
	double height;
public:
	Mammal(Category t, Species s, string n,Date b, double h);
	void SayHello();
	void FavoriteFood();
};

class Bird: public Animal
{
private:
	double wingspan;
public:
	Bird(Category t, Species s, string n,Date b, double w);
	void SayHello();
	void FavoriteFood();
};

class Amphibian: public Animal
{
private:
	double length;
public:
	Amphibian(Category t, Species s, string n,Date b, double l);
	void SayHello();
	void FavoriteFood();
};


#endif
