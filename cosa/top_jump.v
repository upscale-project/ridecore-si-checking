// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "topsim.v"
`include "alloc_issue_ino.v"
`include "search_be.v"
`include "srcsel.v"
`include "alu_ops.vh"
`include "arf.v"
`include "./ridecore-original-src/ram_sync.v"
`include "./ridecore-original-src/ram_sync_nolatch.v" 
`include "./ridecore-original-src/brimm_gen.v"
`include "./ridecore-original-src/constants.vh"
`include "./ridecore-original-src/decoder.v"
`include "./ridecore-original-src/dmem.v"
`include "./ridecore-original-src/exunit_alu.v"
`include "./ridecore-original-src/exunit_branch.v"
`include "./ridecore-original-src/exunit_ldst.v"
`include "./ridecore-original-src/exunit_mul.v"
`include "./ridecore-original-src/imem.v"
`include "./ridecore-original-src/imm_gen.v"
`include "./ridecore-original-src/pipeline_if.v"
`include "./ridecore-original-src/gshare.v"
`include "./ridecore-original-src/pipeline.v"
`include "./ridecore-original-src/oldest_finder.v"
`include "./ridecore-original-src/btb.v"
`include "./ridecore-original-src/prioenc.v"
`include "./ridecore-original-src/mpft.v"
`include "./ridecore-original-src/reorderbuf.v"
`include "./ridecore-original-src/rrf_freelistmanager.v"
`include "./ridecore-original-src/rrf.v"
`include "./ridecore-original-src/rs_alu.v"
`include "./ridecore-original-src/rs_branch.v"
`include "./ridecore-original-src/rs_ldst.v"
`include "./ridecore-original-src/rs_mul.v"
`include "./ridecore-original-src/rs_reqgen.v"
`include "./ridecore-original-src/rv32_opcodes.vh"
`include "./ridecore-original-src/src_manager.v"
`include "./ridecore-original-src/srcopr_manager.v"
`include "./ridecore-original-src/storebuf.v"
`include "./ridecore-original-src/tag_generator.v"
`include "./ridecore-original-src/dualport_ram.v"
`include "./ridecore-original-src/alu.v"
`include "./ridecore-original-src/multiplier.v"
`include "./inst_constraint.sv"


module example_3_1_tb;

   wire [31:0] inst = 32'b0000000001000000000000001101111;
   reg clk, reset;
   top U_TOP(clk,reset_x,inst);

   initial begin
      clk = 0;
      reset = 0;
      $dumpfile("top_jump.vcd");
      $dumpvars(0, top_jump);

      $finish;

   end
   
   always begin
   #5 clk = ~clk;
   end

endmodule
