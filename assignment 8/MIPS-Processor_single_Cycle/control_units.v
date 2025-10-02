module controller(
    input clk,
    input reset,
    input [5:0] OpCode,

    output RegDst,
    output Jump,
    output Branch,
    output MemRead,
    output MemToReg,
    output MemWrite,
    output ALUSrc,
    output RegWrite,
    output Link,
    output PC_en,
    output JR,
    output [1:0] ALUOp
);
    // Instruction type detection
    wire is_r;
    wire is_lw;
    wire is_sw;
    wire is_beq;
    wire is_jump;
    wire is_jal;
    wire is_jr;
    wire is_addi;

    // One-hot encoding for opcodes
    assign is_r     = (OpCode == 6'b000000);
    assign is_lw    = (OpCode == 6'b100011);
    assign is_sw    = (OpCode == 6'b101011);
    assign is_beq   = (OpCode == 6'b000100);
    assign is_jump  = (OpCode == 6'b000010);
    assign is_jal   = (OpCode == 6'b000011);
    assign is_jr    = (OpCode == 6'b000101);  // Assuming 000101 is used for JR
    assign is_addi  = (OpCode == 6'b001000);

    // Control signal mapping (13 bits)
    assign {RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch,
            ALUOp[1:0], Jump, Link, JR, PC_en} =

        is_r     ? 13'b100_1000_10_0001 : // R-type
        is_lw    ? 13'b011_1100_00_0001 : // LW
        is_sw    ? 13'b010_0010_00_0001 : // SW
        is_beq   ? 13'b000_0001_01_0001 : // BEQ
        is_jump  ? 13'b000_0000_00_1001 : // JUMP
        is_jal   ? 13'b000_1000_00_1101 : // JAL
        is_addi  ? 13'b010_1000_00_0001 : // ADDI
        is_jr    ? 13'b000_0000_00_0011 : // JR
                   13'b000_0000_11_0000 ; // default (NOP)

endmodule

module alu_control(
    //from dp
    input [5:0] funct,
    //from mips controller
    input [1:0] ALUOp,
    //to ALU ( going via your dp)
    output [3:0] ALU_opcode
);
    wire is_add;
    wire is_sub;
    wire is_and;
    wire is_or;
    wire is_slt;
    //one hot signals
    assign is_add = ((ALUOp==2'b00) || ((ALUOp==2'b10) && (funct==6'b100000))); 
	assign is_sub = ((ALUOp==2'b01) || ((ALUOp==2'b10) && (funct==6'b100010))); 
	assign is_and = ((ALUOp==2'b10) && (funct==6'b100100));
	assign is_or  = ((ALUOp==2'b10) && (funct==6'b100101));
	assign is_slt = ((ALUOp==2'b10) && (funct==6'b101010));

    assign ALU_opcode = is_add ? 4'b0010 : //add
                 is_sub ? 4'b0110 : //sub
                 is_and ? 4'b0000 : //and
                 is_or  ? 4'b0001 : //or
                 is_slt ? 4'b0111 : //slt
                 4'b1111; //default, no operation

endmodule