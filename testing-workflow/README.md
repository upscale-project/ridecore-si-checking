
### Automated Testing Workflow ###

This directory contains the shell script `run-si-tests.sh`. This
script implements an automated workflow to test the correctness of our
implementation of single instruction checking.

To this end, predefined bugs are injected into the original Ridecore
Verilog sources via patch files. These bugs change the semantics of
single instructions. Our implemented single instruction checks are
expected to catch these injected bugs. CoSA is called on the Verilog
model that has been modified by bug injection and is expected to find
a counterexample. If CoSA unexpectedly proves the property of one of
our single instruction checks correct, then this corresponds to a
failure.

#### Usage ####

Please see the comments in the `run-si-tests.sh` for additional
information.

The script must be called from the base directory of the
repository. It writes temporary files to directory "./cosa/" and tries
to properly remove them in the end.

Example call from the base directory of repository:

`./testing-workflow/run-si-tests.sh ./cosa/ ./testing-workflow/bug-injection-patches/ ./ridecore-original-src/`

**Important Note:** the script `run-si-tests.sh` should only be run if
there are no uncommitted changes in the current repository. The
script uses `git reset` to revert any modifications of the original
Ridecore Verilog sources done by bug injection. It will abort if the
current repository has any uncommitted changes at the beginning of
the workflow, however, please double check before running the
script.

The script will abort `run-si-tests.sh` if a test fails.

#### Patch files ####

Directory `./bug-injection-patches` contains the patch used to inject
bugs in the original Verilog sources of Ridecore. These file are
generated from the original Verilog source file and a modified one
using the Linux tool `diff -c`.

For example, the patch file
[`bug-injection-patches/alu-bug-injected_0_ADDI.patch`](https://github.com/upscale-project/ridecore-si-checking/blob/testing-workflow/testing-workflow/bug-injection-patches/alu-bug-injected_0_ADDI.patch)
is used to introduce an ALU bug related to the ADDI instruction.

Bug are injected using the Linux tool `patch`. Changes are reverted
using `git reset`.

The names of patch files must contain the name of the operator as
listed in the `../cosa/single_property_*.txt` files. The exact naming scheme of
the patch files is `*_OPNAME.patch` where `OPNAME` is the name of the
operator as listed in the files `../cosa/single_property_*.txt`.

The script `run-si-tests.sh` runs tests for all patch files found in
directory `./bug-injection-patches`.