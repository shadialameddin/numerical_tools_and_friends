// Program 10-6   Acme Vending Machines

//File: Ch10VendingMachineDriver.cpp

#include "Ch10Dispenser.h"
#include "Ch10MoneyCtr.h"
#include "Ch10VendingMachine.h"
#include <iostream> 
#include <iomanip>
#include <string>       // will use C++ string class
#include <math.h>       //for atof function

using namespace std;

int main()
{
    VendingMachine cola;
    char answer[5], selectbuf[5];
    int  selection;
    bool gimme_cash = true, Got_it, go_again;
    
    cout << "\n Welcome to the Acme Vending Machine Program \n\n";
    do
    {

        while(gimme_cash)
        {
            cola.InsertMoney();
            cout << "\n Again?  yes or no  ";
            cin.getline(answer,5);
            if(strcmp(answer,"no")==0)gimme_cash = false;
        }

        cola.ShowChoices();
        cin.getline(selectbuf,5);
        selection = atoi(selectbuf);
        if(selection == 5)
        {
            cola.ReturnAllMoneyAndExit();
            go_again = false;
        }
        else
        {
            Got_it = cola.DispenseItem(selection);

            if(Got_it==true) go_again = false;
            else
            {
                cout << "\n Another selection?  yes or no";
                cin.getline(answer,5);
                if(strcmp(answer,"yes")==0)
                {
                    gimme_cash = true;
                    go_again = true;
                }
                else
                {
                    cola.ReturnAllMoneyAndExit();
                    go_again = false;
                }
            }
        }
    }while(go_again == true);

    cout << "\n Chug-a-lug!  Goodbye.  \n\n";
    return 0;
}


 

