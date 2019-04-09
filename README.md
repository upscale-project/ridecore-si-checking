# Single instruction checking for RIDECORE

This repository contains properties for single instruction checking of
the RIDECORE implementation, a RISC-V processor core, using our model checker
[CoSA](https://github.com/cristian-mattarei/CoSA). Single instruction
checking is complementary to symbolic quick error detection (SQED).

Related demo showing how SQED is applied to RIDECORE:
[https://github.com/makaimann/ride-core-demo](https://github.com/makaimann/ride-core-demo)

# Running single instruction checks

The call 

`CoSA --problems cosa/single.txt`

runs checks for properties related to all instructions of the
RIDECORE ISA that are currently supported.

List of files:

* `./cosa/single.txt`: CoSA problem file with single instruction properties.

* `./inst_constraint.sv`: opcode constraints for RIDECORE ISA.

* `./cosa/init.ssts`: state counter.

* `./cosa/reset_procedure.ets`: setting reset signal.

* `./cosa/state_copy.ssts`: copying operands of instruction.

* `./cosa/nop_m.ssts`: holding instruction at a NOP at certain state.

* `./testing-workflow/run-si-tests.sh`: automated testing workflow (see below).

# Automated testing of single instruction checking

We implemented an automated approach to test the correctness of our
implementation of single instruction checking. This workflow is based
on injecting predefined single instruction bugs into the RIDECORE
Verilog sources. See the related [README](testing-workflow/README.md)
for further information.

# License
This project has a composite license, because there are multiple components each with their own license. Please view the license files in the sub-directories. For convenience, they have been linked here: 
* Problem files for use with model checker CoSA -- cosa: [BSD LICENSE](./cosa/LICENSE)
* RIDECORE source files -- ridecore-original-src: [Tokyo Institute of Technology and Regents of the University of California LICENSE](./ridecore-original-src/LICENSE)

