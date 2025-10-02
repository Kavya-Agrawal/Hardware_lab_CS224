`timescale 1ns / 1ps

module funtion_tb;
    // Declare testbench signals
    reg signed [3:0] input_bits;
    reg clk, start , signals0, signals1;
    wire signed [3:0] y;
    wire valid;

//    wire [3:0] reg55;

//    wire [3:0] reg99;

    // Instantiate the DUT (Device Under Test)
    funtion uut (
        .input_bits(input_bits),
        .clk(clk), 
        .start(start), 
        .signals0(signals0),
        .signals1(signals1),
        .y(y)
    );

    // Generate Clock Signal
    always #5 clk = ~clk; // Toggle clock every 5 ns

     // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        start = 0;
        input_bits = 0;
        signals0 = 0;
        signals1 = 0;

        // Apply Test Cases in Decimal Format
        #10 input_bits = 1; signals1 = 0; signals0 = 0;
        #10 input_bits = 0; signals1 = 0; signals0 = 1;
        #10 input_bits = 1; signals1 = 1; signals0 = 0;
        #10 input_bits = 5; signals1 = 1; signals0 = 1;
        
        #10 start = 1;

        
        #20000 $finish; // Stop simulation
    end

    // Always block to monitor the outputs continuously
    always @* begin
        $monitor("Time = %0t | test_current_state = %d,c = %d,(T1,T3,T6) = %d,(T2, T5, T7) = %d,T4 = %d,T8 = %d,u = %d,x = %d,dx = %d,y = %d,three = %d,a = %d", 
                  $time, uut.test_current_state, uut.c, uut.test_reg1,  uut.test_reg2, uut.test_reg3, uut.test_reg4, uut.test_reg5, uut.test_reg6, uut.test_reg7, uut.test_reg8,  uut.test_reg10, uut.test_reg11);
    end
endmodule