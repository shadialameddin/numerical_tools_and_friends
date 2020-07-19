// Program 10-6   Acme Vending Machines

//File: Ch10VendingMachine.cpp

#include "Ch10VendingMachine.h"
#include <iostream>

using namespace std;

VendingMachine::VendingMachine()
{
    D[0].SetStock("Coke",1.00, 25);
    D[1].SetStock("Pepsi", 1.00, 25);
    D[2].SetStock("BrandX Cola", 0.80f, 25);
    D[3].SetStock("Blue Sky Cola", 1.25, 22);
    D[4].SetStock("Jolt",2.50, 0);
}

void VendingMachine::ReturnAllMoneyAndExit()
{
     bank.ReturnMoney(bank.HowMuchDoWeHave() );

}

void VendingMachine::ShowChoices()
{
    int i;
    cout.precision(2);
    cout.setf(ios::fixed);

    cout << "\n You entered $" << bank.HowMuchDoWeHave();
    cout << "\n Enter the number of your item  (cost) ";

    for(i = 0; i < 5; ++i)
    {
        cout << endl << i << "  ";
        D[i].WhatAmI();
        cout << "  ($" <<  D[i].HowMuchDoICost() << ")";
    }
    cout << "\n\n5   Return Money and Exit  ";
}

bool VendingMachine::DispenseItem(int selection)
{
    int InStock;
    InStock = D[selection].CheckStock();
    if(InStock > 0)
    {
        if(bank.HowMuchDoWeHave() >= D[selection].HowMuchDoICost() )
        {
            D[selection].LetEmHaveIt();
            float change = bank.HowMuchDoWeHave() - 
								D[selection].HowMuchDoICost();
            if (change > 0) bank.ReturnMoney(change);
            return true;
        }
        else
        {
            cout << "\n Not enough cash! \n";
            return false;
        }
    }
    else
    {
        cout << "\n OUT OF STOCK";
        return false;
    }
}