`timescale 1ns / 1ps

module LONG_CHAIN_ADDITION_PART2 (
    input [3:0] input_val0, 
    input [3:0] input_val1, 
    input [3:0] input_val2, 
    input [3:0] input_val3, 
    input [3:0] input_val4, 
    input [3:0] input_val5, 
    input [3:0] input_val6, 
    input [3:0] input_val7, 

    input s_vi,

    input clk,

    output [6:0] final_sum,
    output s_ld_valid
);

    // mux signals
    wire [1:0] s_sel_MUX_ADDER1_1; 
    wire [1:0] s_sel_MUX_ADDER1_2; 

    wire s_sel_MUX_ADDER2_1;
    wire s_sel_MUX_ADDER2_2;

    wire s_ld_REG0;   
    wire s_ld_REG1;   
    wire s_ld_REG2;   
    wire s_ld_REG3;   
    wire s_ld_REG4;   
    wire s_ld_REG5;   
    wire s_ld_REG6;   
    wire s_ld_REG7;   
    wire s_ld_REGX0;   
    wire s_ld_REGX1;   
    wire s_ld_REGX2;   
    wire s_ld_REGX3;   
    wire s_ld_REGY0;   
    wire s_ld_REGY1; 
    wire s_ld_REGZ;

    wire [3:0] test_r0;
    wire [3:0] test_r1;
    wire [3:0] test_r2;
    wire [3:0] test_r3;
    wire [3:0] test_r4;
    wire [3:0] test_r5;
    wire [3:0] test_r6;
    wire [3:0] test_r7;
    wire [6:0] test_x0;
    wire [6:0] test_x1;
    wire [6:0] test_x2;
    wire [6:0] test_x3;
    wire [6:0] test_y0;
    wire [6:0] test_y1;
    wire [6:0] test_z;

CONTROLLER controller(
    s_vi,        
    clk,           
    s_sel_MUX_ADDER1_1, 
    s_sel_MUX_ADDER1_2, 
    s_sel_MUX_ADDER2_1,
    s_sel_MUX_ADDER2_2,
    s_ld_REG0,   
    s_ld_REG1,   
    s_ld_REG2,   
    s_ld_REG3,   
    s_ld_REG4,   
    s_ld_REG5,   
    s_ld_REG6,   
    s_ld_REG7,   
    s_ld_REGX0,   
    s_ld_REGX1,   
    s_ld_REGX2,   
    s_ld_REGX3,   
    s_ld_REGY0,   
    s_ld_REGY1, 
    s_ld_REGZ,
    s_ld_valid
);

DATAPATH data_path (
    clk,
    final_sum,  
    input_val0, 
    input_val1, 
    input_val2, 
    input_val3, 
    input_val4, 
    input_val5, 
    input_val6, 
    input_val7, 
    s_ld_REG0,   
    s_ld_REG1,   
    s_ld_REG2,   
    s_ld_REG3,   
    s_ld_REG4,   
    s_ld_REG5,   
    s_ld_REG6,   
    s_ld_REG7, 
    s_ld_REGX0,   
    s_ld_REGX1,   
    s_ld_REGX2,   
    s_ld_REGX3,  
    s_ld_REGY0,  
    s_ld_REGY1,
    s_ld_REGZ,
    s_sel_MUX_ADDER1_1,  
    s_sel_MUX_ADDER1_2,  
    s_sel_MUX_ADDER2_1, 
    s_sel_MUX_ADDER2_2,

    //test wires
    test_r0,
    test_r1,
    test_r2,
    test_r3,
    test_r4,
    test_r5,
    test_r6,
    test_r7,
    test_x0,
    test_x1,
    test_x2,
    test_x3,
    test_y0,
    test_y1,
    test_z

);
    
endmodule

//////////////////////////////////////////

// adder 1 + adder2 + adder3 + adder4
//         adder 1 + adder2
//             adder 1 

//////////////////////////////////////////

// FSM Module Definition
module CONTROLLER(

    input s_vi,        
    input clk,           
    
    // mux signals
    output reg [1:0] s_sel_MUX_ADDER1_1, 
    output reg [1:0] s_sel_MUX_ADDER1_2, 

    output reg s_sel_MUX_ADDER2_1,
    output reg s_sel_MUX_ADDER2_2,

    output reg s_ld_REG0,   
    output reg s_ld_REG1,   
    output reg s_ld_REG2,   
    output reg s_ld_REG3,   
    output reg s_ld_REG4,   
    output reg s_ld_REG5,   
    output reg s_ld_REG6,   
    output reg s_ld_REG7,   

    output reg s_ld_REGX0,   
    output reg s_ld_REGX1,   
    output reg s_ld_REGX2,   
    output reg s_ld_REGX3,   

    output reg s_ld_REGY0,   
    output reg s_ld_REGY1, 

    output reg s_ld_REGZ,

    output reg s_ld_valid

    );
    
    // 3-bit registers for current and next state
    reg [2:0] current_state = 3'b000; // Initial state is 000
    reg [2:0] next_state;              // Next state to be updated on clock

    // Always block triggered by the positive edge of clock
    always @(posedge clk)
        begin
            current_state <= next_state;
            // $display("[%t] State: %b %b", $time, current_state, next_state);
        end
        
    always @(current_state, s_vi)
        begin
            case (current_state)
                3'b000: begin // start state
                    if (s_vi) next_state = 3'b001; 
                        else next_state = 3'b000;    
                end

                3'b001: begin // input state
                    if (s_vi) next_state = 3'b001; 
                            else next_state = 3'b010; 
                end

                3'b010: begin // calc - 1 state
                    next_state = 3'b011;
                end

                3'b011: begin // calc - 2 state
                    next_state = 3'b100;
                end

                3'b100: begin // calc - 3 state
                    next_state = 3'b101;
                end

                3'b101: begin // ouput state
                    next_state = 3'b101;
                end
                
                default: begin
                    next_state = 3'b000;           
                end
            endcase


            // State transition logic for different states
            case(current_state) 
                // Start state
                3'b000 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b00; 
                    s_sel_MUX_ADDER1_2 = 2'b00; 
                    s_sel_MUX_ADDER2_1 = 0; 
                    s_sel_MUX_ADDER2_2 = 0; 

                    s_ld_REG0 = 0;   
                    s_ld_REG1 = 0;   
                    s_ld_REG2 = 0;   
                    s_ld_REG3 = 0;   
                    s_ld_REG4 = 0;   
                    s_ld_REG5 = 0;   
                    s_ld_REG6 = 0;   
                    s_ld_REG7 = 0;   

                    s_ld_REGX0 = 0;   
                    s_ld_REGX1 = 0;   
                    s_ld_REGX2 = 0;   
                    s_ld_REGX3 = 0;   

                    s_ld_REGY0 = 0;  
                    s_ld_REGY1 = 0;

                    s_ld_REGZ = 0;

                    s_ld_valid = 0;

                end

                // input state
                3'b001 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b00; 
                    s_sel_MUX_ADDER1_2 = 2'b00; 
                    s_sel_MUX_ADDER2_1 = 0; 
                    s_sel_MUX_ADDER2_2 = 0; 

                    s_ld_REG0 = 1;   
                    s_ld_REG1 = 1;   
                    s_ld_REG2 = 1;   
                    s_ld_REG3 = 1;   
                    s_ld_REG4 = 1;   
                    s_ld_REG5 = 1;   
                    s_ld_REG6 = 1;   
                    s_ld_REG7 = 1;   

                    s_ld_REGX0 = 0;   
                    s_ld_REGX1 = 0;   
                    s_ld_REGX2 = 0;   
                    s_ld_REGX3 = 0;   

                    s_ld_REGY0 = 0;  
                    s_ld_REGY1 = 0;

                    s_ld_REGZ = 0;

                    s_ld_valid = 0;

                end

                // calc - 1 state
                3'b010 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b00; 
                    s_sel_MUX_ADDER1_2 = 2'b00; 
                    s_sel_MUX_ADDER2_1 = 0; 
                    s_sel_MUX_ADDER2_2 = 0; 

                    s_ld_REG0 = 0;   
                    s_ld_REG1 = 0;   
                    s_ld_REG2 = 0;   
                    s_ld_REG3 = 0;   
                    s_ld_REG4 = 0;   
                    s_ld_REG5 = 0;   
                    s_ld_REG6 = 0;   
                    s_ld_REG7 = 0;   

                    s_ld_REGX0 = 1;   
                    s_ld_REGX1 = 1;   
                    s_ld_REGX2 = 1;   
                    s_ld_REGX3 = 1;   

                    s_ld_REGY0 = 0;  
                    s_ld_REGY1 = 0;

                    s_ld_REGZ = 0;

                    s_ld_valid = 0;

                end

                // calc - 2 state
                3'b011 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b01; 
                    s_sel_MUX_ADDER1_2 = 2'b01; 
                    s_sel_MUX_ADDER2_1 = 1; 
                    s_sel_MUX_ADDER2_2 = 1; 

                    s_ld_REG0 = 0;   
                    s_ld_REG1 = 0;   
                    s_ld_REG2 = 0;   
                    s_ld_REG3 = 0;   
                    s_ld_REG4 = 0;   
                    s_ld_REG5 = 0;   
                    s_ld_REG6 = 0;   
                    s_ld_REG7 = 0;   

                    s_ld_REGX0 = 0;   
                    s_ld_REGX1 = 0;   
                    s_ld_REGX2 = 0;   
                    s_ld_REGX3 = 0;   

                    s_ld_REGY0 = 1;  
                    s_ld_REGY1 = 1;

                    s_ld_REGZ = 0;

                    s_ld_valid = 0;

                end

                // calc - 3 state
                3'b100 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b10; 
                    s_sel_MUX_ADDER1_2 = 2'b10; 
                    s_sel_MUX_ADDER2_1 = 0; 
                    s_sel_MUX_ADDER2_2 = 0; 

                    s_ld_REG0 = 0;   
                    s_ld_REG1 = 0;   
                    s_ld_REG2 = 0;   
                    s_ld_REG3 = 0;   
                    s_ld_REG4 = 0;   
                    s_ld_REG5 = 0;   
                    s_ld_REG6 = 0;   
                    s_ld_REG7 = 0;   

                    s_ld_REGX0 = 0;   
                    s_ld_REGX1 = 0;   
                    s_ld_REGX2 = 0;   
                    s_ld_REGX3 = 0;   

                    s_ld_REGY0 = 0;  
                    s_ld_REGY1 = 0;

                    s_ld_REGZ = 1;

                    s_ld_valid = 0;

                end

                // output state
                3'b101 : begin 
                    s_sel_MUX_ADDER1_1 = 2'b00; 
                    s_sel_MUX_ADDER1_2 = 2'b00; 
                    s_sel_MUX_ADDER2_1 = 0; 
                    s_sel_MUX_ADDER2_2 = 0; 

                    s_ld_REG0 = 0;   
                    s_ld_REG1 = 0;   
                    s_ld_REG2 = 0;   
                    s_ld_REG3 = 0;   
                    s_ld_REG4 = 0;   
                    s_ld_REG5 = 0;   
                    s_ld_REG6 = 0;   
                    s_ld_REG7 = 0;   

                    s_ld_REGX0 = 0;   
                    s_ld_REGX1 = 0;   
                    s_ld_REGX2 = 0;   
                    s_ld_REGX3 = 0;   

                    s_ld_REGY0 = 0;  
                    s_ld_REGY1 = 0;

                    s_ld_REGZ = 0;

                    s_ld_valid = 1;

                end

            endcase
        end
        
       
endmodule

module DATAPATH(
    input clk,

    output [6:0] final_sum,  // 7 bit output

    input [3:0] input_val0, 
    input [3:0] input_val1, 
    input [3:0] input_val2, 
    input [3:0] input_val3, 
    input [3:0] input_val4, 
    input [3:0] input_val5, 
    input [3:0] input_val6, 
    input [3:0] input_val7, 

    input s_ld_REG0,   
    input s_ld_REG1,   
    input s_ld_REG2,   
    input s_ld_REG3,   
    input s_ld_REG4,   
    input s_ld_REG5,   
    input s_ld_REG6,   
    input s_ld_REG7, 
    input s_ld_REGX0,   
    input s_ld_REGX1,   
    input s_ld_REGX2,   
    input s_ld_REGX3,  
    input s_ld_REGY0,  
    input s_ld_REGY1,
    input s_ld_REGZ,

    input [1:0] s_sel_MUX_ADDER1_1,  
    input [1:0] s_sel_MUX_ADDER1_2,  
    input s_sel_MUX_ADDER2_1, 
    input s_sel_MUX_ADDER2_2,


    output [3:0] test_r0,
    output [3:0] test_r1,
    output [3:0] test_r2,
    output [3:0] test_r3,
    output [3:0] test_r4,
    output [3:0] test_r5,
    output [3:0] test_r6,
    output [3:0] test_r7,
    output [6:0] test_x0,
    output [6:0] test_x1,
    output [6:0] test_x2,
    output [6:0] test_x3,
    output [6:0] test_y0,
    output [6:0] test_y1,
    output [6:0] test_z
    
);

    wire [3:0] REG0_OUT;
    wire [3:0] REG1_OUT;
    wire [3:0] REG2_OUT;
    wire [3:0] REG3_OUT;
    wire [3:0] REG4_OUT;
    wire [3:0] REG5_OUT;
    wire [3:0] REG6_OUT;
    wire [3:0] REG7_OUT;

    wire [6:0] REGX0_OUT;
    wire [6:0] REGX1_OUT;
    wire [6:0] REGX2_OUT;
    wire [6:0] REGX3_OUT;

    wire [6:0] REGY0_OUT;
    wire [6:0] REGY1_OUT;
    
    wire [6:0] REGZ_OUT;

    wire [6:0] ADDER_1_OUT;
    wire [6:0] ADDER_2_OUT;
    wire [6:0] ADDER_3_OUT;
    wire [6:0] ADDER_4_OUT;

    wire [6:0] MUX_ADDER1_1_OUT;
    wire [6:0] MUX_ADDER1_2_OUT;
    wire [6:0] MUX_ADDER2_1_OUT;
    wire [6:0] MUX_ADDER2_2_OUT;

    register #(4) REG0(REG0_OUT, input_val0, clk, s_ld_REG0);
    register #(4) REG1(REG1_OUT, input_val1, clk, s_ld_REG1);
    register #(4) REG2(REG2_OUT, input_val2, clk, s_ld_REG2);
    register #(4) REG3(REG3_OUT, input_val3, clk, s_ld_REG3);
    register #(4) REG4(REG4_OUT, input_val4, clk, s_ld_REG4);
    register #(4) REG5(REG5_OUT, input_val5, clk, s_ld_REG5);
    register #(4) REG6(REG6_OUT, input_val6, clk, s_ld_REG6);
    register #(4) REG7(REG7_OUT, input_val7, clk, s_ld_REG7);

    register #(7) REGX0(REGX0_OUT, ADDER_1_OUT, clk, s_ld_REGX0);
    register #(7) REGX1(REGX1_OUT, ADDER_2_OUT, clk, s_ld_REGX1);
    register #(7) REGX2(REGX2_OUT, ADDER_3_OUT, clk, s_ld_REGX2);
    register #(7) REGX3(REGX3_OUT, ADDER_4_OUT, clk, s_ld_REGX3);

    register #(7) REGY0(REGY0_OUT, ADDER_1_OUT, clk, s_ld_REGY0);
    register #(7) REGY1(REGY1_OUT, ADDER_2_OUT, clk, s_ld_REGY1);

    register #(7) REGZ(REGZ_OUT, ADDER_1_OUT, clk, s_ld_REGZ);

    mux4to1 MUX_ADDER1_1(REG0_OUT, REGX0_OUT, REGY0_OUT, 7'b0000000, s_sel_MUX_ADDER1_1, MUX_ADDER1_1_OUT);
    mux4to1 MUX_ADDER1_2(REG1_OUT, REGX1_OUT, REGY1_OUT, 7'b0000000, s_sel_MUX_ADDER1_2, MUX_ADDER1_2_OUT);
    mux2to1 MUX_ADDER2_1(REG2_OUT, REGX2_OUT, s_sel_MUX_ADDER2_1, MUX_ADDER2_1_OUT);
    mux2to1 MUX_ADDER2_2(REG3_OUT, REGX3_OUT, s_sel_MUX_ADDER2_2, MUX_ADDER2_2_OUT);

    adder ADDER1(MUX_ADDER1_1_OUT, MUX_ADDER1_2_OUT, 1'b0, ADDER_1_OUT);
    adder ADDER2(MUX_ADDER2_1_OUT, MUX_ADDER2_2_OUT, 1'b0, ADDER_2_OUT);
    adder_4bit ADDER3(REG4_OUT, REG5_OUT, 1'b0, ADDER_3_OUT);
    adder_4bit ADDER4(REG6_OUT, REG7_OUT, 1'b0, ADDER_4_OUT);

    assign final_sum = REGZ_OUT;

    assign test_r0 = REG0_OUT;
    assign test_r1 = REG1_OUT;
    assign test_r2 = REG2_OUT;
    assign test_r3 = REG3_OUT;
    assign test_r4 = REG4_OUT;
    assign test_r5 = REG5_OUT;
    assign test_r6 = REG6_OUT;
    assign test_r7 = REG7_OUT;
    assign test_x0 = REGX0_OUT;
    assign test_x1 = REGX1_OUT;
    assign test_x2 = REGX2_OUT;
    assign test_x3 = REGX3_OUT;
    assign test_y0 = REGY0_OUT;
    assign test_y1 = REGY1_OUT;
    assign test_z = REGZ_OUT;
    
endmodule


module register #(
    parameter WIDTH = 4  // Default parameter value is 4
)(
    output reg [WIDTH-1:0] out,  // Output width depends on parameter
    input [WIDTH-1:0] in,        // Input width depends on parameter
    input clock,
    input writing_enable
);

    // Initialize the output to 0 at the start of simulation
    initial begin
        out = {WIDTH{1'b0}};  // Set all bits of the output to 0
    end

    always @(posedge clock) begin
        if (writing_enable) begin
            out <= in;  // Store input in output
        end
    end
endmodule


module mux2to1 (
    input  wire [3:0] A,       // 4-bit input A
    input  wire [6:0] B,       // 7-bit input B
    input  wire       sel,     // Select signal
    output wire [6:0] Y        // 7-bit output Y
);
    assign Y = (sel) ? B : {3'b000, A};  // Zero-extend A to 7 bits
endmodule


module mux4to1 (
    input  wire [3:0] A,        // 4-bit input A
    input  wire [6:0] B,        // 7-bit input B
    input  wire [6:0] C,        // 7-bit input C
    input  wire [6:0] D,        // 7-bit input D
    input  wire [1:0] sel,      // 2-bit select signal
    output wire [6:0] Y         // 7-bit output Y
);
    assign Y = (sel == 2'b00) ? {3'b000, A} : // Zero-extend A to 7 bits
               (sel == 2'b01) ? B :
               (sel == 2'b10) ? C :
               (sel == 2'b11) ? D :
               7'b0000000; // Default to 0 for safety
endmodule

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder(
    input [6:0] a,
    input [6:0] b,
    input cin,
    output [6:0] sum,
    output cout
);
    // Intermediate carry signals
    wire [6:0] carry;
    
    // First full adder with input carry
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    // Remaining full adders
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );
    
    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );
    
    full_adder fa4(
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );
    
    full_adder fa5(
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );
    
    full_adder fa6(
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );
    
    // Final carry out
    assign cout = carry[6];
endmodule


module adder_4bit(
    input  [3:0] a,
    input  [3:0] b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    wire c1, c2, c3;

    full_adder fa0 (
        .a    (a[0]),
        .b    (b[0]),
        .cin  (cin),
        .sum  (sum[0]),
        .cout (c1)
    );

    full_adder fa1 (
        .a    (a[1]),
        .b    (b[1]),
        .cin  (c1),
        .sum  (sum[1]),
        .cout (c2)
    );

    full_adder fa2 (
        .a    (a[2]),
        .b    (b[2]),
        .cin  (c2),
        .sum  (sum[2]),
        .cout (c3)
    );

    full_adder fa3 (
        .a    (a[3]),
        .b    (b[3]),
        .cin  (c3),
        .sum  (sum[3]),
        .cout (cout)
    );

endmodule