#include "mex.h"

// test2cpp(magic(5))

/* If you are using a compiler that equates NaN to zero, you must
 * compile this example using the flag -DNAN_EQUALS_ZERO. For 
 * example:
 *
 *     mex -DNAN_EQUALS_ZERO findnz.c  
 *
 * This will correctly define the IsNonZero macro for your
   compiler. */

#if NAN_EQUALS_ZERO
#define IsNonZero(d) ((d) != 0.0 || mxIsNaN(d))
#else
#define IsNonZero(d) ((d) != 0.0)
#endif

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  /* Declare variables. */ 
  int elements, j, number_of_dims, cmplx;
  int nnz = 0, count = 0; 
  double *pr, *pi, *pind;
  const size_t  *dim_array;         

  /* Check for proper number of input and output arguments. */    
  if (nrhs != 1) {
    mexErrMsgTxt("One input argument required.");
  } 
  if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }

  /* Check data type of input argument. */
  if (!(mxIsDouble(prhs[0]))) {
    mexErrMsgTxt("Input array must be of type double.");
  }
    
  /* Get the number of elements in the input argument. */
  elements = mxGetNumberOfElements(prhs[0]);

  /* Get the data. */
  pr = (double *)mxGetPr(prhs[0]);
  pi = (double *)mxGetPi(prhs[0]);
  cmplx = ((pi == NULL) ? 0 : 1);

  /* Count the number of non-zero elements to be able to allocate
     the correct size for output variable. */
  for (j = 0; j < elements; j++) {
    if (IsNonZero(pr[j]) || (cmplx && IsNonZero(pi[j]))) {
      nnz++;
    }
  }

  /* Get the number of dimensions in the input argument. 
     Allocate the space for the return argument */
  number_of_dims = mxGetNumberOfDimensions(prhs[0]);
  plhs[0] = mxCreateDoubleMatrix(nnz, number_of_dims, mxREAL);
  pind = mxGetPr(plhs[0]);

  /* Get the number of dimensions in the input argument. */
  dim_array = mxGetDimensions(prhs[0]);

  /* Fill in the indices to return to MATLAB. This loops through
   * the elements and checks for non-zero values. If it finds a
   * non-zero value, it then calculates the corresponding MATLAB
    * indices and assigns them into the output array. The 1 is 
added 
   * to the calculated index because MATLAB is 1-based and C is
   * 0-based. */
  for (j = 0; j < elements; j++) {
    if (IsNonZero(pr[j]) || (cmplx && IsNonZero(pi[j]))) {
      int temp = j;
      int k;
      for (k = 0; k < number_of_dims; k++) {
        pind[nnz*k+count] = ((temp % (dim_array[k])) + 1);
        temp /= dim_array[k];
      }
      count++;
    }
  }
}