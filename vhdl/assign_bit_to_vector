For loops are sequential statments that contain other sequential
statements and specify the repetitive execution of the interior
sequential statements.

For generates are concurrent statments that contain other concurrent
statements and specify the repetitive elaboration of the interior
concurrent statements.

If you're writing sequential code (processes or subprograms) then you
use a for loop.

If you're writing concurrent code (anywhere else) then you use a for
generate.

RST:
    for I in 0 to (CORES-1) generate
          rst_out(I) <= rst_in;
    end generate;
