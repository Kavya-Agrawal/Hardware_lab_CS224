`timescale 1ns / 1ps

module LONG_CHAIN_ADDITION_PART2_tb;

    // Inputs
    reg [3:0] input_val0; 
    reg [3:0] input_val1; 
    reg [3:0] input_val2; 
    reg [3:0] input_val3; 
    reg [3:0] input_val4; 
    reg [3:0] input_val5; 
    reg [3:0] input_val6; 
    reg [3:0] input_val7; 
    reg s_vi;
    reg clk;

    // Outputs
    wire [6:0] final_sum;
    wire s_ld_valid;

    // Instantiate the Unit Under Test (UUT)
    LONG_CHAIN_ADDITION_PART2 uut (
        .input_val0(input_val0), 
        .input_val1(input_val1), 
        .input_val2(input_val2), 
        .input_val3(input_val3), 
        .input_val4(input_val4), 
        .input_val5(input_val5), 
        .input_val6(input_val6), 
        .input_val7(input_val7), 
        .s_vi(s_vi),
        .clk(clk),
        .final_sum(final_sum),
        .s_ld_valid(s_ld_valid)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Display internal state at every clock cycle
    always @(posedge clk) begin
        $display("Time %0t | r0=%d r1=%d r2=%d r3=%d r4=%d r5=%d r6=%d r7=%d | x=%d x1=%d x2=%d x3=%d | y=%d y1=%d | z=%d | final_sum=%d | valid=%b",
                 $time,
                 uut.test_r0, uut.test_r1, uut.test_r2, uut.test_r3,
                 uut.test_r4, uut.test_r5, uut.test_r6, uut.test_r7,
                 uut.test_x0, uut.test_x1, uut.test_x2, uut.test_x3,
                 uut.test_y0, uut.test_y1,
                 uut.test_z, final_sum, s_ld_valid);
    end

    initial begin
        // Initialize inputs
        clk = 0;
        s_vi = 0;
        input_val0 = 3;
        input_val1 = 3;
        input_val2 = 3;
        input_val3 = 3;
        input_val4 = 3;
        input_val5 = 3;
        input_val6 = 3;
        input_val7 = 3;
       

        // Trigger input
        #10;
        s_vi = 1;
        input_val0 = 0;
        input_val1 = 5;
        input_val2 = 6;
        input_val3 = 7;
        input_val4 = 8;
        input_val5 = 9;
        input_val6 = 2;
        input_val7 = 2;

        #20;
        s_vi = 0;

        #60;

        $finish;
    end
endmodule