/* Program 6-11 Favorite Word    Read in a word and a phrase and determine if 
   the word is in the phrase. Also report length of word and phrase.  */

#include <iostream.h>
#include <string.h>

bool FindFavorite(char [], char []);

int main( )
{
	char phrase[80],word[15], answer[5];
	bool find_it;

	do {
		cout << "\n Please enter your FAVORITE word ===>  ";
		cin.getline(word,15);

		cout << "\n\n Please type in a sentence or a phrase.  \n\n==>  ";
		cin.getline(phrase,80);

		find_it = FindFavorite(phrase,word);
	
		if(find_it == true)
			cout << "\n I see it! I see ==> " << word << " <==   :-) \n";
		else
			cout << "\n I don't see ==> " << word << " <==    :-(\n";

		cout << "\n\n Do it again?   Enter yes or no  ==> ";
		cin.getline(answer,5);
	}while(strcmp(answer,"yes")== 0);  //strcmp returns 0 is strings match

	cout << "\n\n  Aren't strings wonderful?\n\n";

	return 0;
}

bool FindFavorite(char phrase[], char word[])
{
	bool result;
	char* IsItThere;     //declare a character pointer for strstr

	IsItThere = strstr(phrase,word);

	if(IsItThere == NULL)  
		result = false;
	else 
		result = true;
	
	return (result);
}

