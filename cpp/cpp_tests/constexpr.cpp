// constexpr can optimise the code knowing when it's dealing with scalars,
// vectors or matrices e.g. at compile time we know that the integration weights
// and det(J) are scalars while the gradient operator is a matrix (maybe the
// symmetry is exploited as well) at run time, memory allocation take place
// based on the user input
