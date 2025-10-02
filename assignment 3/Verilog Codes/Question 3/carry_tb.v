`timescale 1ns / 1ps

module carry_tb;

    reg [31:0] A, B, C;
    wire [31:0] Sum;
    wire Cout;

    carry_save_adderr uut (
        .A(A),
        .B(B),
        .C(C),
        .Sum(Sum),
        .Cout(Cout)
    );

    initial begin
        
        $monitor("Time = %0t | A = %d, B = %d, C = %d | Sum = %d, Cout = %b", 
                 $time, A, B, C, Sum, Cout);

      
        A = 10; B = 2; C = 15; #10;
        A = 5; B = 7; C = 8; #10;
        A = 20; B = 30; C = 25; #10;
        A = 50; B = 100; C = 75; #10;  
        A = 123; B = 234; C = 345; #10;
     
        $finish;
    end
    
endmodule