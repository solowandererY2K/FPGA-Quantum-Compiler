FPGA Quantum Compiler
=====================

Here's my attempt at creating an FPGA quantum compiler.  Given a desired
gate as a matrix, it will send the matrix to an FPGA in fixed-point form and
compute an optimal sequence of quantum gates to approximate it.

This effort is based on the algorithm discussed [in this paper][paper] by
Austin Fowler, as well as his highly optimized source code.

For more information, visit [my personal Web site][mysite].

[paper]: http://arxiv.org/pdf/quant-ph/0411206.pdf
[mysite]: http://jeffbooth.info/quantum-compiler/
