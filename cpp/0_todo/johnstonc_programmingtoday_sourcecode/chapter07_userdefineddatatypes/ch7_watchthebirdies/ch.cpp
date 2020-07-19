//Program 7-8 Example with 2 structure pointers in a function

//File: WatchTheBirdies.cpp

#include <iostream.h>
#include <string.h>

struct Bird
{
    char species[25];
    int count;
    char location[25];
};

struct B_Watcher
{
    char name[50];
    int qualification_code;
};                          

void WatchTheBirdie(Bird *, B_Watcher *);   //prototypes
void WhatDidYouSee(Bird *, B_Watcher *);

int main()
{
    Bird birdie;
    B_Watcher person;

    cout << "\n Watch the Birdie Program  \n";

    WatchTheBirdie(&birdie, &person);   //call sends addresses of structs

    WhatDidYouSee(&birdie, &person);
    return 0;
}

void WatchTheBirdie(Bird *B_ptr, B_Watcher *BW_ptr)
{
    strcpy( B_ptr->species,"sparrow hawk"); 
    B_ptr->count = 3;
    strcpy( B_ptr->location,"Sandia Mountains");
    strcpy(BW_ptr->name,"Ryan Andrew");
    BW_ptr->qualification_code = 5;
}

void WhatDidYouSee(Bird *B_ptr, B_Watcher *BW_ptr)
{
    cout << "\n       Watcher: " <<BW_ptr->name;
    cout << "\n Qualification: " << BW_ptr->qualification_code;
    cout << "\n       Species: " << B_ptr->species;
    cout << "\n         Count: " << B_ptr->count << endl;

}                                   