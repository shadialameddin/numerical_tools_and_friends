//Program 9-1 Complete Sphere program in one file and writing the 
//functions withing the class declaration

//File: Ch9SphereOne.cpp

#include <iostream.h>
#include <math.h>

const double pi = 3.15159265;

class Sphere
{
	private:
		double radius, volume, s_area;
	public:
		void Set_Rad(double r) { radius = r; }  
		void CalcVolume()
		{
			volume = 4.0/3.0 * pi * pow(radius,3);
		} 
		void CalcSurfaceArea()
		{
			s_area = 4.0*pi* pow(radius,2);
		}
		void PrintSphere()
		{
			cout << "\n The sphere data is \n radius = " << radius <<
			"\n volume = " << volume << "\n surface area = " << s_area;
		}
};
int main()
{
	cout << "\n Welcome to the Sphere Program!  \n ";
	Sphere MySphere;  

	MySphere.Set_Rad(5.0);   // the sphere radius will be 5.0
	MySphere.CalcVolume();
	MySphere.CalcSurfaceArea();
	MySphere.PrintSphere();
	
	cout << "\n\n All done \n";
	return 0;
}

