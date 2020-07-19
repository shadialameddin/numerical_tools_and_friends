# CPP
http://www.stroustrup.com/
https://isocpp.org/
https://isocpp.org/get-started
https://blogs.msdn.microsoft.com/vcblog/
http://www.stroustrup.com/C++.html
https://isocpp.org/files/papers/N3690.pdf      list of reserved keywords


- **Polymorphism**

A pointer to a class can point to any object derived from this class or any object derived from an inherited class 


- **Memory**

Memory location refers to the place in which the variable is found in memory.  This doesn't refer to the physical memory address as you might expect but more to the logical division of memory that applies to a running application.  There are two logical memory areas known as the stack and the heap.  The stack is a location in memory where intrinsic data is stored as well as memory addresses (pointers).  It operates in the form of data structure known as a stack.  Like a cafeteria stack of plates, items are pushed on top of the stack and other items are pushed further down.  To remove an item from the stack, it is popped off, used, and discarded.
The heap, or free store, is a pool of memory that is used to store objects that dynamically allocated at run time by your application.  An object is what you will learn about in the next topic on object-oriented programming.  You create and destroy objects on the heap by using specific instructions in your program code.


- static - identifiers declared with static are allocated when the program starts and deallocated when the program execution ends.  Declaring a variable as static in a function means that the variable will retain its value between calls to the function.
- extern - used to declare an object that is defined in another translation unit of within the enclosing scope but has an external linkage.
- thread_local - declares that the identifier is only accessible on the thread in which it is created.  This prevents sharing of the identifier across multiple threads in the same application.   This is part of the C++11 standard.


    [inline] void f(…) {…};

We can optionally qualify a function definition with inline, which asks the compiler to
expand calls to the function inline when appropriate—that is, to avoid function-call overhead
by replacing each call to the function by a copy of the function body, modified as necessary.
To do so, the compiler needs to be able to see the function definition, so inline s are
usually defined in header files, rather than in source files.

Some aspects of your code, such as non-object data types, like int, double, bool, are scoped in a specific way and stored in the logical division of memory known as the stack.  When these variables go out of scope in your code, the memory on the stack is reclaimed automatically.   Not so much with objects.

- **Erros**

Compilers errors are addressed as “Cxxxx”
Linker errors are addressed as “LNKxxxx”

    <stdexcept>
    throw domain_error("median of an empty vector");
    try {
    } catch (std::domain_error e){
      cout << e.what();
    }
    logic_error
    length_error
    range_error
    domain_error
    out_of_range
    overflow_error
    invalid_argument
    runtime_error
    underflow_error


| **Type Name**      | **Bytes** | **Alias**                                                                | **Range**                                               |
| ------------------ | --------- | ------------------------------------------------------------------------ | ------------------------------------------------------- |
| int                | 4         | signed                                                                   | –2,147,483,648 to 2,147,483,647                         |
| unsigned int       | 4         | unsigned                                                                 | 0 to 4,294,967,295                                      |
| __int8             | 1         | char                                                                     | -128 to 127                                             |
| unsigned __int8    | 1         | unsigned char                                                            | 0 to 255                                                |
| __int16            | 2         | short, short int, signed short int                                       | –32,768 to 32,767                                       |
| unsigned __int16   | 2         | unsigned short, unsigned short int                                       | 0 to 65,535                                             |
| __int32            | 4         | signed, signed int, int                                                  | –2,147,483,648 to 2,147,483,647                         |
| unsigned __int32   | 4         | unsigned, unsigned int                                                   | 0 to 4,294,967,295                                      |
| __int64            | 8         | long long, signed long long                                              | –9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 |
| unsigned __int64   | 8         | unsigned long long                                                       | 0 to 18,446,744,073,709,551,615                         |
| short              | 2         | short int, signed short int                                              | -32,768 to 32,767                                       |
| unsigned short     | 2         | unsigned short int                                                       | 0 to 65,535                                             |
| long               | 4         | long int, signed long int                                                | –2,147,483,648 to 2,147,483,647                         |
| unsigned long      | 4         | unsigned long int                                                        | 0 to 4,294,967,295                                      |
| long long          | 8         | none                                                                     | –9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 |
| unsigned long long | 8         | none                                                                     | 0 to 18,446,744,073,709,551,615                         |
| float              | 4         | none                                                                     | 3.4E +/- 38 (7 digits)                                  |
| double             | 8         | none                                                                     | 1.7E +/- 308 (15 digits)                                |
| long double        | 8         | none                                                                     | 1.7E +/- 308 (15 digits)                                |
| size_t             |           | Unsigned integral type (from <cstddef> ) that can hold any object's size |                                                         |
| string::size_type  |           | Unsigned integral type that can hold the size of any string              |                                                         |
| ptrdiff_t          |           | <cstddef> (the different between pointers which might be negative)       |                                                         |



