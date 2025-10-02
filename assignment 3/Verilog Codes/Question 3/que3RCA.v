`timescale 1ns / 1ps

module rca_32_bit (
    input [31:0] A, B, C,
    output [31:0] Sum,
    output Cout
);
    wire [32:0] carry1, carry2;
    assign carry1[0] = 1'b0;  
    assign carry2[0] = 1'b0;  

    wire [31:0] sum_stage1; 

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            // First stage: Add A and B
            full_adder fa1 (
                .A(A[i]),
                .B(B[i]),
                .Cin(carry1[i]),
                .Sum(sum_stage1[i]),
                .Cout(carry1[i+1])
            );

            // Second stage: Add intermediate sum and C
            full_adder fa2 (
                .A(sum_stage1[i]),
                .B(C[i]),
                .Cin(carry2[i]),
                .Sum(Sum[i]),
                .Cout(carry2[i+1])
            );
        end
    endgenerate

    assign Cout = carry2[32];  

endmodule


module full_adder (
    input A, B, Cin,
    output Sum, Cout
);
    assign Sum = A ^ B ^ Cin;  
    assign Cout = (A & B) | (B & Cin) | (A & Cin);  

endmodule
