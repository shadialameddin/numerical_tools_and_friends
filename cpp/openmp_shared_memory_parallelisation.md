# OpenMP (shared memory parallelisation)
Heap: shared
Stack: private to each thread

    export OMP_NUM_THREADS=4
    getconf LEVEL1_DCACHE_LINESIZE
    g++ -fopenmp openmp_test.cpp && ./a.out 

#include<omp.h>
omp_set_num_threads(10);
omp_get_num_threads();
omp_get_thread_num(); omp_get_max_threads()
#pragma omp parallel // forks number of threads
omp_get_thread_num(); // might not get all the threads you asked the system for
double omp_get_wtime();
omp_in_parallel(); // Are we in an active parallel region? 
omp_set_dynamic(); omp_get_dynamic(); 
omp_num_procs(); // How many processors in the system?

## SPMD (single program, multiple data)
- Pading (in order to overcome false sharing)
- High level synchronization
  - critical // mutual exclusion
  - atomic // mutual exclusion
  - barrier
    - omp parallel for **nowait** // no implicit barrier at the end of the for loop
  - ordered
- Low level synchronization 
  - flush 
  - locks (both simple and nested)
## Worksharing
- Loop construct
  - #pragma omp parallel for reduction(+ : area) // supports + - * min max && || 
  - #pragma omp parallel for collapse(2) // for nested loops
  - The schedule clause:
    - schedule(static [,chunk]) // Least work at runtime. Deal-out  blocks  of  iterations  of  size  “chunk”  to  each  thread. // #pragma schedule(static, 1)
    - schedule(dynamic[,chunk]) // Most work at runtime. Each  thread  grabs  “chunk”  iterations  off  a  queue  until  all  iterations have been handled.
    - schedule(guided[,chunk]) – Threads dynamically grab blocks of iterations. The size of the block starts  large  and  shrinks  down  to  size  “chunk”  as  the  calculation proceeds.
    - schedule(runtime) – Schedule and chunk size taken from the OMP_SCHEDULE environment variable (or the runtime library).
    - schedule(auto) – Schedule is left up to the runtime to choose (does not have to be any of the above).
- Sections/section constructs 
- Single construct
- Task construct


#pragma omp master // no implicit barrier
#pragma omp single // implicit barrier
#pragma omp sections // each thread run a section, e.g. sth for x, sth for y, …z

  #pragma omp section // no implicit barrier


## Locks
- omp_init_lock() //init set unset destroy test
    omp_init_lock(&hist_locks[i]);
    omp_set_lock(&hist_locks[ival]);
    omp_unset_lock(&hist_locks[ival]);
    omp_destroy_lock(&hist_locks[i]);


## Environment Variables
    OMP_NUM_THREADS int_literal
    OMP_STACKSIZE
    OMP_WAIT_POLICY
    – ACTIVE keep threads alive at barriers/locks
    – PASSIVE try to release processor at barriers/locks
    OMP_PROC_BIND true | false
    – Process  binding  is  enabled  if  this  variable  is  true  ...  i.e.  if  true  
    the runtime will not move threads around between processors.


## Data sharing
- Shared
- Private
- firstprivate
- lastprivate
- default(none)


To create a team of threads
#pragma omp parallel
To share work between threads:
#pragma omp for
#pragma omp single
To prevent conflicts (prevent races)
#pragma omp critical
#pragma omp atomic // #pragma omp atomic [read | write | update | capture]
#pragma omp barrier
#pragma omp master
Data environment clauses
private (variable_list)
firstprivate (variable_list)
lastprivate (variable_list)
reduction(+:variable_list)



## Tasks // good with while loops

#pragma omp task
#pragma omp taskwait



Memory model

weak consistency:
Can not reorder S ops with R or W ops on the same
thread
– Weak consistency guarantees
S→W,      S→R  ,  R→S,  W→S,  S→S
The Synchronization operation relevant to this
discussion is flush.

flush(A); // flush to DRAM

A flush operation is implied by OpenMP
synchronizations, e.g.
at entry/exit of parallel regions
at implicit and explicit barriers
at entry/exit of critical regions
whenever a lock is set or unset
....
(but not at entry to worksharing regions or entry/exit
of master regions)

Note: the flush operation does not actually synchronize different
threads. It just ensures that a thread’s values are made
consistent with main memory.


Pair wise synchronisation // – One thread produces values that another thread consumes.

#pragma omp flush(flag)
#pragma omp flush


Spin lock

    while (flag == 0) {
    #pragma omp atomic read
    #pragma omp flush(flag)
    }
    #pragma omp atomic [read | write | update | capture]


Data sharing: Threadprivate // initialised by each thread - usefull not to allocate too much memory

#pragma omp threadprivate(counter)                      vs private?
#copyprivate(counter)


leap-frog algorithm or method
non-overlapping random number generator




std::threads

#include 
#pragma omp parallel for

- for (auto element = 0; element < elements(); ++element)
- {
- tbb::parallel_for(std::size_t{0}, elements(), [&](#) {
- tbb::parallel_for(std::size_t{0}, strains.size(), [&](#) {

+#define EIGEN_SPARSEMATRIX_PLUGIN "numeric/thread_safe_plugin.hpp"
+/** Add a scalar to the value of the matrix at position \a i, \a j in a thread safe fashion.

- *
- * It is assumed that the element exists, otherwise an exception std::domain_error is thrown.
- *
- * This is a O(log(nnz_j)) operation (binary search) with the lock placed around the update
- * of the coefficient matrix
- */
- +void coefficient_update(Index const row, Index const col, Scalar const value)
- +{
- eigen_assert(row >= 0 && row < rows() && col >= 0 && col < cols());
- +
- Index const outer = IsRowMajor ? row : col;
- Index const inner = IsRowMajor ? col : row;
- +
- Index const start = m_outerIndex[outer];
- Index const end = m_outerIndex[outer + 1];
- +
- eigen_assert(end >= start && "you probably called coefficient_update on a non finalized matrix");
- +
- Index const p = m_data.searchLowerIndex(start, end - 1, StorageIndex(inner));
- +
- +// std::lock_guard lock(coefficent_update_mutex);
- +#pragma omp atomic
- m_data.value(p) += value;
- // }
- +}

