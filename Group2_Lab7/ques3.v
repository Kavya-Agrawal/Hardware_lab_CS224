`timescale 1ns / 1ps
module LONG_CHAIN_ADDITION_PART3 (
    input [319:0] input_matrix,
    input s_vi,
    input clk,
    output [6:0] final_sum,
    output vo,
    output stop
);
    // mux signals
    wire [3:0] s_sel_MUX; 

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

    CONTROLLER controller (
        .s_vi(s_vi),
        .clk(clk),
        .s_sel_MUX(s_sel_MUX),
        .s_ld_REG0(s_ld_REG0),
        .s_ld_REG1(s_ld_REG1),
        .s_ld_REG2(s_ld_REG2),
        .s_ld_REG3(s_ld_REG3),
        .s_ld_REG4(s_ld_REG4),
        .s_ld_REG5(s_ld_REG5),
        .s_ld_REG6(s_ld_REG6),
        .s_ld_REG7(s_ld_REG7),
        .s_ld_REGX0(s_ld_REGX0),
        .s_ld_REGX1(s_ld_REGX1),
        .s_ld_REGX2(s_ld_REGX2),
        .s_ld_REGX3(s_ld_REGX3),
        .s_ld_REGY0(s_ld_REGY0),
        .s_ld_REGY1(s_ld_REGY1),
        .s_ld_REGZ(s_ld_REGZ),
        .vo(vo),
        .stop(stop)
    );

    DATAPATH data_path (
        .clk(clk),
        .final_sum(final_sum),
        .input_matrix(input_matrix),
        .s_ld_REG0(s_ld_REG0),
        .s_ld_REG1(s_ld_REG1),
        .s_ld_REG2(s_ld_REG2),
        .s_ld_REG3(s_ld_REG3),
        .s_ld_REG4(s_ld_REG4),
        .s_ld_REG5(s_ld_REG5),
        .s_ld_REG6(s_ld_REG6),
        .s_ld_REG7(s_ld_REG7),
        .s_ld_REGX0(s_ld_REGX0),
        .s_ld_REGX1(s_ld_REGX1),
        .s_ld_REGX2(s_ld_REGX2),
        .s_ld_REGX3(s_ld_REGX3),
        .s_ld_REGY0(s_ld_REGY0),
        .s_ld_REGY1(s_ld_REGY1),
        .s_ld_REGZ(s_ld_REGZ),
        .s_sel_MUX(s_sel_MUX),
        .test_r0(test_r0),
        .test_r1(test_r1),
        .test_r2(test_r2),
        .test_r3(test_r3),
        .test_r4(test_r4),
        .test_r5(test_r5),
        .test_r6(test_r6),
        .test_r7(test_r7),
        .test_x0(test_x0),
        .test_x1(test_x1),
        .test_x2(test_x2),
        .test_x3(test_x3),
        .test_y0(test_y0),
        .test_y1(test_y1),
        .test_z(test_z)
    );

    
endmodule


module DATAPATH(
    input clk,
    output [6:0] final_sum,
    input [319:0] input_matrix,
    
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

    input [3:0] s_sel_MUX,

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
    wire [6:0] ADDER_5_OUT;
    wire [6:0] ADDER_6_OUT;
    wire [6:0] ADDER_7_OUT;

    wire [3:0] MUX_REG0_OUT;
    wire [3:0] MUX_REG1_OUT;
    wire [3:0] MUX_REG2_OUT;
    wire [3:0] MUX_REG3_OUT;
    wire [3:0] MUX_REG4_OUT;
    wire [3:0] MUX_REG5_OUT;
    wire [3:0] MUX_REG6_OUT;
    wire [3:0] MUX_REG7_OUT;

    register #(4) REG0(REG0_OUT, MUX_REG0_OUT, clk, s_ld_REG0);
    register #(4) REG1(REG1_OUT, MUX_REG1_OUT, clk, s_ld_REG1);
    register #(4) REG2(REG2_OUT, MUX_REG2_OUT, clk, s_ld_REG2);
    register #(4) REG3(REG3_OUT, MUX_REG3_OUT, clk, s_ld_REG3);
    register #(4) REG4(REG4_OUT, MUX_REG4_OUT, clk, s_ld_REG4);
    register #(4) REG5(REG5_OUT, MUX_REG5_OUT, clk, s_ld_REG5);
    register #(4) REG6(REG6_OUT, MUX_REG6_OUT, clk, s_ld_REG6);
    register #(4) REG7(REG7_OUT, MUX_REG7_OUT, clk, s_ld_REG7); 

    register #(7) REGX0(REGX0_OUT, ADDER_1_OUT, clk, s_ld_REGX0);
    register #(7) REGX1(REGX1_OUT, ADDER_2_OUT, clk, s_ld_REGX1);
    register #(7) REGX2(REGX2_OUT, ADDER_3_OUT, clk, s_ld_REGX2);
    register #(7) REGX3(REGX3_OUT, ADDER_4_OUT, clk, s_ld_REGX3);

    register #(7) REGY0(REGY0_OUT, ADDER_5_OUT, clk, s_ld_REGY0);
    register #(7) REGY1(REGY1_OUT, ADDER_6_OUT, clk, s_ld_REGY1);

    register #(7) REGZ(REGZ_OUT, ADDER_7_OUT, clk, s_ld_REGZ);

    mux16to1_4bit MUX_REG0 ( // column 1
        .in0(input_matrix[319 - 0*32 -: 4]),
        .in1(input_matrix[319 - 1*32 -: 4]),
        .in2(input_matrix[319 - 2*32 -: 4]),
        .in3(input_matrix[319 - 3*32 -: 4]),
        .in4(input_matrix[319 - 4*32 -: 4]),
        .in5(input_matrix[319 - 5*32 -: 4]),
        .in6(input_matrix[319 - 6*32 -: 4]),
        .in7(input_matrix[319 - 7*32 -: 4]),
        .in8(input_matrix[319 - 8*32 -: 4]),
        .in9(input_matrix[319 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG0_OUT)
    );

    mux16to1_4bit MUX_REG1 ( // column 2
        .in0(input_matrix[315 - 0*32 -: 4]),
        .in1(input_matrix[315 - 1*32 -: 4]),
        .in2(input_matrix[315 - 2*32 -: 4]),
        .in3(input_matrix[315 - 3*32 -: 4]),
        .in4(input_matrix[315 - 4*32 -: 4]),
        .in5(input_matrix[315 - 5*32 -: 4]),
        .in6(input_matrix[315 - 6*32 -: 4]),
        .in7(input_matrix[315 - 7*32 -: 4]),
        .in8(input_matrix[315 - 8*32 -: 4]),
        .in9(input_matrix[315 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG1_OUT)
    );

    mux16to1_4bit MUX_REG2 ( // column 3
        .in0(input_matrix[311 - 0*32 -: 4]),
        .in1(input_matrix[311 - 1*32 -: 4]),
        .in2(input_matrix[311 - 2*32 -: 4]),
        .in3(input_matrix[311 - 3*32 -: 4]),
        .in4(input_matrix[311 - 4*32 -: 4]),
        .in5(input_matrix[311 - 5*32 -: 4]),
        .in6(input_matrix[311 - 6*32 -: 4]),
        .in7(input_matrix[311 - 7*32 -: 4]),
        .in8(input_matrix[311 - 8*32 -: 4]),
        .in9(input_matrix[311 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG2_OUT)
    );

    mux16to1_4bit MUX_REG3 ( // column 4
        .in0(input_matrix[307 - 0*32 -: 4]),
        .in1(input_matrix[307 - 1*32 -: 4]),
        .in2(input_matrix[307 - 2*32 -: 4]),
        .in3(input_matrix[307 - 3*32 -: 4]),
        .in4(input_matrix[307 - 4*32 -: 4]),
        .in5(input_matrix[307 - 5*32 -: 4]),
        .in6(input_matrix[307 - 6*32 -: 4]),
        .in7(input_matrix[307 - 7*32 -: 4]),
        .in8(input_matrix[307 - 8*32 -: 4]),
        .in9(input_matrix[307 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG3_OUT)
    );

    mux16to1_4bit MUX_REG4 ( // column 5
        .in0(input_matrix[303 - 0*32 -: 4]),
        .in1(input_matrix[303 - 1*32 -: 4]),
        .in2(input_matrix[303 - 2*32 -: 4]),
        .in3(input_matrix[303 - 3*32 -: 4]),
        .in4(input_matrix[303 - 4*32 -: 4]),
        .in5(input_matrix[303 - 5*32 -: 4]),
        .in6(input_matrix[303 - 6*32 -: 4]),
        .in7(input_matrix[303 - 7*32 -: 4]),
        .in8(input_matrix[303 - 8*32 -: 4]),
        .in9(input_matrix[303 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG4_OUT)
    );

    mux16to1_4bit MUX_REG5 ( // column 6
        .in0(input_matrix[299 - 0*32 -: 4]),
        .in1(input_matrix[299 - 1*32 -: 4]),
        .in2(input_matrix[299 - 2*32 -: 4]),
        .in3(input_matrix[299 - 3*32 -: 4]),
        .in4(input_matrix[299 - 4*32 -: 4]),
        .in5(input_matrix[299 - 5*32 -: 4]),
        .in6(input_matrix[299 - 6*32 -: 4]),
        .in7(input_matrix[299 - 7*32 -: 4]),
        .in8(input_matrix[299 - 8*32 -: 4]),
        .in9(input_matrix[299 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG5_OUT)
    );

    mux16to1_4bit MUX_REG6 ( // column 7
        .in0(input_matrix[295 - 0*32 -: 4]),
        .in1(input_matrix[295 - 1*32 -: 4]),
        .in2(input_matrix[295 - 2*32 -: 4]),
        .in3(input_matrix[295 - 3*32 -: 4]),
        .in4(input_matrix[295 - 4*32 -: 4]),
        .in5(input_matrix[295 - 5*32 -: 4]),
        .in6(input_matrix[295 - 6*32 -: 4]),
        .in7(input_matrix[295 - 7*32 -: 4]),
        .in8(input_matrix[295 - 8*32 -: 4]),
        .in9(input_matrix[295 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG6_OUT)
    );

    mux16to1_4bit MUX_REG7 ( // column 8
        .in0(input_matrix[291 - 0*32 -: 4]),
        .in1(input_matrix[291 - 1*32 -: 4]),
        .in2(input_matrix[291 - 2*32 -: 4]),
        .in3(input_matrix[291 - 3*32 -: 4]),
        .in4(input_matrix[291 - 4*32 -: 4]),
        .in5(input_matrix[291 - 5*32 -: 4]),
        .in6(input_matrix[291 - 6*32 -: 4]),
        .in7(input_matrix[291 - 7*32 -: 4]),
        .in8(input_matrix[291 - 8*32 -: 4]),
        .in9(input_matrix[291 - 9*32 -: 4]),
        .in10(4'b0000), .in11(4'b0000),
        .in12(4'b0000), .in13(4'b0000), .in14(4'b0000), .in15(4'b0000),
        .sel(s_sel_MUX), .out(MUX_REG7_OUT)
    );

    adder_4bit ADDER1(REG0_OUT, REG1_OUT, 1'b0, ADDER_1_OUT);
    adder_4bit ADDER2(REG2_OUT, REG3_OUT, 1'b0, ADDER_2_OUT);
    adder_4bit ADDER3(REG4_OUT, REG5_OUT, 1'b0, ADDER_3_OUT);
    adder_4bit ADDER4(REG6_OUT, REG7_OUT, 1'b0, ADDER_4_OUT); 
    adder ADDER5(REGX0_OUT, REGX1_OUT, 1'b0, ADDER_5_OUT);
    adder ADDER6(REGX2_OUT, REGX3_OUT, 1'b0, ADDER_6_OUT);
    adder ADDER7(REGY0_OUT, REGY1_OUT, 1'b0, ADDER_7_OUT);

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


module adder (
  input wire [6:0] a,
  input wire [6:0] b,
  input wire subtract,  // Control input: 0 for addition, 1 for subtraction
  output reg [6:0] sum
);

always @* begin
    if (subtract == 1) 
        sum = a - b; 
    else 
        sum = a + b; 
end

endmodule

module adder_4bit (
  input wire [3:0] a,
  input wire [3:0] b,
  input wire subtract,  // 0 = add, 1 = subtract
  output reg [6:0] sum
);

reg [6:0] a_ext, b_ext;

always @* begin
    a_ext = {3'b000, a};  // Extend to 7 bits
    b_ext = {3'b000, b};

    if (subtract == 1)
        sum = a_ext + (~b_ext + 1);  // Two’s complement subtraction
    else
        sum = a_ext + b_ext;
end

endmodule

module mux16to1_4bit (
    input  [3:0] in0,
    input  [3:0] in1,
    input  [3:0] in2,
    input  [3:0] in3,
    input  [3:0] in4,
    input  [3:0] in5,
    input  [3:0] in6,
    input  [3:0] in7,
    input  [3:0] in8,
    input  [3:0] in9,
    input  [3:0] in10,
    input  [3:0] in11,
    input  [3:0] in12,
    input  [3:0] in13,
    input  [3:0] in14,
    input  [3:0] in15,
    
    input  [3:0] sel,
    output reg [3:0] out
);

    always @(*) begin
        case (sel)
            4'd0:  out = in0;
            4'd1:  out = in1;
            4'd2:  out = in2;
            4'd3:  out = in3;
            4'd4:  out = in4;
            4'd5:  out = in5;
            4'd6:  out = in6;
            4'd7:  out = in7;
            4'd8:  out = in8;
            4'd9:  out = in9;
            4'd10: out = in10;
            4'd11: out = in11;
            4'd12: out = in12;
            4'd13: out = in13;
            4'd14: out = in14;
            4'd15: out = in15;
            default: out = 4'b0000;
        endcase
    end

endmodule


module CONTROLLER(
    input s_vi,        
    input clk,    

    output reg [3:0] s_sel_MUX,

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

    output reg vo,
    output reg stop
);
    
    reg [2:0] current_state = 3'b000; 
    reg [2:0] next_state;    
    reg [3:0] i = 4'b1111;          
    reg [3:0] counter = 4'b0000;          

    always @(posedge clk) begin
        if(next_state == 2 ) current_state = next_state;
        else current_state <= next_state;
        // $display("%t , Currstate=%b, nextstate=%b, svi=%b", $time, current_state , next_state , s_vi);
        #1 $display("%t , Currstate=%b, nextstate=%b, svi=%b", $time, current_state , next_state , s_vi);
    end
        
    always @(posedge clk) begin
        // $display("%t , currstate=%b, nextstate=%b, vo=%b", $time, current_state , next_state , vo);
        case (current_state)
            3'b000: begin // start state
                if (s_vi) next_state = 3'b001; 
                    else next_state = 3'b000;    
            end

            3'b001: begin // input state
                // $display("%t ,i=%b", $time, i);
                if (i == 4'b1011) next_state = 3'b010; 
                else begin next_state = 3'b001; i = i+1; end
            end

            3'b010: begin 
                    next_state = 3'b011; 
                    // else begin next_state = 3'b010; counter = counter+1; end
            end

            3'b011: begin
                next_state = 3'b011;
            end

            default: begin
                next_state = 3'b000;           
            end
        endcase


        // State transition logic for different states
        case(current_state) 
            // Start state
            3'b000 : begin 
                s_sel_MUX <= 4'b0000;

                s_ld_REG0 <= 1;   
                s_ld_REG1 <= 1;   
                s_ld_REG2 <= 1;   
                s_ld_REG3 <= 1;   
                s_ld_REG4 <= 1;   
                s_ld_REG5 <= 1;   
                s_ld_REG6 <= 1;   
                s_ld_REG7 <= 1;   

                s_ld_REGX0 <= 1;   
                s_ld_REGX1 <= 1;   
                s_ld_REGX2 <= 1;   
                s_ld_REGX3 <= 1;   

                s_ld_REGY0 <= 1;  
                s_ld_REGY1 <= 1;

                s_ld_REGZ <= 1;

                vo = 0;
                stop  = 0;

            end

            // input state
            3'b001 : begin 
                
                s_sel_MUX <= i+1;

                s_ld_REG0 <= 1;   
                s_ld_REG1 <= 1;   
                s_ld_REG2 <= 1;   
                s_ld_REG3 <= 1;   
                s_ld_REG4 <= 1;   
                s_ld_REG5 <= 1;   
                s_ld_REG6 <= 1;   
                s_ld_REG7 <= 1;   

                s_ld_REGX0 <= 1;   
                s_ld_REGX1 <= 1;   
                s_ld_REGX2 <= 1;   
                s_ld_REGX3 <= 1;   

                s_ld_REGY0 <= 1;  
                s_ld_REGY1 <= 1;

                s_ld_REGZ <= 1;

                if (i>=4'b0011) vo = 1;
                // else if (i><=4'b0011) vo <= 1;
                else vo = 0;
                stop = 0;

            end

            3'b010 : begin 
                s_sel_MUX <= 4'b1010;

                s_ld_REG0 <= 1;   
                s_ld_REG1 <= 1;   
                s_ld_REG2 <= 1;   
                s_ld_REG3 <= 1;   
                s_ld_REG4 <= 1;   
                s_ld_REG5 <= 1;   
                s_ld_REG6 <= 1;   
                s_ld_REG7 <= 1;   

                s_ld_REGX0 <= 1;   
                s_ld_REGX1 <= 1;   
                s_ld_REGX2 <= 1;   
                s_ld_REGX3 <= 1;   

                s_ld_REGY0 <= 1;  
                s_ld_REGY1 <= 1;

                s_ld_REGZ <= 1;

                vo = 0;
                stop = 0;

            end

            3'b011 : begin 
                s_sel_MUX <= 4'b1010;

                s_ld_REG0 <= 0;   
                s_ld_REG1 <= 0;   
                s_ld_REG2 <= 0;   
                s_ld_REG3 <= 0;   
                s_ld_REG4 <= 0;   
                s_ld_REG5 <= 0;   
                s_ld_REG6 <= 0;   
                s_ld_REG7 <= 0;   

                s_ld_REGX0 <= 0;   
                s_ld_REGX1 <= 0;   
                s_ld_REGX2 <= 0;   
                s_ld_REGX3 <= 0;   

                s_ld_REGY0 <= 0;  
                s_ld_REGY1 <= 0;

                s_ld_REGZ <= 0;

                vo = 0;
                stop = 1;

            end

        endcase
        // $display("%t , currstate=%b, nextstate=%b, vo=%b", $time, current_state , next_state , vo);
    end
        
       
endmodule