// Program 10-6   Acme Vending Machines

//File: Ch10MoneyCtr.h

#ifndef _MONEYCTR_H
#define _MONEYCTR_H
class MoneyCtr
{
private:
    float input_amount;

public:
    MoneyCtr(){ input_amount = 0;}  
    void GetMoney();    
    float HowMuchDoWeHave() { return input_amount;}
    void Clear(){ input_amount = 0;}
    void ReturnMoney(float );
};

#endif