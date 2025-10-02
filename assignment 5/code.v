`timescale 1ns / 1ps

module funtion (
    input signed [3:0] input_bits, 
    input clk,
    input start,
    input signals0,
    input signals1,
    output signed [3:0] y,
    output valid
);

    wire c;

    wire SUB;   
    wire FU_MUX1; 
    wire [1:0] FU_MUX2; 
    wire [1:0] FU_ADDER;

    wire REG1;    
    wire REG2;    
    wire REG3;    
    wire REG4;    
    wire REG5;    
    wire REG6;    
    wire REG7;    
    wire REG8;    
    wire REG9;    
    wire REG10;   
    wire REG11;   

    wire REG_MUX1;
    wire [1:0] REG_MUX2;
    wire REG_MUX5;
    wire REG_MUX6;
    wire REG_MUX8;
    wire REG_MUX9;
    
    wire signed [3:0] test_ADDER_OUT;
    wire [3:0] test_current_state;
    
    wire signed [3:0] test_reg1;
    wire signed [3:0] test_reg2;
    wire signed [3:0] test_reg3;
    wire signed [3:0] test_reg4;
    wire signed [3:0] test_reg5;
    wire signed [3:0] test_reg6;
    wire signed [3:0] test_reg7;
    wire signed [3:0] test_reg8;
    wire signed [3:0] test_reg9;
    wire signed [3:0] test_reg10;
    wire signed [3:0] test_reg11;
    

FSM_Module CONTROLLER(test_current_state , start, c, clk, SUB, FU_MUX1, FU_MUX2, FU_ADDER, REG1, REG2, REG3, REG4, REG5, REG6, REG7, REG8, REG9, REG10, REG11, 
    REG_MUX1, REG_MUX2, REG_MUX5, REG_MUX6, REG_MUX8, REG_MUX9 , valid
);

DATAPATH data_path (y, c,test_reg1, test_reg2, test_reg3, test_reg4, test_reg5, test_reg6, test_reg7, test_reg8, test_reg9, test_reg10, test_reg11 ,test_ADDER_OUT,input_bits, signals0 , signals1 , clk, SUB, FU_MUX1, FU_MUX2, FU_ADDER, REG1, REG2, REG3, REG4, REG5, REG6, REG7, REG8, REG9, REG10, REG11, 
    REG_MUX1, REG_MUX2, REG_MUX5, REG_MUX6, REG_MUX8, REG_MUX9
);
    
endmodule

// FSM Module Definition
module FSM_Module(


    output [3:0] test_current_state,


    input start,         // Start signal to trigger state transitions
    input c,             // Control signal (used in state transition logic)
    input clk,           // Clock signal (used for state updates)
    
    output reg SUB,      // Output register for the SUB signal\
    
    output reg FU_MUX1,  // Output for the FU_MUX1 signal
    output reg [1:0] FU_MUX2,  // Output for the 2-bit FU_MUX2 signal
    output reg [1:0] FU_ADDER,  // Output for the 2-bit FU_ADDER signal
    
    output reg REG1,    // Output for register 1
    output reg REG2,    // Output for register 2
    output reg REG3,    // Output for register 3
    output reg REG4,    // Output for register 4
    output reg REG5,    // Output for register 5
    output reg REG6,    // Output for register 6
    output reg REG7,    // Output for register 7
    output reg REG8,    // Output for register 8
    output reg REG9,    // Output for register 9
    output reg REG10,   // Output for register 10
    output reg REG11,   // Output for register 11
    
    output reg REG_MUX1, // Output for the REG_MUX1 signal
    output reg [1:0] REG_MUX2,  // Output for the 2-bit REG_MUX2 signal
    output reg REG_MUX5,
    output reg REG_MUX6,
    output reg REG_MUX8,
    
    output reg REG_MUX9,
   
    output reg valid
    

    );
    
    // 3-bit registers for current and next state
    reg [2:0] current_state = 3'b000; // Initial state is 000
    reg [2:0] next_state;              // Next state to be updated on clock

    // Always block triggered by the positive edge of clock
    always @(posedge clk)
        begin
            // Update current state on clock pulse
            current_state <= next_state;
            
            // Display the current state at each clock cycle
            $display("[%t] State: %b", $time, next_state);
        end
        
    // Always block for state transition logic
    always @(current_state, start, c)
        begin
            if (current_state == 3'b111) begin
                next_state = 3'b111;
            end else begin
                // Logic to calculate the next state based on current state, start, and c signals
                next_state[2] <= start & ((current_state[2] & (~current_state[1])) 
                                          | (current_state[0] & current_state[1] & (~current_state[2])) 
                                          | ((~c) & current_state[1] & (~current_state[2])));
            
                next_state[1] <= start & ((current_state[0] & (~current_state[1])) 
                                          | (current_state[1] & (~current_state[0])));
            
                next_state[0] <= start & (((~current_state[0]) & (~current_state[1])) 
                                          | ((~current_state[0]) & (~current_state[2])));
            end



            // State transition logic for different states
            case(current_state) 
                // Start state
                3'b000 : begin 
                    SUB = 0;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b00;
                    
                    // Reset all registers
                    REG1 = 0;
                    REG2 = 0;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 1;
                    REG6 = 1;
                    REG7 = 1;
                    REG8 = 0;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 1;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    valid = 0;

                end
                // Initial state setup (initialization)
                3'b001 : begin 
                    SUB = 0;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b00;
                    
                    REG1 = 0;
                    REG2 = 0;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 0;
                    REG6 = 0;
                    REG7 =0;
                    REG8 = 1;  
                    REG9 = 1;
                    REG10 = 1;
                    REG11 = 0;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    
                    valid = 0;
                    
                end
                
                // Checker state
                3'b010 : begin 
                    SUB = 0;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b00;
                    
                    // Reset all registers
                    REG1 = 0;
                    REG2 = 0;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 0;
                    REG6 = 0;
                    REG7 = 0;
                    REG8 = 0;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    
                    valid = 0;

                end
                 
                // S1 state
                3'b011 : begin  
                    SUB = 0;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b00;
                    
                    REG1 = 1;
                    REG2 = 1;
                    REG3 = 1;
                    REG4 = 1;
                    REG5 = 0;
                    REG6 = 0;
                    REG7 = 0;
                    REG8 = 0;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    valid = 0;

                end
                  
                // S2 state
                3'b100 : begin  
                    SUB = 0;
                    FU_MUX1 = 1;
                    FU_MUX2 = 2'b01;
                    FU_ADDER = 2'b01;
                    
                    REG1 = 1;
                    REG2 = 1;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 0;
                    REG6 = 1;
                    REG7 = 0;
                    REG8 = 1;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 1;
                    REG_MUX2 = 2'b01;
                    REG_MUX5 = 0;
                    REG_MUX6 = 1;
                    REG_MUX8 = 1;
                    REG_MUX9 = 0;
                    
                    valid = 0;
                    
                end
                  
                // S3 state
                3'b101 : begin  
                    SUB = 1;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b10;
                    FU_ADDER = 2'b10;
                    
                    REG1 = 1;
                    REG2 = 1;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 0;
                    REG6 = 0;
                    REG7 = 0;
                    REG8 = 0;
                    REG9 = 1;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 1;
                    REG_MUX2 = 2'b10;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 1;
                    
                    valid = 0;
                end
                  
                // S4 state
                3'b110 : begin  
                    SUB = 1;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b11;
                    
                    REG1 = 0;
                    REG2 = 0;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 1;
                    REG6 = 0;
                    REG7 = 0;
                    REG8 = 0;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 1;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    
                    valid = 0;
                end
                  
                // Output state (final state)
                3'b111 : begin  
                    SUB = 0;
                    FU_MUX1 = 0;
                    FU_MUX2 = 2'b00;
                    FU_ADDER = 2'b00;
                    
                    // Reset all registers
                    REG1 = 0;
                    REG2 = 0;
                    REG3 = 0;
                    REG4 = 0;
                    REG5 = 0;
                    REG6 = 0;
                    REG7 = 0;
                    REG8 = 0;
                    REG9 = 0;
                    REG10 = 0;
                    REG11 = 0;
                    
                    REG_MUX1 = 0;
                    REG_MUX2 = 2'b00;
                    REG_MUX5 = 0;
                    REG_MUX6 = 0;
                    REG_MUX8 = 0;
                    REG_MUX9 = 0;
                    
                    valid = 1;
                end
            endcase
        end
        
        assign test_current_state = current_state;
       
endmodule

module DATAPATH(
    output signed [3:0] y, 
    output c, 
    output signed [3:0] test_reg1,
    output signed [3:0] test_reg2,
    output signed [3:0] test_reg3,
    output signed [3:0] test_reg4,
    output signed [3:0] test_reg5,
    output signed [3:0] test_reg6,
    output signed [3:0] test_reg7,
    output signed [3:0] test_reg8,
    output signed [3:0] test_reg9,
    output signed [3:0] test_reg10,
    output signed [3:0] test_reg11,
        
    
    output signed [3:0] test_ADDER_OUT,


    input signed [3:0] input_bits,
    input signals0,
    input signals1,
    input clk,
    input s_SUB,      // Output register for the SUB signal
    
    input s_FU_MUX1,  // Output for the FU_MUX1 signal
    input [1:0] s_FU_MUX2,  // Output for the 2-bit FU_MUX2 signal
    input [1:0] s_FU_ADDER,  // Output for the 2-bit FU_ADDER signal
    
    input s_REG1,    // Output for register 1
    input s_REG2,    // Output for register 2
    input s_REG3,    // Output for register 3
    input s_REG4,    // Output for register 4
    input s_REG5,    // Output for register 5
    input s_REG6,    // Output for register 6
    input s_REG7,    // Output for register 7
    input s_REG8,    // Output for register 8
    input s_REG9,    // Output for register 9
    input s_REG10,   // Output for register 10
    input s_REG11,   // Output for register 11
    
    input s_REG_MUX1, // Output for the REG_MUX1 signal
    input [1:0] s_REG_MUX2,  // Output for the 2-bit REG_MUX2 signal
    input s_REG_MUX5,
    input s_REG_MUX6,
    input s_REG_MUX8,
    input s_REG_MUX9
);

    
    wire signed [3:0] REG_MUX1_OUT;
    wire signed [3:0] REG_MUX2_OUT;
    wire signed [3:0] REG_MUX5_OUT;
    wire signed [3:0] REG_MUX6_OUT;
    wire signed [3:0] REG_MUX8_OUT;
    wire signed [3:0] REG_MUX9_OUT;

    wire signed [3:0] MUL1_MUX1_OUT;
    wire signed [3:0] MUL1_MUX2_OUT;

    wire signed [3:0] MUL2_MUX1_OUT;
    wire signed [3:0] MUL2_MUX2_OUT;

    wire signed [3:0] ADD_MUX1_OUT;
    wire signed [3:0] ADD_MUX2_OUT;
    
    wire signed [3:0] MUL1_OUT;
    wire signed [3:0] MUL2_OUT;
    wire signed [3:0] MUL3_OUT;
    wire signed [3:0] ADDER_OUT;
    
    wire COMP_OUT;

    wire signed [3:0] R1_OUT;
    wire signed [3:0] R2_OUT;
    wire signed [3:0] R3_OUT;
    wire signed [3:0] R4_OUT;
    wire signed [3:0] R5_OUT;
    wire signed [3:0] R6_OUT;
    wire signed [3:0] R7_OUT;
    wire signed [3:0] R8_OUT;
    wire signed [3:0] R9_OUT;
    wire signed [3:0] R10_OUT;
    wire signed [3:0] R11_OUT;
    
    
    //input bit wires demux
    wire signed [3:0] demux0;
    wire signed [3:0] demux1;
    wire signed [3:0] demux2;
    wire signed [3:0] demux3;
                
    
    register R1 (R1_OUT, REG_MUX1_OUT, clk, s_REG1); 
    register R2 (R2_OUT, REG_MUX2_OUT, clk, s_REG2); 
    register R3(R3_OUT, MUL3_OUT, clk, s_REG3);
    register R4(R4_OUT, ADDER_OUT, clk, s_REG4);
    register R5(R5_OUT, REG_MUX5_OUT, clk, s_REG5);
    register R6(R6_OUT, REG_MUX6_OUT, clk, s_REG6);
    register R7(R7_OUT, demux2, clk, s_REG7);
    register R8(R8_OUT, REG_MUX8_OUT, clk, s_REG8);
    register R9(R9_OUT, REG_MUX9_OUT, clk, s_REG9);
    register R10(R10_OUT, 3, clk, s_REG10);
    register R11(R11_OUT, demux3, clk, s_REG11);

    mux2to1 MUX_REGISTER_R1(MUL1_OUT, MUL2_OUT, s_REG_MUX1, REG_MUX1_OUT);
    mux4to1 MUX_REGISTER_R2(MUL2_OUT, MUL1_OUT, ADDER_OUT, 0, s_REG_MUX2, REG_MUX2_OUT);
    mux2to1 MUX_REGISTER_R5(demux0, ADDER_OUT, s_REG_MUX5, REG_MUX5_OUT);
    mux2to1 MUX_REGISTER_R6(demux1, R4_OUT, s_REG_MUX6, REG_MUX6_OUT);
    mux2to1 MUX_REGISTER_R8(0, ADDER_OUT, s_REG_MUX8, REG_MUX8_OUT);

    mux2to1 MUX_REGISTER_R9(1, COMP_OUT, s_REG_MUX9, REG_MUX9_OUT);

    mux2to1 MUX1_MUL1(R5_OUT, R2_OUT, s_FU_MUX1, MUL1_MUX1_OUT);
    mux2to1 MUX2_MUL1(R7_OUT, R1_OUT, s_FU_MUX1, MUL1_MUX2_OUT);

    mux4to1 MUX1_MUL2(R10_OUT, R10_OUT, R1_OUT, 0, s_FU_MUX2, MUL2_MUX1_OUT);
    mux4to1 MUX2_MUL2(R6_OUT, R8_OUT, R7_OUT, 0, s_FU_MUX2, MUL2_MUX2_OUT);

    mux4to1 MUX1_ADDER(R6_OUT, R3_OUT, R5_OUT, R2_OUT, s_FU_ADDER, ADD_MUX1_OUT);
    mux4to1 MUX2_ADDER(R7_OUT, R8_OUT, R2_OUT, R1_OUT, s_FU_ADDER, ADD_MUX2_OUT);

    multiplier MUL_1(MUL1_MUX1_OUT, MUL1_MUX2_OUT, MUL1_OUT); 
    multiplier MUL_2(MUL2_MUX1_OUT, MUL2_MUX2_OUT, MUL2_OUT); 
    multiplier MUL_3(R5_OUT, R7_OUT, MUL3_OUT); 

    adder ADDER(ADD_MUX1_OUT, ADD_MUX2_OUT, s_SUB, ADDER_OUT);
    
    comparator COMP(R4_OUT, R11_OUT, COMP_OUT);
    
    
    
    
    demux_4to4 demux_input_bits(input_bits, { signals1, signals0 } , demux0, demux1, demux2, demux3 );
    
     assign y = R8_OUT;
     assign c = R9_OUT;
     
     assign test_reg1 = R1_OUT;
     assign test_reg2 = R2_OUT;
     assign test_reg3 = R3_OUT;
     assign test_reg4 = R4_OUT;
     assign test_reg5 = R5_OUT;
     assign test_reg6 = R6_OUT;
     assign test_reg7 = R7_OUT;
     assign test_reg8 = R8_OUT;
     assign test_reg9 = R9_OUT;
     assign test_reg10 = R10_OUT;
     assign test_reg11 = R11_OUT;
     

     assign test_ADDER_OUT = ADDER_OUT;
    
endmodule


module register #(
    parameter WIDTH = 32  // Default parameter value is 4
)(
    output reg [WIDTH-1:0] out,  // Output width depends on parameter
    input [WIDTH-1:0] in,        // Input width depends on parameter
    input clock,
    input writing_enable
);
    always @(posedge clock) begin
        if (writing_enable) begin
            out <= in;  // Store input in output
        end
    end
endmodule


module mux2to1 (
    input wire signed [3:0] A,        // 4-bit input A
    input wire signed [3:0] B,        // 4-bit input B
    input wire sel,             // Select signal
    output wire signed [3:0] Y        // 4-bit output Y
);
    assign Y = (sel) ? B : A;  // If select is 1, output B, else output A
endmodule


module mux4to1 (
    input wire signed [3:0] A,        // 4-bit input A
    input wire signed [3:0] B,        // 4-bit input B
    input wire signed [3:0] C,        // 4-bit input C
    input wire signed [3:0] D,        // 4-bit input D
    input wire [1:0] sel,      // 2-bit select signal
    output wire signed [3:0] Y        // 4-bit output Y
);
    assign Y = (sel == 2'b00) ? A :
               (sel == 2'b01) ? B :
               (sel == 2'b10) ? C :
               (sel == 2'b11) ? D : 4'b0000;  // Default to 0 for safety
endmodule


module multiplier(
    input wire signed [3:0] a,
    input wire signed [3:0] b,
    output wire signed [3:0] c
);
    assign c=a*b;
    
endmodule

module adder (
  input wire signed [3:0] a,
  input wire signed [3:0] b,
  input wire subtract,  // Control input: 0 for addition, 1 for subtraction
  output reg signed [3:0] sum
);

always @* begin
  if (subtract == 1) 
    sum = a - b; // Perform subtraction
  else 
    sum = a + b; // Perform addition
end

endmodule

module comparator (
    input signed [3:0] a,   // 4-bit input a
    input signed [3:0] b,   // 4-bit input b
    output reg out   // Output is 1 when a < b
);

    always @(*) begin
        if (a < b)
            out = 1;
        else
            out = 0;
    end

endmodule

module demux_4to4 (
    input signed [3:0] in,        // 4-bit signed input
    input [1:0] sel,              // 2-bit select line
    output reg signed [3:0] out0, // 4-bit signed output 0
    output reg signed [3:0] out1, // 4-bit signed output 1
    output reg signed [3:0] out2, // 4-bit signed output 2
    output reg signed [3:0] out3  // 4-bit signed output 3
);
    // Always block to handle the demultiplexing based on the select line
    always @ (in or sel) begin
   
        // Based on the select line, assign the input to the corresponding output
        case (sel)
            2'b00: out0 <= in; // if select is 00, assign to out0
            2'b01: out1 <= in; // if select is 01, assign to out1
            2'b10: out2 <= in; // if select is 10, assign to out2
            2'b11: out3 <= in; // if select is 11, assign to out3
            default: begin
                out0 <= 4'sb0000;
                out1 <= 4'sb0000;
                out2 <= 4'sb0000;
                out3 <= 4'sb0000;
            end
        endcase
    end
endmodule

module clock_gen(
    output reg clk  // Output clock signal
);

    initial begin
        clk = 0;  // Initialize clock to 0
    end

    // Always block to toggle the clock every 10 simulation time units
    always begin
        #10 clk = ~clk;  // Toggle clock every 10 time units
    end

endmodule