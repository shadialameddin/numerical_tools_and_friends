Take snapshoot each x steps
randomised svd orthogonalisation
Timer view #114

Uftrace
Taskflow parallel
Git worktree Checkout all branches
Trello manage tasks

mandel
Boost testing
Redmine issue tracker


<https://blog.jupyter.org/interactive-workflows-for-c-with-jupyter-fe9b54227d92>

<https://hub.mybinder.org/user/quantstack-xtensor-od37uyvk/notebooks/notebooks/xtensor.ipynb>

<https://github.com/QuantStack/xtensor>

A modern formatting library <http://fmtlib.net>
<https://github.com/gabime/spdlog>

clang-tidy

Clang-Include-Fixer

cmake-format
pip install --user cmake_format

cpp-checks
sudo dnf install cppcheck
<https://github.com/danmar/cppcheck>

clang sanitizers
\-fsanitize=address: AddressSanitizer, a memory error detector.
\-fsanitize=thread: ThreadSanitizer, a data race detector.
\-fsanitize=memory: MemorySanitizer, a detector of uninitialized reads. Requires instrumentation of all program code.
\-fsanitize=undefined: UndefinedBehaviorSanitizer, a fast and compatible undefined behavior checker.
\-fsanitize=dataflow: DataFlowSanitizer, a general data flow analysis.
\-fsanitize=cfi: control flow integrity checks. Requires -flto.
\-fsanitize=safe-stack: safe stack protection against stack-based memory corruption errors.
The -fsanitize= argument must also be provided when linking, in order to link to the appropriate runtime library.
It is not possible to combine more than one of the -fsanitize=address, -fsanitize=thread, and -fsanitize=memory checkers in the same program.

lib fuzzer / american fuzzy loop
valgrind/ kcachegrind/ callgrind

map: memory access pattern

rule of 0 or 5
constructor
destructor
copy constructor
move constructor
copy assignment
move assignment
