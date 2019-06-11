# Single instruction checking for RIDECORE

This repository contains properties for single instruction checking of
the latest RIDECORE implementation, a RISC-V processor core, using our model checker
[CoSA](https://github.com/cristian-mattarei/CoSA). The purpose of this single instruction checking module is for checking whether the single instruction operates based on risc-v specification. This module also includes an automated testing workflow to help prove the correctness of this single instruction checking module and to provide an example of finding a processor bug with this module. 
Single instruction checking is complementary to symbolic quick error detection (SQED).

Related demo showing how SQED is applied to RIDECORE:
[https://github.com/makaimann/ride-core-demo](https://github.com/makaimann/ride-core-demo)

# List of CoSA files for the module:

* `./cosa/single_property_INSTRUCTION FOR CHECKING.txt`: CoSA problem file with a single instruction property.

* `./inst_constraint.sv`: opcode constraints for RIDECORE ISA.

* `./cosa/ridecore.vlist`:a file list to include verilog/system verilog source files of RIDECORE. 

* `./cosa/init.ssts`: setting the initial state of the processor. For RIDECORE, we set a static initial state rather than having a reset procedure. 

* `./cosa/state_counter.ssts`: implementing a state counter.

* `./cosa/state_copy.ssts`: copying necessary operands of the instruction.

* `./cosa/nop_m.ssts`: holding instruction at a NOP at certain state.

# RTL modification:

* `./ridecore-original-src/top.v`: top module for driving the microprocessor \
We added some registers to capture different parts from the instruction and `(* keep *)` for wires we don’t want yosys to clean up in the verification. This module also instantiates `inst_constraint` and constrains the input instruction to be a valid RISC-V instruction. 

* In pipeline_if.v: Disable branch prediction (negative clock behavior) to speed up the verification

# Setup:
CoSA installation 

# Running single instruction checks

The call 

`CoSA --problems cosa/single_property_INSTRUCTION FOR CHECKING.txt`

`ex: CoSA --problems cosa/single_property_ADD.txt`

runs checks for a single property of the RIDECORE ISA that are currently supported.

This module includes the following instruction check: 

Integer Register-Immediate Instructions:
`ADDI ANDI ORI SLLI SLTIU SLTI SRAI SRLI XORI`

Integer Register-Register Instructions:
`ADD AND OR SLL SLT SRA SRL SUB XOR`

Load and Store instructions: 
`SW and LW`

Control Transfer Instructions:
`BEQ BGE BGEU BLT BLTU BNE JAL JALR LUI AUIPC`

Test the value in x0: To test that the value in register 0 is always connected to 0. 
`LOADx0`

Note: This module doesn’t include memory model instructions and control and status register instructions. 

# Automated testing of single instruction checking

`./testing-workflow/run-si-tests.sh`

We implemented an automated approach to test the correctness of our
implementation of single instruction checking. This workflow is based
on injecting predefined single instruction bugs into the RIDECORE
Verilog sources. See the related [README](testing-workflow/README.md)
for further information.

# License
This project has a composite license, because there are multiple components each with their own license. Please view the license files in the sub-directories. For convenience, they have been linked here: 
* Problem files for use with model checker CoSA -- cosa: [BSD LICENSE](./cosa/LICENSE)
* RIDECORE source files -- ridecore-original-src: [Tokyo Institute of Technology and Regents of the University of California LICENSE](./ridecore-original-src/LICENSE)

