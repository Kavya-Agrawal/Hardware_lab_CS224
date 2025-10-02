module ALU (
  input [31:0] a,
  input [31:0] b,
  input [3:0] op,
  output [31:0] result,
  output zero
);
  // Internal wires for operation results
  wire [31:0] and_result;
  wire [31:0] or_result;
  wire [31:0] add_sub_result;
  wire [31:0] slt_result;
  wire [31:0] nor_result;
  
  // Carry chain for addition/subtraction
  wire [32:0] carry;
  wire [31:0] b_input;
  wire Binvert;
  
  // Control signal decoding
  assign Binvert = op[2];  // High for subtraction (op = 0110)
  
  // Generate b_input based on Binvert (invert b for subtraction)
  genvar j;
  generate
    for (j = 0; j < 32; j = j + 1) begin: b_invert_gen
      assign b_input[j] = b[j] ^ Binvert;
    end
  endgenerate
  
  // Set initial carry-in (1 for subtraction to implement 2's complement)
  assign carry[0] = Binvert;
  
  // Basic logic operations
  genvar k;
  generate
    for (k = 0; k < 32; k = k + 1) begin: logic_ops
      assign and_result[k] = a[k] & b[k];
      assign or_result[k] = a[k] | b[k];
      assign nor_result[k] = ~(a[k] | b[k]);
    end
  endgenerate
  
  // Addition/Subtraction with carry chain
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin: adder_loop
      // Full adder implementation
      assign add_sub_result[i] = a[i] ^ b_input[i] ^ carry[i];
      assign carry[i+1] = (a[i] & b_input[i]) | (a[i] & carry[i]) | (b_input[i] & carry[i]);
    end
  endgenerate
  
  // Set on less than (SLT) - uses the sign bit of subtraction result
  assign slt_result = {31'b0, add_sub_result[31]};
  
  // Operation selection multiplexer
  // Assuming we have a mux module available as mentioned
  mux5to1 result_mux (
    .in0(and_result),
    .in1(or_result),
    .in2(add_sub_result),
    .in3(slt_result),
    .in4(nor_result),
    .sel(op),
    .out(result)
  );
  
  // Zero detection
  assign zero = (result == 32'b0);
endmodule




module instr_mem #(parameter Addr_width = 8) (read_address,instruction);
//asynchronous memory with 256 32-bit locations
//for instruction memory
parameter S=32;
parameter L=(1<<Addr_width);

input [$clog2(L) - 1:0] read_address;
output [(S-1):0] instruction;

reg [S-1:0] memory [L-1:0];
  assign instruction=memory[read_address/4];

//initial begin $readmemh("instr_mem.dat", memory);

initial begin
    memory[0]  = 32'h20080004; // main: addi $t0, $zero, 4
    memory[1]  = 32'h2009000A; // addi $t1, $zero, 10
    memory[2]  = 32'h00005020; // add $t2, $zero, $zero
    memory[3]  = 32'h200B0005; // addi $t3, $zero, 5

    memory[4]  = 32'hAD090000; // store_loop: sw $t1, 0($t0)
    memory[5]  = 32'h21080004; // addi $t0, $t0, 4
    memory[6]  = 32'h214A0001; // addi $t2, $t2, 1
    memory[7]  = 32'h014B702A; // slt $t6, $t2, $t3
    memory[8]  = 32'h11C00001; // beq $t6, $zero, store_done
    memory[9]  = 32'h08000004; // j store_loop

    memory[10] = 32'h20040004; // store_done: addi $a0, $zero, 4
    memory[11] = 32'h200B0005; // addi $a1, $zero, 5
    memory[12] = 32'h0C00000F; // jal sum_array

    memory[13] = 32'hAC020004; // sw $v0, 4($zero)
    memory[14] = 32'hFC000000; // exit (custom opcode 0xFC)

    memory[15] = 32'h00044020; // sum_array: add $t0, $zero, $a0
    memory[16] = 32'h000B4820; // add $t1, $zero, $a1
    memory[17] = 32'h00005020; // add $t2, $zero, $zero
    memory[18] = 32'h00005820; // add $t3, $zero, $zero

    memory[19] = 32'h8D0F0000; // sum_loop: lw $t7, 0($t0)
    memory[20] = 32'h014F5020; // add $t2, $t2, $t7
    memory[21] = 32'h21080004; // addi $t0, $t0, 4
    memory[22] = 32'h216B0001; // addi $t3, $t3, 1
    memory[23] = 32'h0169602A; // slt $t4, $t3, $t1
    memory[24] = 32'h11800001; // beq $t4, $zero, sum_done
    memory[25] = 32'h08000013; // j sum_loop

    memory[26] = 32'h01401020; // sum_done: add $v0, $t2, $zero
    memory[27] = 32'h17E00008; // jr $ra (custom interpretation)
end

endmodule




module mux2to1 #(parameter WIDTH = 32) (
  input [WIDTH-1:0] in0,
  input [WIDTH-1:0] in1,
  input sel,
  output [WIDTH-1:0] out
);
  
  wire sel_n;
  not(sel_n, sel);
  
  genvar i;
  generate
    for(i=0; i<WIDTH; i=i+1) begin: mux_gate
      wire and0_out, and1_out;
      and(and0_out, in0[i], sel_n);
      and(and1_out, in1[i], sel);
      or(out[i], and0_out, and1_out);
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


