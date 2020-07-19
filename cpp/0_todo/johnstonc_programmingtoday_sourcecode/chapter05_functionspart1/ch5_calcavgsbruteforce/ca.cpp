//Program 5-1 Calculating Averages for Two Subjects - Brute Force
#include <iostream.h>
int main()
{
    // Declare variables

    float math_sc1, math_sc2, math_sc3, math_ave;
    float sci_sc1, sci_sc2, sci_sc3, sci_ave;

    // Obtain math information and calculate average.
    cout << "\n Please enter your 3 math scores. ";
    cin >> math_sc1 >> math_sc2 >> math_sc3;
 
	math_ave = (math_sc1 + math_sc2 + math_sc3)/(float)3.0;
    
	cout << "\n Your math average is " << math_ave;

    // Obtain science information and calculate average.
    cout << "\n Please enter your 3 science scores. ";
    cin >> sci_sc1 >> sci_sc2 >> sci_sc3;
    
	sci_ave = (sci_sc1 + sci_sc2 + sci_sc3)/(float)3.0;
    
	cout << "\n Your science average is " << sci_ave;
	cout <<endl;

	return 0;
}
