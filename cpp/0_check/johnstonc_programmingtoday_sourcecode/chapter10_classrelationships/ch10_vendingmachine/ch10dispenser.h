// Program 10-6   Acme Vending Machines

//File: Ch10Dispenser.h

#ifndef _DISPENSER_H
#define _DISPENSER_H
#include <iostream>
#include <string>
#include <iomanip>

using namespace std;

class Dispenser
{
private:
    string Beverage;
    float cost;
    int total;
public:
    Dispenser(){cost = 0; total = 0;}
    void SetStock(string n, float c, int t) ;
    float HowMuchDoICost( ){ return cost;}
    void WhatAmI(){ cout << setw(15) << Beverage  ; }
    void LetEmHaveIt(); 
    int CheckStock() { return total; }
    
};
#endif