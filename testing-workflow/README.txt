This directory contains the shell script 'run-si-tests.sh'. It runs a
set of tests to test the correctness of single instruction
checking. To this end, predefined bugs are injected into the original
Ridecore source via patch files. CoSA is called on the modified
Verilog model and is expected to find a counterexample. If CoSA proves
the property of a single instruction check correct, then this
corresponds to a failure.

NOTE: the script must be called from the base directory of the
repository. It writes temporary files to directory "./cosa/" and tries
to properly remove them in the end.

Example call from base directory of repository:

./testing-workflow/run-si-tests.sh ./cosa/single.txt ./testing-workflow/bug-injection-patches/ ./ridecore-original-src/
