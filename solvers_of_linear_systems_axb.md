NR successively better approximations to the roots (or zeroes) of a real-valued function

Gradient descent maximizes a function using knowledge of its derivative. Newton's method, a root finding algorithm, maximizes a function using knowledge of its second derivative. That can be faster when the second derivative is known and easy to compute (the Newton-Raphson algorithm is used in logistic regression).

# Solvers of linear systems (Ax=b)

# Direct methods
- Gaussian elimination (LU factorisation)
  - O(n^3) flops and O(n^2) storage for dense matrices
  - O(n^2) flops and O(n^1.5) storage for sparse 3D FE matrices
Cholesky decomposition
A = LDL' = GG' where G = LD^0.5

**Hard to parallelise? (MPI) // not more than 1000 processors?**

# Iterative methods

O(n) flops and O(n^2) storage // no preconditioner
https://gist.github.com/sagarmainkar/41d135a04d7d3bc4098f0664fe20cf3c
https://en.wikipedia.org/wiki/Conjugate_gradient_method
https://en.wikipedia.org/wiki/Newton%27s_method_in_optimization#Higher_dimensions
GMRES with RSVD instead of GS
line search algorithm
The BFGS method belongs to quasi-Newton methods,
https://en.wikipedia.org/wiki/Broyden%E2%80%93Fletcher%E2%80%93Goldfarb%E2%80%93Shanno_algorithm
- Richardson method
- Steepest descent method
- Conjugate gradient method
- Preconditioner Conjugate gradient (Krylov iterative solver)// Preconditioner is SPD
- GMRES (Krylov solvers)
- MINRES (Krylov solvers)
# Multigrid methods

O(n) flops and O(n) storage



Partitioning

- Metis, Parmetis, Pt-scotch, zoltan
-

Once we created the portions, we can assemble local stiffness matrix in each domain and solve a local problem K u = F (internal and external forces at the current time step are known from the Newton-Raphson iteration)
then why do we use FETI ?????


domain decomposition preconditioners
parallel multigrid preconditioners


overlapping DD (Schwarz algorithm) [not really parallelised] // can be used as multiplicative preconditioner - use colouring
additive shwarz is parallelised and can be used with CG


https://en.m.wikipedia.org/wiki/Domain_decomposition_methods


Feti
Classical Schwarz Methods
Dirichlet-Neumann and Neumann-Neumann type
