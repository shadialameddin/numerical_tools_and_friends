// Program 2-7  Two Ways to Calculate Temperature

#include <iostream.h>     
int main ()             
{ 
	double celsius = 100.0;
	double farenOK, farenNOTOK;
   
	cout << "\n Two Temperature Conversions  100 C to 212F";

	cout << "\n 100 Degrees Celsius is 212 Degrees Farhenheit\n";

	farenOK = 9.0/5.0*celsius + 32.0;
	cout << "\n Using correctly coded  9.0/5.0 ==> F = " << farenOK;

	farenNOTOK = 9/5*celsius + 32.0;
	cout << "\n\n Using incorrectly coded 9/5 ==> F = " << farenNOTOK;

	cout << "\n\n Boy what a subtle thing! \n\n";

	return 0;
}
