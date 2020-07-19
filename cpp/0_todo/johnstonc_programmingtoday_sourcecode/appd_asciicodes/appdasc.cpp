//Appendix D ASCII Character Codes

//File: AppDAsciiCodes.cpp


#include <iostream.h>  //needed for cout to screen
#include <iomanip.h>

int main()
{
	int i=1,ctr;

 	cout<<"\nASCII Character Codes \nDec,Hex,Octal,Symbol\n";
	for(ctr = 1;ctr <= 255; ++ctr)
	{
		if (ctr != 26)
		{
			if(ctr%20 == 0)cin.get();
			i = ctr;
		 
			cout << dec << ctr << ",";
	 
			cout << hex << i << "," ;
			cout << oct << i <<  "," ;
			cout << char(i) << endl;
		}
		++i;

	}
	return 0;
}

