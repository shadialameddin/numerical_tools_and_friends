// Program 10-6   Acme Vending Machines

//File: Ch10Dispenser.cpp

#include "Ch10Dispenser.h"
#include <iostream>

using namespace std;

void Dispenser::SetStock(string n, float c, int t)
{
    Beverage = n;
    cost = c;
    total = t;
}
    
void Dispenser::LetEmHaveIt()
{

    cout << "\n You selected a " << Beverage << "  ENJOY!  ";
    total--;
}
