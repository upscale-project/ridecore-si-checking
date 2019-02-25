# opcode = 7'b1111111 is a NOP
I: reset_done = False
I: reset_x = 0_1
I: opcode = 127_7

S1: reset_done = False
S1: reset_x = 0_1
S1: opcode = 127_7

S2: reset_done = False
S2: reset_x = 0_1
S2: opcode = 127_7

S3: reset_done = True
S3: reset_x = 1_1
S3: opcode = 127_7

S4: reset_done = True
S4: reset_x = 1_1
S4: inst_constraint0.ADDI = 1_1
S4: imm = 10_12
S4: rd = 8_5
S4: rs1 = 6_5

S5: reset_done = True
S5: reset_x = 1_1
S5: inst_constraint0.ADDI = 1_1
S5: imm = 10_12
S5: rd = 8_5
S5: rs1 = 6_5

S6: reset_done = True
S6: reset_x = 1_1
S6: inst_constraint0.ADDI = 1_1
S6: imm = 10_12
S6: rd = 8_5
S6: rs1 = 6_5
# S6: opcode = 127_7

# TRANS
I -> S1
S1 -> S2
S2 -> S3
S3 -> S4
S4 -> S5
S5 -> S6
S6 -> S6
