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

S3: reset_done = False
S3: reset_x = 0_1
S3: opcode = 127_7

S4: reset_done = False
S4: reset_x = 0_1
S4: opcode = 127_7

S5: reset_done = False
S5: reset_x = 0_1
S5: opcode = 127_7

S6: reset_done = False
S6: reset_x = 0_1
# don't hold the opcode to NOP here because
# instruction is assumed to be stable and
# we want to start it at S7

S7: reset_done = True
S7: reset_x = 1_1


S8: reset_done = True
S8: reset_x = 1_1

# TRANS
I -> S1
S1 -> S2
S2 -> S3
S3 -> S4
S4 -> S5
S5 -> S6
S6 -> S7
S7 -> S7
