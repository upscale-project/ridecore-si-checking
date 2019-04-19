Load and Store Instruction Check

The memory address in the formula is shifted by 2 bit to fit memory address calculation in RIDECORE design.  

Control Instruction Check

To fit the RIDECORE design, my implementation avoids to make the offset be 4 for calculating jump address. Also, for checking JALR instruction, I set the least significant of offset to be 0 in the formula according to RIDECORE implementation. However, in RISC-V specification, the least significant of the resulting address should be 0. 

Multiplication Instruction Check

Currently, our multiplication check only works for verifying that the processor multiplies a number by 1 equals to itself and multiplies a number by 0 equals to 0. In my implementation, the assumption will put a 1 in either register 1 (rs1) or register 2 (rs2), so the multiplication is that 1 x rs1 = rd or 1 x rs2 = rd. The check formula is like the following: rs1 = rd or rs2 = rd. The assumption will put a 0 in either register 1 (rs1) or register 2 (rs2), so the multiplication is that 0 x rs1 = rd or 0 x rs2 = rd. The check formula in this case is rd = 0. 
