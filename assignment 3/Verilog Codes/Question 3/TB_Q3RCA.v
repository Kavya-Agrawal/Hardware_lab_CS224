`timescale 1ns / 1ns

module tb_rca_32_bit();
    reg [31:0] A, B, C;
    wire [31:0] Sum;
    wire Cout;

    rca_32_bit uut (  // Correct module name
        .A(A),
        .B(B),
        .C(C),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        $monitor("Time=%0t A=%h B=%h C=%h | Sum=%h Cout=%b", $time, A, B, C, Sum, Cout);

        // Test Cases
        #5 A = 32'h00000001; B = 32'h00000002; C = 32'h00000003;  // 1 + 2 + 3 = 6
        #5 A = 32'h00000001; B = 32'h00000004; C = 32'h00000005;  // 1 + 4 + 5 = 10
        #5 A = 32'h00000002; B = 32'h00000003; C = 32'h00000004;  // 2 + 3 + 4 = 9
        #5 A = 32'h00000005; B = 32'h00000001; C = 32'h00000001;  // 5 + 6 + 7 = 18
        #5 A = 32'h00000010; B = 32'h00000020; C = 32'h00000030;  // 16 + 32 + 48 = 96
        #5 $finish;
    end
endmodule