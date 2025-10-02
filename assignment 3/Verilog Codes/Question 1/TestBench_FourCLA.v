`timescale 1ns/1ps

// Testbench for 4-bit Carry Lookahead Adder (CLA)
// This testbench verifies the functionality of the adder_4bit_cla module.

module adder_4bit_cla_tb;
    
    // Declare the inputs for the CLA module
    reg [3:0] A, B;       // 4-bit input values A and B
    reg Cin;               // Carry-in input
    
    // Declare the outputs
    wire [3:0] sum;       // 4-bit sum output
    wire Cout;             // Carry-out output
    
    // Instantiate the CLA module (Unit Under Test - UUT)
    adder_4bit_cla uut (
        .A(A),      // Connect input A
        .B(B),      // Connect input B
        .Cin(Cin),  // Connect input Cin
        .sum(sum),  // Connect output sum
        .Cout(Cout) // Connect output Cout
    );
    
    // Test cases
    initial begin
        // Monitor changes in the inputs and outputs
        $monitor("A = %b, B = %b, Cin = %b | Sum = %b, Cout = %b", A, B, Cin, sum, Cout);
        
        // Apply test vectors with different input values
        A = 4'b0000; B = 4'b0000; Cin = 1'b0; #10;  // Test case 1: A = 0000, B = 0000, Cin = 0
        A = 4'b0001; B = 4'b0001; Cin = 1'b0; #10;  // Test case 2: A = 0001, B = 0001, Cin = 0
        A = 4'b0011; B = 4'b0101; Cin = 1'b0; #10;  // Test case 3: A = 0011, B = 0101, Cin = 0
        A = 4'b0110; B = 4'b0011; Cin = 1'b1; #10;  // Test case 4: A = 0110, B = 0011, Cin = 1
        A = 4'b1111; B = 4'b0001; Cin = 1'b1; #10;  // Test case 5: A = 1111, B = 0001, Cin = 1
        A = 4'b1010; B = 4'b0101; Cin = 1'b0; #10;  // Test case 6: A = 1010, B = 0101, Cin = 0
        A = 4'b1111; B = 4'b1111; Cin = 1'b1; #10;  // Test case 7: A = 1111, B = 1111, Cin = 1
        
        // Finish simulation after all test cases are run
        $finish;
    end
    
endmodule