| **Type Name**                   | **Bytes** | **Alias** | **Range**                                                       |
| ------------------------------- | --------- | --------- | --------------------------------------------------------------- |
| char                            | 1         | none      | –128 to 127 by default 0 to 255 when compiled by using /J       |
| signed char                     | 1         | none      | -128 to 127                                                     |
| unsigned char                   | 1         | none      | 0 to 255                                                        |
| wchar_t, char16_t, and char32_t | 2 or 4    | __wchar_t | 0 to 65,535 (wchar_t & char16_t), 0 to 4,294,967,295 (char32_t) |

| **Type Name** | **Bytes** | **Alias** | **Range**                            |
| ------------- | --------- | --------- | ------------------------------------ |
| bool          | 1         | none      | true or false                        |
| enum          | varies    | none      | dependant on the enclosed data types |

- **Initialisation**
    int myVar = 0;
    int yourVar{1};
    const int a=11;
    int const a=11;
    auto i=3/2; //int     auto i=3.0/2; //double
- **Casting**
    long myLong = (long)myInt;
    // or you can use this version as well
    long myLong = long(myInt);
    ch = static_cast<char>(i);   // int to char
- **Arrays**
    //arrays cannot grow or shrink dynamically - they do not have
    //the size_type member
    // the name of an array is a pointer to it's first element
    int arrayName[10];
    int arrayName[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int number = arrayName[2];
- **Structures**
    struct coffeeBean 
    { 
    Private:
         string name; 
         string country; 
         int strength; 
    Public:     
         std::istream& read(std::istream&);
         double grade() const;
    };
    istream& Student_info::read(istream& in)
    { 
    return ::grade(midterm, final, homework); // gets out of the current name scope
    }
    coffeeBean myBean = { "Strata", "Columbia", 10 }; 
    cout<<myBean.name<<endl;
- **Unions**
    //The union can only store a value in one of its fields at a time. [less memory usage]
    union numericUnion 
    { 
         int intValue; 
         long longValue; 
         double doubleValue; 
    };
- **Enumerations**
    enum Day { Sunday=2, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday };
    Day payDay; 
    payDay = Thursday;
    cout << payDay << endl;
| **Operator**     | **Description**          |
| ---------------- | ------------------------ |
| +                | addition                 |
| -                | subtraction              |
| *                | multiplication           |
| /                | division                 |
| %                | modulo                   |
| += (y += x)      | same as y = y + x        |
| -= (y -= x)      | same as y = y - x        |
| *= (y *= x)      | same as y = y * x        |
| i++          ++i | increment by 1           |
| --               | decrement by 1           |
| ==               | equal to                 |
| !=               | not equal to             |
| >                | greater than             |
| <                | less than                |
| >=               | greater than or equal to |
| <=               | less than or equal to    |
| &&               | logical AND              |
| ||               | logical OR               |
| !                | logical NOT              |

- **Conditions**
    cout << ( i > j ? i : j ) << " is greater." << endl; // Ternary Operator
    ( i > j) ? i : j;
    
    if (response == 'y' || response == 'Y')
    {
        cout << "Positive response received" << endl;
    }
    else
    {
      //
    }
    
    switch (response)
    {
       case 'y':
          // Block of code executes if the value of response is y.
          break;
       case 'Y':
          // Block of code executes if the value of response is Y.
          break;
       //...
       default:
          // Block executes if none of the above conditions are met.
          break;
    }
    // switch statements support the following data types as expressions:
    // intrinsic data types such as int or char
    // enumerations
- **Loops**
    for (int i=0;i<5;++i) // for ([initializer(s)]; [condition]; [iterator]) 
    {
    }
    
    while ()
    {
    }
    
    do
    {        
    } while (response != "Quit");
    while (cin >> x) {
    }
- **Containers: Sequential (**Iterators) **versus random access (**indices**)**
    <algorithm>
    // Algorithms act on container elements—they do not act on containers.
    for (auto iter=v.begin();iter<v.end();iter++) {
                    std::cout << *iter <<endl; // an interator is a pointer 
                    iter->name; // if v elements are of a structure type
                    iter = students.erase(iter);
            }
    list<double> L // is usefull if we want to add and delete elements from it
    back_inserter(L) // an iterator adaptor
    front_inserter(c)
    inserter(c, it)
    The stream iterators are defined in the <iterator> header.
    copy(istream_iterator<int>(cin), istream_iterator<int>(),back_inserter(v))
    copy(v.begin(), v.end(), ostream_iterator<int>(cout, " "));
    
    Input iterator:
    Output iterator:
    Forward iterator:
    Bidirectional iterator:
    Random-access iterator:
- associative container (Containers that support efficient look-up)
    <map>
    map<string, int> counters; // store each word and an associated counter
    map<string, vector<int> >
    pair<K, V>
    map<K, V> m(cmp);
    Creates a new empty map with keys of type const K and values of type V , that uses the
    predicate cmp to determine the order of the elements.
    m[k] // [] is not allowed on a const map .


    sort(iter1,iter2,predicate)
    copy
    find, find_if, search // find returns its second argument if it fails to find the value that it seeks       [iter1,iter2) // last element is not included
    remove_if // only sorts then we need erase to actually shorten the container
    remove_copy,remove_copy_if
    partition, stable_partition
    equal
    transform(iter1,iter2,out_iter,function) // apply function to each element in [iter1,iter2]
    accumulate(v.begin(), v.end(), 0.0) // <numeric>
    s.erase
- **Functions**
    int Sum(int x, int y)
    {
         return x + y;
    }
    // In C++, function prototypes belong in header files. 
    inline void swap(int & a, int & b)
    {
         int temp = a;
         a = b;
         b = temp;
    }
- **Classes**
    // #include "xxx.h" 
    // When we use a #include directive with double quotes rather than angle brackets, surrounding the header name, we are saying that we want the compiler to copy the entire contents of the header file that corresponds to that name into our program in place of the include directive
    class Rectangle
    {
    public:
        int area() const {return this->_width * this->_height;}
        // important to use with constant objects
        int get_width(){}
        void resize(){}
        Rectangle():base_shape(),_width{},_height{}
        {} // user-defined conversion
        ~Rectangle(){} // destructor
        
        Student_info::Student_info(): midterm(O), final(0) { }
    private:
        int _width;
        int _height;
    };
    
    Rectangle A(x,y)
    Rectangle A{x,y}
    Rectangle A{}     // value initialization
    Rectangle *C = new Rectangle{};
    // Rectangle.cpp
    int Rectangle::area(){}
    std::cout << pOne->GetLastName() << endl;
    
    // you use the class name followed by either a dot operator (.) or the arrow member selection operator (->) then the name of the member (variable or function)
    
    // #pragma once.  This is a preprocessor directive that tells the compiler to only include this header once, regardless of how many times it has been imported in the program.
    
    // static class Math.  The static keyword needs a little explanation so let's get that out of the way first.  When we declare a class as static, it is an indicator that we do not have to instantiate the class to use it in our program.   Math::Sum()
    
    // In order to call the function from a static class, the function must also be static.
    
    // The second reason is a little more complex and arises when your class contains a member that is a class itself.  The compiler's default constructor is unable to initialize that member.
    
    #ifndef GUARD_median_h
    #define GUARD_median_h
    // median.h—final version
    #include <vector>
    double median(std::vector<double>);
    #endif
    
    * Overloading
    T& operator[](size_type i) { return data[i]; }
    const T& operator[](size_type i) const { return data[i]; }
    Vec& operator=(const Vec&); // assignment, Vec<T>::operator=
    string spaces(url_ch.size(), ' ') ; // initialization
    string y = "..."; // initialization
    y = url_ch;       // assignment
    *** constructor, copy constructor, assignment operator, and destructor
    cin >> s; // is equivalent to
    cin.operator>>(s);
    
    // s.operator>>(cin); s >> cin;
- **Pointers & references**
    //pointers are a kind of iterators
    //functions names are pointers to these functions
    int (*fp)(int); // pointer to a function that takes an integer argument
    // with function names no need to use * or & operators
    // calling a function pointer automatically calls the function to which it points.
    typedef double (*analysis_fp)(const vector<Student_info>&);
    // get_analysis_ptr returns a pointer to an analysis function
    analysis_fp get_analysis_ptr();
    
    int* pNum = &num;
    nullptr // you could use also pointer to zero   pNum = 0
    int &refNum = num;
    void passByRef(int &num1);
    int *pInt = new int; 
    // Quite simply, a memory address is a fixed size on a specific computer architecture.  In this case it takes 4 bytes to hold a memory address.
    delete pInt;
    // chw is a read-only synonym for homework
    const vector<double>& chw = homework;

    
A namespace is a "scope container" where you can place your classes, variables, or other identifiers to prevent conflicts with others.

    namespace Microsoft
    {
    }
    Microsoft::Geometry::Area(radius);

Libraries

    #include "stdafx.h"


- **Inheritance**
    class Car: public Vehicle, public Customised // private Vehicle // protected Vehicle
    { 
         // member list includes Make and Color
         // other Car specific members would go here.
    };
| **Type of Inheritance**                                                                                                         |                                                                                                                                 |                                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **public**                                                                                                                      | **protected**                                                                                                                   | **private**                                                                                                                     |
| public members are public in derived class and can be accessed directly by member functions and nonmember functions             | public members become protected members in derived class and can be accessed directly by member functions                       | public members become private in derived class and can be accessed directly by member functions                                 |
| protected members are protected in derived class and can be accessed directly by member functions                               | protected members become protected members in derived class and can be accessed directly by member functions                    | protected members become private in derived class and can be accessed directly by member functions                              |
| private members are hidden in derived class and can be accessed by member functions though public or protected member functions | private members are hidden in derived class and can be accessed by member functions though public or protected member functions | private members are hidden in derived class and can be accessed by member functions though public or protected member functions |

Friend functions & classes

    class can define an external function as a friend function. This allows the friend function to access all the members of the class, including private members. Friend functions are non-members, which means they don't receive a "this" pointer. Consequently, they must require an explicit parameter to access an object. 
        class MyClass
        {
            friend void SomeExternalFunction(MyClass & targetObject);
        };
    A good example of friend classes is the "handle-body" idiom in C++. This idiom splits one semantic class into two related class - a "body" class that defines the private data, and a "handle" class that defines the public behavior. The body defines the handle class as a friend class, so that the handle class can access all the members (including private members) in the body class. 
    class Handle;  // Forward reference of the "handle" class, so the compiler knows about it.
        class Body
        {
            friend class Handle;
        private:
            int someData;
        };
        
        #include "Body.h"
        class Handle
        {
        private:
            Body * body; // The "handle" class typically maintains an internal instance of the "body" class.
        public:
            Handle();
            ~Handle();
            void someOperationOnBody();
        };
        

Virtual Functions

    // virtual functions are used to ensure that each inhereted class calls the corresponding member function 
    //virtual functions: These functions must be defined, regardless of whether the program calls them
     public:
        virtual void display() const;        // Overrideable function.
        virtual void display() = 0;         // Pure virtual (abstract)
        // abstract class is a class that contains at least one pure virtual function [we can't define an object of a base class type]
    // Note that you don't have to override virtual functions if you don't want to.     
    // By defining a virtual destructor in the base class, you ensure that the correct destructor is always called when you delete an object. We discuss this subject in more detail shortly.
- **Strings & streams**
    // streams use << & >> operators
    #include <sstream>// For std::stringstream.
    - std::istringstream inherits from std::istream.
    - std::ostringstream inherits from std::ostream.
    - std::stringstream inherits from std::iostream, which in turn inherits from both std::istream and std::ostream.
    
    char isAString[6] = { 'H', 'e', 'l', 'l', 'o', '\0'};
    char isAString[6] = "Hello"; 
    char isAnotherString[] = "Array size is inferred";
    std::string myNewString = "Less typing";
    // Create a stringstream object.
    std::stringstream stream;
    // Set the string content for a stringstream.
    stream.str("Jane 42 15000");
    // Get the content from a stringstream.
    std::cout << "Content of string stream: " << stream.str() << std::endl;
    
       std::stringstream stream("****************");
        stream << "Jane" << " " << 42 << " " << 15000;
    
        // Read formatted data from stringstream.
        std::string name;
        int age;
        double salary;
        stream >> name >> age >> salary;
        
    istream& read_hw(istream& in, vector<double>& hw) // might read from cin or from a file?
    string(maxlen + 1 - students[i].name.size(), ' ')
    #include <cctype>
      isspace(c)   
      isalpha(c)
      isdigit(c)
      isalnum(c)
      ispunct(c)
      islower(c)
      toupper(c)
      tolower(c)
    

Streams

    - cerr is another instance of the ostream class, and allows you to perform output to the stderr device. 
     typedefs (i.e. aliases) that represent character-based instantiations of the basic_istream and basic_ostream template classes respectively
    - clog // for logging purposes
     - typedef basic_istream<char> istream;
    - typedef basic_ostream<char> ostream;
    
    Note that the >> operator inputs a single word, i.e. it stops at the first whitespace character. If you want to input an entire line of text, you should use the std::getline() function instead. This function takes two parameters: //    std::getline(std::cin, name);
    
        std::istream & operator >> (std::istream & is, point & p)
        {
            is >> p.x >> p.y;
            return is;
        }
        
        std::ostream & operator << (std::ostream & os, const point & p)
        {
            os << "[" << p.x << "," << p.y << "]";
            return os;
        }
        
    std::flush; // This is useful if you are displaying debugging information, because it ensures your debug message is displayed immediately
    #include <iomanip>// Necessary for parameterized manipulators.
    #include <iostream>   // Necessary for general stream I/O definitions.
    …
    std::cout << std::setw(10) << -123.45 << std::endl; // – if the value exceeds the minimum field width, it will be displayed in full.
    std::left
    std::internal; // has to do with the sign of the outputted numbers
    std::fixed
    std::cout<<std::scientific;
    std::cout.unsetf(std::ios::fixed | std::ios::scientific)
    std::setprecision(4);
    std::showpos; //noshowpos
    std::hex; // oct
    std::showbase
    std::uppercase

Files

    ifstream infile("in"); //file.c_str()
    ofstream outfile("out");
    string s;
    while (getline(infile, s))
      outfile << s << endl;
    
    https://courses.edx.org/courses/course-v1:Microsoft+DEV210.2x+3T2016/courseware/81e0444c49934fca82068f9b4975a6d8/bbfc1082435c426387ba117c7f10fc2a/?child=first
    
    - std::ifstream inherits from std::istream, and allows you to read data from a file using the >> operator. 
    - std::ofstream inherits from std::ostream, and allows you to write data to a file using the << operator.
    - std::fstream inherits from both std::istream and std::ostream, and allows you to read and write data to/from a file using the >> and << operators.
    
             std::ofstream ofile;
            std::ifstream ifile;
            std::fstream  iofile;
        
            // Open the files.
            ofile.open("file1.dat");    // Opens file1.dat for writing.
            ifile.open("file2.dat");    // Opens file2.dat for reading.
            iofile.open("file3.dat");   // Opens file3.dat for reading/writing.
        
            // Use the files...
        
            // Close the files.
            ofile.close();
            ifile.close();
            iofile.close();
            
            //file stream object's constructors and destructors to open/close the file
            std::ofstream ofile("file1.dat");
            std::ifstream ifile("file2.dat");
            std::fstream  iofile("file3.dat");
            
            - std::ios_base::in
    - Specifies the file will be opened for input operations. This is the default mode for std::ifstream objects.
    - std::ios_base::out
    - Specifies the file will be opened for output operations. This is the default mode for std::ofstream objects.
    - std::ios_base::binary
    Specifies the file will be opened in binary mode, i.e. no formatting will be applied to values when they are read or written.
    - std::ios_base::ate
    - Specifies the initial position for read/write operations is at the end of the file. The default initial position for read/write operations is at the start of the file.
    - std::ios_base::app
    - Specifies that all output operations will occur at the end of the file, thereby preserving the existing content in the file.
    - std::ios_base::trunc
    If you open an existing file for output operations, this flag causes the existing content to be deleted and replaced with the new content that you write in your application.
    
      std::ofstream ofile1;
        ofile1.open("file1.dat", std::ios_base::binary | std::ios_base::app);
    
        std::ofstream ofile2("file2.dat", std::ios_base::binary | std::ios_base::app);
                ofile << "Here is line 1." << std::endl;
              while (std::getline(ifile, line))
          {
              std::cout << line << std::endl;
          }
          
            void write(std::ostream & os)
            {
                os.write((char*)&minimum, sizeof(double));
                os.write((char*)&maximum, sizeof(double));
            }
            
    - istream and ifstream objects keep track of the current "get" position. You can obtain the current get position by calling the tellg() method, and you can modify the current get position by calling the seekg() method. 
    - ostream and ofstream objects keep track of the current "put" position. You can obtain the current put position by calling the tellp() method, and you can modify the current put position by calling the seekp() method. 
    - iostream and fstream objects keep track of both the current "get" and "put" positions. You can obtain the current get and put positions by calling the tellg() and tellp() methods, and you can modify the current get and put positions by calling the seekg() and seekp() methods. 
    

Vectors

    vector<double*> homework;
    homework.push_back(&x);
    std::cout << homework.size() <<std::endl;
    homework[1]=&x;

Typedef

    typedef vector<double>::size_type vec_sz;
    using vec_sz=vector<double>::size_type;



    template<typename T>;
    template<class T>;
    template <typename... MatrixTps> // possibility of expansion
    void f(T& param); 
    typedef typename ... T2
    
    template<class T> T zero() { return 0; } // because T doesn't appear in the arguments list
    double x = zero<double>();
    
    template <class T> class Vec {
    public:
    // interface
      explicit Vec(size_type n, const T& val = T()) { create(n, val); } // only when we have one argument & the user calls the constructor explicitly Vec<...> vi(100);
    private:
    // implementation
    };
- Arguments to main
    int main(int argc, char** argv) // num of arg, pointer to the 1st elements
    {
    // if there are arguments, write them
    if (argc > 1) {
    int i;
    // declare i outside the for because we need it after the loop finishes
    for (i = 1; i < argc-1; ++i)
    // write all but the last entry and a space
    cout << argv[i] << " ";
    // argv[i] is a char*
    cout << argv[i] << endl;
    }
    return 0;
    // write the last entry but not a space
    }


- memory management
  - automatic:                 int x;
  - statically allocated:  static int x;
  - dynamic allocation:  int* p = new int(42);            delete p;             new int(0);
                                           T* p = new T[n];                   delete[] p
    The <memory> header provides a class, called allocator<T> // allocates a block of
    uninitialized memory
    T* allocate(size_t);
    void deallocate(T*, size_t);
    void construct(T*, const T&) ;
    void destroy(T*);
    alloc.destroy(--it);



Rather than adding a ( public ) access function, we can say that the input operator is a
friend of class Str . A friend has the same access rights as a member. By making the
input operator a friend, we can allow it, along with our member functions, to access the
private members of class Str :
class Str {
friend std::istream& operator>>(std::istream&, Str&);
// as before
};

In general, it is useful to make explicit the constructors that define the structure of the
object being constructed, rather than its contents. Those constructors whose arguments
become part of the object usually should not be explicit .

operator double(); // conversion operator
if (cin) { /*...*/ } // istream::operator void* [void* may be converted to bool]

Inheretance
Pointers to a base class may hold addresses of objects of childclasses (polymorphisim)
Core(): midterm(O), final(0) { } // constructor
class Grad: public Core {…}

vector<Core*> students;   // store pointers, not objects
Core* record;
record = new Core; // instead we could define a handle class to manage pointers …

virtual void Core::regrade(double d, double = 0) { final = d; }

static functions may by called without an object (could be called directly)

- **handle class** // other derived classes don’t need to be inherited, only friends with this
  - What we'd like to do is find a way to preserve the good properties of our simpler programs
  - that dealt with either Core objects or Grad objects, and eliminate the problems inherent in
  - our new solution, which can process both kinds of records. It turns out that there is a
  - common programming technique, known as a handle class, that will let us do so.
# Print “details” from each chapter

Plotting
(cin) // current input
interfaces with C++
make_unique


- **14.1.1 A generic handle class**
    template <class T> class Handle {
    public:
    Handle(): p(0) { }
    Handle(const Handle& s): p(0) { if (s.p) p = s.p->clone(); }
    Handle& operator=(const Handle&);
    ~Handle() { delete p; }
    Handle(T* t): p(t) { }
    operator bool() const { return p; }
    T& operator*() const;
    T* operator->() const;
    private:
    T* p;
    };

Handle<Core> student(new Grad);




Compilers

    clang++ -std=c++17 tst.cpp -march=native -03
    g++ -O3 -std=c++17 tst.cpp
    
    -std=c++2a //2020
    
    -O1, -O2, -O3 (apply different levels of optimisation)
    -march=nativ std=c++17 -l 
    -lto Link Time Optimization
    
    -lCPPfile // link to libCPPfile library
    g++ -o myexecutable first.o second.o third.o [other dependencies]
    g++ -o myprogram class1.cpp class2.cpp class3.cpp main.cpp
    
    
    




    Debug

.clang_complete

    -Ibuild/catch/src/catch/include
    -Ibuild/eigen3/src/eigen3
    -Ibuild/range-v3/src/range-v3/include
    -Ibuild/termcolor/src/termcolor/include
    -Ibuild/json/src/json
    -Isrc
    -I/usr/include/jsoncpp
    -I/usr/local/include
    -I/usr/local/include/vtk
    -I/usr/include
    -I/usr/include/vtk


-I'/home/alameddin/_zip_packages/matlab2017/extern/include/'
MWROOT = /home/alameddin/_zip_packages/matlab2017/






# MEX

MWROOT='/home/alameddin/_zip_packages/matlab2017/'
$MWROOT/extern/version/c_mexapi_version.c

mapping from and to

    // tensor4 ten =Eigen::TensorMap<tensor4>(mxGetPr(in), nt, ng, nc, nco);
    Eigen::TensorMap<tensor4> Hdo_t(mxGetPr(Hdo), ntp, ngp, ncomp, ncomp);
    
    Eigen::TensorMap<tensor3> out(mxGetPr(output), ngp, nmodes, ncomp);
    out = eps_p_t;

