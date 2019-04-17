// constraints for ridecore risc-v instructions

module inst_constraint(clk,
                       instruction);

   input        clk;
   input [31:0] instruction;


   wire [4:0] rd;
   wire [4:0]  rs1;
   wire [4:0]  rs2;
   wire [6:0]  opcode;
   wire [11:0] simm12;  // signed imm for I type or instructions using rd, rs1 only like LW
   wire [2:0] funct3;
   wire [6:0] funct7;
   wire [4:0] imm5;  // lower order imm bits for S type instruction
   wire [6:0] simm7; // higher order bits (including sign bits) of imm operand for S type instruction
   wire [4:0] shamt; // shift amount for immediate shift operations

   // R format alu instructions
   (* keep *)
   wire       ADD;
   (* keep *)
   wire       SUB;
   (* keep *)
   wire       SLL;
   (* keep *)
   wire       SLT;
   (* keep *)
   wire       SLTU;
   (* keep *)
   wire       XOR;
   (* keep *)
   wire       SRL;
   (* keep *)
   wire       SRA;
   (* keep *)
   wire       OR;
   (* keep *)
   wire       AND;
   (* keep *)
   wire       MUL;
   (* keep *)
   wire       MULH;
   (* keep *)
   wire       MULHSU;
   (* keep *)
   wire       MULHU;


   // I format alu instructions
   (* keep *)
   wire       ADDI;
   (* keep *)
   wire       SLTI;
   (* keep *)
   wire       SLTIU;
   (* keep *)
   wire       XORI;
   (* keep *)
   wire       ORI;
   (* keep *)
   wire       ANDI;
   (* keep *)
   wire       SLLI;
   (* keep *)
   wire       SRLI;
   (* keep *)
   wire       SRAI;

   // mem ops
   (* keep *)
   wire       LW;
   (* keep *)
   wire       SW;

   assign opcode = instruction[6:0];
   assign rd = instruction[11:7];
   assign rs1 = instruction[19:15];
   assign rs2 = instruction[24:20];
   assign simm12 = instruction[31:20];
   assign simm7 = instruction[31:25];
   assign imm5 = instruction[11:7];
   assign shamt = instruction[24:20];
   assign funct3 = instruction[14:12];
   assign funct7 = instruction[31:25];

   wire         FORMAT_R;

// Do not constrain the registers to be only from the lower half of
// the register file. This is needed for QED but not for
// single-instruction checking.
//   assign FORMAT_R = ( (rd < 16) && (rs1 < 16) && (rs2 < 16));
   assign FORMAT_R = (1);
   
   assign ADD = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b000));
   assign SUB = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0100000) && (funct3 == 3'b000));
   assign SLL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b001));
   assign SLT = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b010));
   assign SLTU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b011));
   assign XOR = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b100));
   assign SRL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b101));
   assign SRA = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0100000) && (funct3 == 3'b101));
   assign OR = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b110));
   assign AND = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000000) && (funct3 == 3'b111));

   assign MUL = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b000));
   assign MULH = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b001));
   assign MULHSU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b010));
   assign MULHU = (FORMAT_R && (opcode == 7'b0110011) && (funct7 == 7'b0000001) && (funct3 == 3'b011));

   wire 	allowed_alu_R;
   assign allowed_alu_R = (ADD || SUB || SLL || SLT || SLTU || XOR || SRL || SRA || OR || AND || MUL || MULH || MULHSU || MULHU);

   wire         FORMAT_I;

// Do not constrain the registers to be only from the lower half of
// the register file. This is needed for QED but not for
// single-instruction checking.
//   assign FORMAT_I = ( (rd < 16) && (rs1 < 16) );
   assign FORMAT_I = (1);
   
   assign ADDI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b000));
   assign SLTI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b010));
   assign SLTIU = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b011));
   assign XORI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b100));
   assign ORI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b110));
   assign ANDI = (FORMAT_I && (opcode == 7'b0010011) && (funct3 == 3'b111));
   assign SLLI = (FORMAT_I && (opcode == 7'b0010011) && (funct7 == 7'b0000000) && (funct3 == 3'b001));
   assign SRLI = (FORMAT_I && (opcode == 7'b0010011) && (funct7 == 7'b0000000) && (funct3 == 3'b101));
   assign SRAI = (FORMAT_I && (opcode == 7'b0010011) && (funct7 == 7'b0100000) && (funct3 == 3'b101));

   wire 	allowed_alu_I;
   assign allowed_alu_I = (ADDI || SLTI || SLTIU || XORI || ORI || ANDI || SLLI || SRLI || SRAI);

// Do not constrain the registers in LW, SW. This is needed for QED but not for
// single-instruction checking.
//
// lw and sw constraints => to allow for finite memory instantiated in dmem by ridecore
//   assign LW = ((rs1 == 5'b00000) && (rd < 16) && (opcode == 7'b0000011) && (funct3 == 3'b010) && (instruction[31:30] == 2'b00));
//   assign SW = ((rs1 == 5'b00000) && (rs2 < 16) && (opcode == 7'b0100011) && (funct3 == 3'b010) && (instruction[31:30] == 2'b00));

   assign LW = ( (opcode == 7'b0000011) && (funct3 == 3'b010) );
   assign SW = ( (opcode == 7'b0100011) && (funct3 == 3'b010) );

   
   wire 	allowed_mem;
   assign allowed_mem = (LW || SW);

   (* keep *)
   wire       JAL;
   (* keep *)
   wire       JALR;
   (* keep *)
   wire       BEQ;
   (* keep *)
   wire       BNE;
   (* keep *)
   wire       BLT;
   (* keep *)
   wire       BLTU;
   (* keep *)
   wire       BGE;
   (* keep *)
   wire       BGEU;

   assign JAL = (opcode == 7'b1101111);
   assign JALR = (FORMAT_I && (opcode == 7'b1100111) && (funct3 == 3'b000));

   assign BEQ = ((opcode == 7'b1100011) && (funct3 == 3'b000));
   assign BNE = ((opcode == 7'b1100011) && (funct3 == 3'b001));
   assign BLT = ((opcode == 7'b1100011) && (funct3 == 3'b100));
   assign BGE = ((opcode == 7'b1100011) && (funct3 == 3'b101));
   assign BLTU = ((opcode == 7'b1100011) && (funct3 == 3'b110));
   assign BGEU = ((opcode == 7'b1100011) && (funct3 == 3'b111));

   wire allowed_J;
   assign allowed_J = (JAL || JALR);

   wire allowed_B;
   assign allowed_B = (BEQ || BNE || BLT || BLTU || BGE || BGEU);

   (* keep *)
   wire       LUI;
   (* keep *)
   wire       AUIPC;

   wire allowed_U;
   assign LUI = (opcode == 7'b0110111);
   assign AUIPC = (opcode == 7'b0010111);
   assign allowed_U = (LUI || AUIPC);

   // NOP to stall the fetch stage (stalling is done by making valid_instruction 0)
   wire 	NOP;
   assign NOP = (opcode == 7'b1111111);

   always @(posedge clk) begin
      assume property (allowed_alu_I | allowed_alu_R | allowed_mem | allowed_B | allowed_J | allowed_U | NOP);
   end

endmodule // inst_constraint
