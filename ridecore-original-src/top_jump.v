// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "topsim.v"
`include "alloc_issue_ino.v"
`include "search_be.v"
`include "srcsel.v"
`include "alu_ops.vh"
`include "arf.v"
`include "ram_sync.v"
`include "ram_sync_nolatch.v"
`include "brimm_gen.v"
`include "constants.vh"
`include "decoder.v"
`include "dmem.v"
`include "exunit_alu.v"
`include "exunit_branch.v"
`include "exunit_ldst.v"
`include "exunit_mul.v"
`include "imem.v"
`include "imm_gen.v"
`include "pipeline_if.v"
`include "gshare.v"
`include "pipeline.v"
`include "oldest_finder.v"
`include "btb.v"
`include "prioenc.v"
`include "mpft.v"
`include "reorderbuf.v"
`include "rrf_freelistmanager.v"
`include "rrf.v"
`include "rs_alu.v"
`include "rs_branch.v"
`include "rs_ldst.v"
`include "rs_mul.v"
`include "rs_reqgen.v"
`include "rv32_opcodes.vh"
`include "src_manager.v"
`include "srcopr_manager.v"
`include "storebuf.v"
`include "tag_generator.v"
`include "dualport_ram.v"
`include "alu.v"
`include "multiplier.v"
`include "inst_constraint.sv"


module top_jump;

   reg [31:0] inst = 32'b0000000001000000000000111101111;
   reg clk, reset;
   top U_TOP(clk,reset,inst);

   initial begin
      clk = 0;
      reset = 0;
      $dumpfile("top_jump.vcd");
      $dumpvars(0, top_jump);
   end

   always
    #5 clk = !clk;

   initial begin
    reset = 1; #5
    reset = 0; inst = 32'b0000001101000000000000111101111; #25
    inst = 32'b0000000001000000000000100010011; #25
    inst = 32'b0000000001000000000000110010011; #90
    $finish;
    end
endmodule
