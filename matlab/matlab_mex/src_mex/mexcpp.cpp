/*==========================================================
 * mexcpp.cpp - example in MATLAB External Interfaces
 *
 * Illustrates how to use some C++ language features in a MEX-file.
 *
 * The routine simply defines a class, constructs a simple object,
 * and displays the initial values of the internal variables. It
 * then sets the data members of the object based on the input given
 * to the MEX-file and displays the changed values.
 *
 * This file uses the extension .cpp. Other common C++ extensions such
 * as .C, .cc, and .cxx are also supported.
 *
 * The calling syntax is:
 *
 *              mexcpp( num1, num2 )
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2016 The MathWorks, Inc.
 *
 *========================================================*/

#include <iostream>
#include "mex.h"



/* The gateway function. */ 
void mexFunction(int nlhs, mxArray* plhs[],
                 int nrhs, const mxArray* prhs[]) {


}
