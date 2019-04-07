analyze -sv09 -f ./cosa/ridecore.vlist
# the switches below change the threshold for black boxing modules
# -bbox_mul 66 means don't blackbox multipliers unless the output value is greater than 66 (default is 1)
# -bbox_a 16384 means don't blackbox arrays unless there are more than 16,384 entries (default is 2048)
# Jasper will be much faster if you let it blackbox things, so if you don't need it, then don't include those flags
# elaborate -bbox_mul 66 -top top

# prevent dmem from being blackboxed
elaborate -bbox_a 4096 -top top

reset !reset_x;
clock -both_edges clk;

# name the instruction we're checking "instr"
set instr inst_constraint0.LW

# assume the data mem element at 5 is 5
# this is just for checking load word, remove otherwise
if {$instr == "inst_constraint0.LW"} {
    assume -bound 1 {datamemory.mem[0] == 4}
    assume -bound 1 {datamemory.mem[5] == 6}
}

# assume if we're not issuing the instruction we care about, it's a no-op
assume -name instr_or_nop " !$instr |-> inst_constraint0.NOP "

# not a very clean way to write it, but it works
# if we don't include the NOP explicitly, it can start issuing instruction again later
# perform a simulation -- cover means find a trace where these constraints hold (no property to violate)
cover -name load_word "
$instr && (inst_constraint0.rs1 == 0) && (inst_constraint0.rd != 0)
##1
$instr && (inst_constraint0.rs1 == 0) && (inst_constraint0.rd != 0)
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
##1
inst_constraint0.NOP
"