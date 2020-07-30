//Program 9-10 Kitty Kitty  Passes the address of a Kitty object to a function.

//File: Ch9KittyKitty.cpp

#include <iostream.h>
#include <string.h>

class Kitty
{
private:
    char breed[40], name[40];
    int cost;

public:
    Kitty();
    void PutBreed(char b[]){strcpy(breed,b);}
    void PutName(char n[]) {strcpy(name,n); }
    void PutCost(int c) {cost = c; }
    void PrintCatInfo();
};


Kitty::Kitty()       //constructor
{
    strcpy(breed,"unknown");
    strcpy(name, "not named yet");
    cost = 0;
}

void Kitty::PrintCatInfo()
{
    cout << "\n Breed  " << breed << "\n  Name  " << name;
    cout << "\n  Cost  $ " << cost;
}                                                    
/////////////////////////////////////////////

void FillCatInfo(Kitty *);  // protoype, input is an address to a Kitty
//void FillCatInfo(Kitty &);
/////////////////////////////////////////////
int main()
{
    Kitty meow;

    cout << "\n Hair Ball Program \n\n Before the function call:\n";
    meow.PrintCatInfo();

    FillCatInfo(&meow);
    //FillCatInfo(meow);

    cout << "\n\n After the function call:\n";
    meow.PrintCatInfo();

    cout << "\n\n No more kitties for you.  \n ";
                                                     
    return 0;
}

void FillCatInfo(Kitty * pCat)  //pointer
{
    char catname[40] = "Thomas", catbreed[40] = "Alley";
    int catcost = 3;

    pCat->PutBreed(catbreed);   // public Kitty functions accessed w/ pointer
    pCat->PutName(catname);
    pCat->PutCost(catcost);
}

/*void FillCatInfo(Kitty & rCat)   //reference
{
    string catname = "Thomas", catbreed = "Alley";
    int catcost = 3;

    rCat.PutBreed(catbreed);   // public Kitty functions accessed w/ pointer
                                                                               
    rCat.PutName(catname);
    rCat.PutCost(catcost);
}*/                   

                                           