`timescale 1ns / 1ps

module signel_cycle_mips(
  input reset,         // Reset signal to initialize the processor
  input clk            // Clock signal to synchronize operations
);

  wire [5:0] OpCode, funct;     // Fields from instruction: OpCode and function code
  wire [3:0] ALU_opcode;        // ALU operation code determined by ALU control unit
  wire [1:0] ALUOp;             // ALU operation type determined by main control unit
  wire RegDst;                  // Register destination selector for register write
  wire Jump;                    // Jump control signal
  wire Branch;                  // Branch control signal
  wire MemRead;                 // Memory read enable
  wire MemToReg;                // Select signal for register write data source
  wire MemWrite;                // Memory write enable
  wire ALUSrc;                  // ALU source selector (register or immediate)
  wire RegWrite;                // Register file write enable
  wire Link;                    // Link control signal for JAL instruction
  wire JR;                      // Jump Register control signal
  wire PC_en;                   // Program Counter enable signal

  DATAPATH_MIPS datapath (
    .clk(clk),                  // Clock signal
    .reset(reset),              // Reset signal
    .RegDst(RegDst),            // Register destination signal
    .Jump(Jump),                // Jump signal
    .Branch(Branch),            // Branch signal
    .MemRead(MemRead),          // Memory read enable
    .MemToReg(MemToReg),        // Memory to register signal
    .MemWrite(MemWrite),        // Memory write enable
    .ALUSrc(ALUSrc),            // ALU source signal
    .RegWrite(RegWrite),        // Register write enable
    .Link(Link),                // Link signal
    .JR(JR),                    // Jump Register signal
    .PC_en(PC_en),              // Program Counter enable
    .ALU_opcode(ALU_opcode),    // ALU opcode signal
    .OpCode(OpCode),            // OpCode from instruction
    .funct(funct)               // funct field from instruction
  );

  CONTROLLER_MIPS ctrl (
    .clk(clk),                  // Clock signal
    .reset(reset),              // Reset signal
    .OpCode(OpCode),            // OpCode from instruction
    .RegDst(RegDst),            // Register destination control
    .Jump(Jump),                // Jump control
    .Branch(Branch),            // Branch control
    .MemRead(MemRead),          // Memory read enable
    .MemToReg(MemToReg),        // Memory to register control
    .MemWrite(MemWrite),        // Memory write enable
    .ALUSrc(ALUSrc),            // ALU source control
    .RegWrite(RegWrite),        // Register write enable
    .Link(Link),                // Link control
    .PC_en(PC_en),              // Program Counter enable
    .JR(JR),                    // Jump Register control
    .ALUOp(ALUOp)               // ALU operation type
  );

  ALU_CONTROL_MIPS alu_ctrl (
    .funct(funct),              // funct field from instruction (R-type)
    .ALUOp(ALUOp),              // ALU operation type from controller
    .ALU_opcode(ALU_opcode)     // Specific ALU opcode generated
  );

endmodule


module tb_signel_cycle_mips();
  reg clk;
  reg reset;
  signel_cycle_mips uut (.reset(reset), .clk(clk));
  always #5 clk = ~clk;

  // Clock and Reset Initialization
  initial begin
    clk = 0;
    reset = 1;
    $display("=== Simulation Started ===");

    // Display initial memory state
    $display("\n--- Initial Data Memory Contents ---");
    for (integer j = 0; j < 16; j = j + 1) begin
      $display("Mem[%2d] = %0d", j, uut.datapath.Data_Memory.memory[j]);
    end

    #20 reset = 0;

    $display("\nTime(ns) | Operation  | Address/Reg | Value");
    $display("---------------------------------------------");

    // Monitor Reg and Mem writes
    forever begin
      @(posedge clk) begin
        if (uut.RegWrite) begin
          $display("%8t | REG WRITE | R%-2d         | %0d", 
                   $time, uut.datapath.write_reg_final, 
                   uut.datapath.write_data);
        end

        if (uut.MemWrite) begin
          $display("%8t | MEM WRITE | Addr %0d     | %0d", 
                   $time, uut.datapath.ALU_result, 
                   uut.datapath.reg_read_data2);
        end
      end
    end
  end

  // Simulation End
  initial begin
    #920;
    $display("\n=== Final State ===");

    $display("\n--- Register File Contents (Non-zero only) ---");
    // for (integer i = 0; i < 32; i = i + 1) begin
    //   if (uut.datapath.Registers.regs[i].r.q !== 0) begin
    //     $display("R%-2d = %0d", i, uut.datapath.Registers.regs[i].r.q);
    //   end
    // end

    $display("\n--- Final Data Memory Contents ---");
    for (integer j = 0; j < 16; j = j + 1) begin
      $display("Mem[%2d] = %0d", j, uut.datapath.Data_Memory.memory[j]);
    end

    $display("\n=== Simulation Completed ===");
    $finish;
  end
endmodule


module data_mem #(parameter L = 256)(clk,address,read_data, write_data, read_en, write_en);
  
  // Synchronous memory module with 256 32-bit locations

  parameter S=32; // Width of each memory word is 32 bits

  // Input/Output declarations
  input [$clog2(L) - 1:0] address;   // Memory address (log2(L) bits wide)
  input [S-1:0] write_data;          // Data to be written to memory
  input clk;                         // Clock signal
  input write_en;                    // Write enable signal
  input read_en;                     // Read enable signal
  output [(S-1):0] read_data;        // Data read from memory

  // Memory array of size L, each entry S bits wide
  reg [S-1:0] memory [L-1:0];

  // Continuous assignment to read data (word-aligned using address/4)
  assign read_data=memory[address/4];
    
  // Write operation: occurs on positive edge of clock when write_en is high
  always @(posedge clk) begin
    if (write_en==1) begin
        memory[address/4]<=write_data;
    end
  end

  // The current program doesn't require initializing memory from a file
  // initial $readmemh("memdata.dat", memory);

endmodule


module reg_file (
  input         clk,
  input         reset,
  input         write_en,
  input  [4:0]  read_reg1,
  input  [4:0]  read_reg2,
  input  [4:0]  write_reg,
  input  [31:0] write_data,
  output [31:0] read_data1,
  output [31:0] read_data2
);
  // Internal wires renamed for uniqueness and clarity
  wire [31:0]        write_enable_decoded_bus; 
  wire [1023:0]      all_registers_concatenated_bus; // 32×32-bit wide

  // One-hot decoder for write register
  decoder5to32 dec (
    .in  (write_reg),
    .en  (write_en),
    .out (write_enable_decoded_bus)
  );

  // 32× register32 instances, each hooked to a 32‑bit slice
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : regs
      register32 r (
        .clk     (clk),
        .reset   (reset),
        .write_en(write_enable_decoded_bus[i]),
        .d       (write_data),
        .q       (all_registers_concatenated_bus[i*32 +: 32])
      );
    end
  endgenerate

  // Two read ports using the flattened bus
  mux32_1 m1 (
    .in_flat(all_registers_concatenated_bus),
    .sel    (read_reg1),
    .out    (read_data1)
  );
  mux32_1 m2 (
    .in_flat(all_registers_concatenated_bus),
    .sel    (read_reg2),
    .out    (read_data2)
  );
endmodule


module PC (
  input clk,
  input reset,  // Active high reset
  input en,
  input [31:0] d,
  output reg [31:0] q
);
  
  // Internal wire for next state logic
  wire [31:0] next_q;
  
  // Next state logic with enable functionality
  assign next_q = en ? d : q;
  
  // D flip-flop implementation with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      q <= 32'b0;
    else
      q <= next_q;
  end
  
endmodule


//Datapath
module DATAPATH_MIPS(
  input clk,
  input reset,
  
  //From MIPS CONTROLLER_MIPS
  input RegDst,          //if its an R or I type instruction and shoul rd be read
  input Jump,           
  input Branch,        
  input MemRead,      
  input MemToReg,    
  input MemWrite,   
  input ALUSrc,    //whether alu's input is 2nd reg or immediate value
  input RegWrite, 
  input Link,    //For jal instruction
  input JR,     //For Jump to reg instruction
  input PC_en, //enable PC to read its input value
  
  //From ALU CONTROLLER_MIPS
  input [3:0] ALU_opcode, //4bits, as seen in a prev slide, ig 1 extra bit for binvert, pretty sure
  
  
  output wire [5:0] OpCode, //To CONTROLLER_MIPS
  output wire [5:0] funct  //To ALU_CONTROL_MIPSLER_MIPS and CONTROLLER_MIPS
);
  
  
  // Instruction Mem and Operand Decode
  wire [31:0] PC_out, instr_out;
  instr_mem Intruction_Memory(.read_address(PC_out), .instruction(instr_out));
  
  assign OpCode = instr_out[31:26];
  
  // Instruction fields
  wire [4:0] rs = instr_out[25:21];
  wire [4:0] rt = instr_out[20:16];
  wire [4:0] rd = instr_out[15:11];
  wire [15:0] immediate = instr_out[15:0];
  wire [25:0] jump_target = instr_out[25:0];
  assign funct = instr_out[5:0];
  
  //------------------------------------------------------------------------
  
  // PC
  wire [31:0] PC_plus4, PC_next;
  wire ALU_zero;
  
  PC Program_Counter(.clk(clk), .reset(reset), .en(PC_en), .d(PC_next), .q(PC_out));
  
  //PC+4
  adder PC_plus4_adder(.a(PC_out), .b(32'd4), .y(PC_plus4));
  
  // Jump address calc
  wire [28:0] jump_target_shifted;
  sll_2_pad #(.INP_WIDTH(26)) Shift_Jump_2(.in(jump_target), .out(jump_target_shifted));
  wire [31:0] jump_addr = {PC_plus4[31:28], jump_target_shifted};
  
  // Immediate address calc
  wire [31:0] sign_ext_imm;
  sign_extend Sign_Extender(.in(immediate), .out(sign_ext_imm));
  
  wire [31:0] shifted_imm;
  sll_2_same Shift_Imm_2(.in(sign_ext_imm), .out(shifted_imm));
  
  wire [31:0] branch_addr;
  adder Branch_Adder(.a(PC_plus4), .b(shifted_imm), .y(branch_addr));
  
  // Branch instr or PC+4
  wire branch_taken = Branch & ALU_zero;
  wire [31:0] PC_branch_mux_out;
  mux2to1 #(.WIDTH(32)) PC_branch_mux(
    .in0(PC_plus4),
    .in1(branch_addr),
    .sel(branch_taken),
    .out(PC_branch_mux_out)
  );
  
  // whether Jump instr
  wire [31:0] PC_jump_mux_out;
  mux2to1 #(.WIDTH(32)) PC_jump_mux(
    .in0(PC_branch_mux_out),
    .in1(jump_addr),
    .sel(Jump),
    .out(PC_jump_mux_out)
  );
  
  //JR instruction
  wire [31:0] reg_read_data1;
  mux2to1 #(.WIDTH(32)) PC_Jump_Reg(
    .in0(PC_jump_mux_out),
    .in1(reg_read_data1),
    .sel(JR),
    .out(PC_next)
  );
 
  //---------------------------------------------------------------------------------------
  
  // Registers
  wire [4:0] write_reg_intermediate, write_reg_final;
  wire [31:0] write_data;
  wire [31:0] reg_read_data2;
  
  // R-type or I-type instr
  mux2to1 #(.WIDTH(5)) write_reg_mux(
    .in0(rt), 
    .in1(rd), 
    .sel(RegDst), 
    .out(write_reg_intermediate)
  );
  // if Jump and Link
  mux2to1 #(.WIDTH(5)) link_reg_mux(
    .in0(write_reg_intermediate), 
    .in1(5'd31), // reg $ra
    .sel(Link), 
    .out(write_reg_final)
  );
  
  reg_file Registers(
    .clk(clk),
    .reset(reset),
    .write_en(RegWrite),
    .read_reg1(rs),
    .read_reg2(rt),
    .write_reg(write_reg_final),
    .write_data(write_data),
    .read_data1(reg_read_data1),
    .read_data2(reg_read_data2)
  );
  
  
  //ALU
  wire [31:0] ALU_in2;
  wire [31:0] ALU_result;
  
  //computing reg w/ immediate or reg w/ reg
  mux2to1 #(.WIDTH(32)) ALU_src_mux(
    .in0(reg_read_data2),
    .in1(sign_ext_imm),
    .sel(ALUSrc),
    .out(ALU_in2)
  );
  
  ALU Arithmetic_Logic_Unit(
    .a(reg_read_data1),
    .b(ALU_in2),
    .op(ALU_opcode),
    .result(ALU_result),
    .zero(ALU_zero)
  );
  
  // Data Mem and Write Back
  wire [31:0] mem_read_data;
  data_mem Data_Memory(
    .clk(clk),
    .write_en(MemWrite),
    .read_en(MemRead),
    .address(ALU_result),
    .write_data(reg_read_data2),
    .read_data(mem_read_data)
  );
  
  //load instr or addi instr
  wire [31:0] wb_data;
  mux2to1 #(.WIDTH(32)) wb_mux(
    .in0(ALU_result),
    .in1(mem_read_data),
    .sel(MemToReg),
    .out(wb_data)
  );
  
  //whether to write back PC+4 to $ra
  mux2to1 #(.WIDTH(32)) link_data_mux(
    .in0(wb_data),
    .in1(PC_plus4),
    .sel(Link),
    .out(write_data)
  );
  
endmodule


module CONTROLLER_MIPS(
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
    // Instruction type detection using renamed internal wires
    wire is_instruction_rtype;
    wire is_instruction_lw;
    wire is_instruction_sw;
    wire is_instruction_beq;
    wire is_instruction_jump;
    wire is_instruction_jal;
    wire is_instruction_jr;
    wire is_instruction_addi;

    // One-hot encoding for opcode types
    assign is_instruction_rtype = (OpCode == 6'b000000);
    assign is_instruction_lw    = (OpCode == 6'b100011);
    assign is_instruction_sw    = (OpCode == 6'b101011);
    assign is_instruction_beq   = (OpCode == 6'b000100);
    assign is_instruction_jump  = (OpCode == 6'b000010);
    assign is_instruction_jal   = (OpCode == 6'b000011);
    assign is_instruction_jr    = (OpCode == 6'b000101);  // Assuming 000101 is used for JR
    assign is_instruction_addi  = (OpCode == 6'b001000);

    // Control signal generation (13 bits)
    assign {RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch,
            ALUOp[1:0], Jump, Link, JR, PC_en} =

        is_instruction_rtype ? 13'b100_1000_10_0001 : // R-type
        is_instruction_lw    ? 13'b011_1100_00_0001 : // LW
        is_instruction_sw    ? 13'b010_0010_00_0001 : // SW
        is_instruction_beq   ? 13'b000_0001_01_0001 : // BEQ
        is_instruction_jump  ? 13'b000_0000_00_1001 : // JUMP
        is_instruction_jal   ? 13'b000_1000_00_1101 : // JAL
        is_instruction_addi  ? 13'b010_1000_00_0001 : // ADDI
        is_instruction_jr    ? 13'b000_0000_00_0011 : // JR
                               13'b000_0000_11_0000 ; // default (NOP)

endmodule

module ALU_CONTROL_MIPS(
  // from datapath
  input [5:0] funct,
  // from main controller
  input [1:0] ALUOp,
  // to ALU
  output [3:0] ALU_opcode
);
    // Internal wires renamed
    wire signal_is_add_operation;
    wire signal_is_sub_operation;
    wire signal_is_and_operation;
    wire signal_is_or_operation;
    wire signal_is_slt_operation;

    // One-hot detection logic for ALU control
    assign signal_is_add_operation = ((ALUOp == 2'b00) || ((ALUOp == 2'b10) && (funct == 6'b100000))); 
	assign signal_is_sub_operation = ((ALUOp == 2'b01) || ((ALUOp == 2'b10) && (funct == 6'b100010))); 
	assign signal_is_and_operation = ((ALUOp == 2'b10) && (funct == 6'b100100));
	assign signal_is_or_operation  = ((ALUOp == 2'b10) && (funct == 6'b100101));
	assign signal_is_slt_operation = ((ALUOp == 2'b10) && (funct == 6'b101010));

    // ALU opcode output selection
    assign ALU_opcode = signal_is_add_operation ? 4'b0010 : // add
                        signal_is_sub_operation ? 4'b0110 : // sub
                        signal_is_and_operation ? 4'b0000 : // and
                        signal_is_or_operation  ? 4'b0001 : // or
                        signal_is_slt_operation ? 4'b0111 : // slt
                                                  4'b1111;  // default: no operation

endmodule


module ALU (
  input [31:0] a,
  input [31:0] b,
  input [3:0] op,
  output [31:0] result,
  output zero
);
  // Internal wires for operation results with descriptive names
  wire [31:0] logic_and_output;
  wire [31:0] logic_or_output;
  wire [31:0] arithmetic_result;
  wire [31:0] set_less_than_result;
  wire [31:0] logic_nor_output;
  
  // Carry chain and b input for add/sub operations
  wire [32:0] adder_carry_chain;
  wire [31:0] modified_input_b;
  wire invert_b_signal;
  
  // Control signal for b input inversion
  assign invert_b_signal = op[2];  // High for subtraction (op = 0110)
  
  // Invert b input conditionally
  genvar bit_idx_for_invert;
  generate
    for (bit_idx_for_invert = 0; bit_idx_for_invert < 32; bit_idx_for_invert = bit_idx_for_invert + 1) begin: generate_b_inversion
      assign modified_input_b[bit_idx_for_invert] = b[bit_idx_for_invert] ^ invert_b_signal;
    end
  endgenerate
  
  // Initial carry for addition or subtraction
  assign adder_carry_chain[0] = invert_b_signal;
  
  // Basic bitwise logic operations
  genvar logic_bit_index;
  generate
    for (logic_bit_index = 0; logic_bit_index < 32; logic_bit_index = logic_bit_index + 1) begin: generate_logic_operations
      assign logic_and_output[logic_bit_index] = a[logic_bit_index] & b[logic_bit_index];
      assign logic_or_output[logic_bit_index] = a[logic_bit_index] | b[logic_bit_index];
      assign logic_nor_output[logic_bit_index] = ~(a[logic_bit_index] | b[logic_bit_index]);
    end
  endgenerate
  
  // Arithmetic operation with ripple carry logic
  genvar adder_bit_index;
  generate
    for (adder_bit_index = 0; adder_bit_index < 32; adder_bit_index = adder_bit_index + 1) begin: generate_add_sub_logic
      assign arithmetic_result[adder_bit_index] = a[adder_bit_index] ^ modified_input_b[adder_bit_index] ^ adder_carry_chain[adder_bit_index];
      assign adder_carry_chain[adder_bit_index + 1] =
        (a[adder_bit_index] & modified_input_b[adder_bit_index]) |
        (a[adder_bit_index] & adder_carry_chain[adder_bit_index]) |
        (modified_input_b[adder_bit_index] & adder_carry_chain[adder_bit_index]);
    end
  endgenerate
  
  // Set Less Than (SLT) from MSB of subtraction
  assign set_less_than_result = {31'b0, arithmetic_result[31]};
  
  // Select final ALU result using 5-to-1 multiplexer
  mux5to1 result_selection_mux (
    .in0(logic_and_output),
    .in1(logic_or_output),
    .in2(arithmetic_result),
    .in3(set_less_than_result),
    .in4(logic_nor_output),
    .sel(op),
    .out(result)
  );
  
  // Zero flag output
  assign zero = (result == 32'b0);

endmodule


module instr_mem #(parameter Addr_width = 8) (
  input  [$clog2(1 << Addr_width) - 1:0] read_address,  // Address input
  output [31:0] instruction                         // 32-bit instruction output
);

  // Parameters
  parameter DATA_WIDTH = 32;
  parameter DEPTH = (1 << Addr_width);  // Number of memory locations

  // Internal memory array: 256 locations of 32-bit instructions
  reg [DATA_WIDTH-1:0] instr_mem_array [0:DEPTH-1];

  // Asynchronous read (word-addressable, divide by 4)
  assign instruction = instr_mem_array[read_address >> 2];

  // Preload the instruction memory
  // initial begin
// Preload the instruction memory
initial begin
// === Initialization: Store 10 numbers ===
instr_mem_array[0]  = 32'h20080000; // addi $t0, $zero, 0      # Memory pointer
instr_mem_array[1]  = 32'h2009000A; // addi $t1, $zero, 10     # num1
instr_mem_array[2]  = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[3]  = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[4]  = 32'h20090019; // addi $t1, $zero, 25     # num2
instr_mem_array[5]  = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[6]  = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[7]  = 32'h20090007; // addi $t1, $zero, 7      # num3
instr_mem_array[8]  = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[9]  = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[10] = 32'h2009000F; // addi $t1, $zero, 15     # num4
instr_mem_array[11] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[12] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[13] = 32'h20090003; // addi $t1, $zero, 3      # num5
instr_mem_array[14] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[15] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[16] = 32'h20090016; // addi $t1, $zero, 22     # num6
instr_mem_array[17] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[18] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[19] = 32'h20090013; // addi $t1, $zero, 19     # num7
instr_mem_array[20] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[21] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[22] = 32'h2009001E; // addi $t1, $zero, 30     # num8
instr_mem_array[23] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[24] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[25] = 32'h20090005; // addi $t1, $zero, 5      # num9
instr_mem_array[26] = 32'hAD090000; // sw   $t1, 0($t0)
instr_mem_array[27] = 32'h21080004; // addi $t0, $t0, 4

instr_mem_array[28] = 32'h2009000D; // addi $t1, $zero, 13     # num10
instr_mem_array[29] = 32'hAD090000; // sw   $t1, 0($t0)

// === Find Minimum ===
instr_mem_array[30] = 32'h20080000; // addi $t0, $zero, 0      # mem pointer = 0
instr_mem_array[31] = 32'h8D090000; // lw   $t1, 0($t0)        # $t1 = mem[0]
instr_mem_array[32] = 32'h01205020; // add  $t2, $t1, $zero    # min = $t2 = $t1
instr_mem_array[33] = 32'h200B0001; // addi $t3, $zero, 1      # index = 1
instr_mem_array[34] = 32'h200C000A; // addi $t4, $zero, 10     # total = 10

// loop:
instr_mem_array[35] = 32'h21080004; // addi $t0, $t0, 4        # move to next memory word
instr_mem_array[36] = 32'h8D0D0000; // lw   $t5, 0($t0)        # $t5 = mem[i]
instr_mem_array[37] = 32'h01AC702A; // slt  $t6, $t5, $t2      # if mem[i] < min
instr_mem_array[38] = 32'h11C00001; // beq  $t6, $zero, skip   # if not less, skip
instr_mem_array[39] = 32'h01A05020; // add  $t2, $t5, $zero    # min = mem[i]

// skip:
instr_mem_array[40] = 32'h216B0001; // addi $t3, $t3, 1        # index++
instr_mem_array[41] = 32'h016C702A; // slt  $t6, $t3, $t4      # if index < total
instr_mem_array[42] = 32'h15C0FFF8; // bne  $t6, $zero, loop   # if true, loop

// === Store Minimum at mem[10] ===
instr_mem_array[43] = 32'hAC0A0028; // sw $t2, 40($zero)       # mem[10] = min

// === Halt ===
instr_mem_array[44] = 32'hFC000000; // Custom halt instruction

end


endmodule





module mux2to1 #(parameter WIDTH = 32) (
  input [WIDTH-1:0] in0,
  input [WIDTH-1:0] in1,
  input sel,
  output [WIDTH-1:0] out
);

  wire sel_neg;
  not(sel_neg, sel);
  
  genvar j;
  generate
    for(j = 0; j < WIDTH; j = j + 1) begin: mux_logic
      wire and0_out, and1_out;
      
      // Replacing '&' with 'and' gate
      and(and0_out, in0[j], sel_neg);  // and0_out = in0[j] AND NOT(sel)
      and(and1_out, in1[j], sel);      // and1_out = in1[j] AND sel
      
      // Replacing '|' with 'or' gate
      or(out[j], and0_out, and1_out);  // out[j] = and0_out OR and1_out
    end
  endgenerate
endmodule


module adder (
  input [31:0] a,
  input [31:0] b,
  output [31:0] y
);
  wire [31:0] carry;
  
  // First bit addition (using half adder)
  wire ha_and_out;
  xor(y[0], a[0], b[0]);
  and(carry[0], a[0], b[0]);
  
  // Remaining bits (using full adders)
  genvar i;
  generate
    for(i=1; i<32; i=i+1) begin: full_adder_chain
      wire xor1_out, and1_out, and2_out, and3_out;
      
      // Sum calculation
      xor(xor1_out, a[i], b[i]);
      xor(y[i], xor1_out, carry[i-1]);
      
      // Carry calculation
      and(and1_out, a[i], b[i]);
      and(and2_out, a[i], carry[i-1]);
      and(and3_out, b[i], carry[i-1]);
      or(carry[i], and1_out, and2_out, and3_out);
    end
  endgenerate
endmodule



module mux2 (
  input  sel,
  input  in0,
  input  in1,
  output out
);
  assign out = sel ? in1 : in0;
endmodule



module dff (
  input  clk,
  input  reset,  // active‑high synchronous reset
  input  d,      
  output q
);
  wire d_int;       // data after reset‑mux
  wire inv_clk;     // inverted clock
  wire master_q;    // master‑latch output
  wire slave_q;     // slave‑latch output
  mux2 reset_mux (
    .sel  (reset),
    .in0  (d),
    .in1  (1'b0),
    .out  (d_int)
  );
  not inv1 (inv_clk, clk);
  mux2 master_mux (
    .sel  (inv_clk),
    .in0  (master_q),
    .in1  (d_int),
    .out  (master_q)
  );
  mux2 slave_mux (
    .sel  (clk),
    .in0  (slave_q),
    .in1  (master_q),
    .out  (slave_q)
  );
  assign q = slave_q;
endmodule



module decoder5to32 (
  input [4:0] in,
  input en,
  output [31:0] out
);
  assign out = en ? (32'b1 << in) : 32'b0;
endmodule




module mux32_1 (
  input  [1023:0] in_flat,   
  input  [4:0]    sel,
  output [31:0]   out
);
  // Extract the 32‑bit word at index sel
  assign out = in_flat[ sel*32 +: 32 ];
endmodule




module register32 (
  input clk,
  input reset,
  input write_en,
  input [31:0] d,
  output [31:0] q
);
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : reg_loop
      dff dff_inst (
        .clk(clk),
        .reset(reset),
        .d(write_en ? d[i] : q[i]),
        .q(q[i])
      );
    end
  endgenerate
endmodule




module sign_extend (
  input [15:0] in,
  output [31:0] out
);
  
  // Sign extension: replicate the most significant bit (in[15]) to fill the upper 16 bits
  assign out = {{16{in[15]}}, in};
  
endmodule





module sll_2_same (
  input [31:0] in,
  output [31:0] out
);
  
  // Shift left logical by 2 bits (multiply by 4)
  // The two least significant bits become 0, and the two most significant bits are discarded
  assign out = {in[29:0], 2'b00};
  
endmodule






module sll_2_pad #(parameter INP_WIDTH=26) (
  input [INP_WIDTH-1:0] in,
  output [INP_WIDTH+1:0] out
);
  
  // Shift left logical by 2 bits and pad with zeros
  // This increases the width by 2 bits
  assign out = {in, 2'b00};
  
endmodule




module mux5to1 (
  input [31:0] in0,      // AND result (000)
  input [31:0] in1,      // OR result (001)
  input [31:0] in2,      // ADD/SUB result (010/110)
  input [31:0] in3,      // SLT result (111)
  input [31:0] in4,      // NOR result (1100)
  input [3:0] sel,       // Operation select (from ALU control)
  output [31:0] out      // Selected result
);
  // Decode the operation select signals using pure gate-level logic
  wire sel_and, sel_or, sel_add, sel_sub, sel_slt, sel_nor;
  
  // AND: 0000
  assign sel_and = ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0];
  
  // OR: 0001
  assign sel_or = ~sel[3] & ~sel[2] & ~sel[1] & sel[0];
  
  // ADD: 0010
  assign sel_add = ~sel[3] & ~sel[2] & sel[1] & ~sel[0];
  
  // SUB: 0110
  assign sel_sub = ~sel[3] & sel[2] & sel[1] & ~sel[0];
  
  // SLT: 0111
  assign sel_slt = ~sel[3] & sel[2] & sel[1] & sel[0];
  
  // NOR: 1100
  assign sel_nor = sel[3] & sel[2] & ~sel[1] & ~sel[0];
  
  // Combine ADD and SUB for the adder/subtractor result
  wire sel_add_sub = sel_add | sel_sub;
  
  // Select the appropriate input for each bit
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin: mux_bits
      // Gate each input with its select signal
      wire [4:0] gated_inputs;
      
      assign gated_inputs[0] = in0[i] & sel_and;
      assign gated_inputs[1] = in1[i] & sel_or;
      assign gated_inputs[2] = in2[i] & sel_add_sub;  // Combined ADD/SUB
      assign gated_inputs[3] = in3[i] & sel_slt;
      assign gated_inputs[4] = in4[i] & sel_nor;
      
      // OR all gated inputs to produce the output
      assign out[i] = gated_inputs[0] | gated_inputs[1] | gated_inputs[2] | 
                     gated_inputs[3] | gated_inputs[4];
    end
  endgenerate
endmodule