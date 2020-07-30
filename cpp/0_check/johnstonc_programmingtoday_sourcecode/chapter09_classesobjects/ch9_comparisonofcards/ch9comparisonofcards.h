//Program 9-9   Compare Two Cards--Array of Objects

//File: Ch9ComparisonOfCards.h

#ifndef _CH9COMPARISONOFCARDS_H
#define _CH9COMPARISONOFCARDS_H

enum Suit { club, diamond, heart, spade};
enum Rank { two = 2, three, four, five, six, seven, eight, nine, ten, jack,
queen, king, ace};

class Card
{
private:
    Suit color;
    Rank number;
public:
    Card();
    void SetSuit(Suit s ){ color = s; }
    void SetRank(Rank r ){ number = r; }
    void ShowCard();                                           
    int operator > (Card X);
};

#endif