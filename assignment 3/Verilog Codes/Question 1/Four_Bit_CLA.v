`timescale 1ns/1ps

// 4-bit Carry Lookahead Adder (CLA) Module
// This module implements a 4-bit adder using carry lookahead logic to improve speed.

module adder_4bit_cla(sum, Cout, A, B, Cin);

    // Inputs
    input [3:0] A, B;       // 4-bit input values A and B
    input Cin;               // Carry-in input
    
    // Outputs
    output [3:0] sum;       // 4-bit sum output
    output Cout;             // Carry-out output
    
    // Internal wires for Propagate and Generate signals
    wire P0, G0, P1, G1, P2, G2, P3, G3;
    wire C4, C3, C2, C1;     // Internal carry signals for each stage
    
    // Propagate signals for each bit (P = A XOR B)
    assign
        P0 = A[0] ^ B[0],     // Propagate for bit 0
        P1 = A[1] ^ B[1],     // Propagate for bit 1
        P2 = A[2] ^ B[2],     // Propagate for bit 2
        P3 = A[3] ^ B[3];     // Propagate for bit 3
        
    // Generate signals for each bit (G = A AND B)
    assign
        G0 = A[0] & B[0],     // Generate for bit 0
        G1 = A[1] & B[1],     // Generate for bit 1
        G2 = A[2] & B[2],     // Generate for bit 2
        G3 = A[3] & B[3];     // Generate for bit 3
        
    // Carry propagation logic
    assign
        C1 = G0 | (P0 & Cin),                        // Carry for bit 1
        C2 = G1 | (P1 & G0) | (P1 & P0 & Cin),       // Carry for bit 2
        C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin),  // Carry for bit 3
        C4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & Cin);  // Carry for bit 4 (Cout)
        
    // Sum calculation: Each bit of the sum is calculated as the XOR of the propagate signal and the respective carry-in
    assign
        sum[0] = P0 ^ Cin,                             // Sum for bit 0
        sum[1] = P1 ^ C1,                              // Sum for bit 1
        sum[2] = P2 ^ C2,                              // Sum for bit 2
        sum[3] = P3 ^ C3;                              // Sum for bit 3
        
    // Final carry-out (Cout)
    assign Cout = C4;    // The carry-out is the final carry signal (C4)
    
endmodule
