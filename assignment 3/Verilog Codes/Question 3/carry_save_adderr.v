`timescale 1ns / 0.1ns


///module for carry save adder 
module carry_save_adderr (
    input [31:0] A, B, C, /// taking inputs
    output [31:0]Sum,   /// declaring output
    output Cout    //////declaring cout
);
    wire [31:0] carry, temp_sum;  
    
    //////////iterating over biits to calculate carry and tempsum

    genvar i;
    
        for (i = 0; i < 32; i = i + 1) begin 
            assign temp_sum[i] = A[i] ^ B[i] ^ C[i];         
            assign carry[i] = (A[i] & B[i]) | (B[i] & C[i]) | (A[i] & C[i]); 
        end
    
    //////////////initializing rca for the second stage

    rca ripple_carry_adder_module (
        .A(temp_sum),
        .B({carry[30:0], 1'b0}),
        .Sum(Sum),
        .Cout(Cout)
    );

endmodule

/////////module for ripple carry adder

module rca (
    input [31:0] A, B, /// taking inputs
    output [31:0] Sum, /// declaring output
    output Cout //////declaring cout
);
    wire [31:0] carry;
    assign carry[0] = 1'b0;

 //////////iterating over biits to calculate carrys

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin 
            full_adder fa (
                .A(A[i]),
                .B(B[i]),
                .Cin(carry[i]),
                .Sum(Sum[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign Cout = carry[31];
endmodule

module full_adder (
    input A, B, Cin,
    output Sum, Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule