// Program 10-6   Acme Vending Machines

//File: Ch10VendingMachine.h

#ifndef _VENDINGMACHINE_H
#define _VENDINGMACHINE_H
#include "Ch10MoneyCtr.h"
#include "Ch10Dispenser.h"

class VendingMachine
{
private:
    MoneyCtr bank;
    Dispenser D[5];
    
public:
    VendingMachine();
    void ShowChoices();
    void InsertMoney(){ bank.GetMoney();}
    bool DispenseItem(int selection);
    void ReturnAllMoneyAndExit();
    
};
#endif