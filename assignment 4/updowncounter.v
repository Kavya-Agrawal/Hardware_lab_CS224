`timescale 1ns / 1ps

// Up/Down counter module with set and reset functionality
module updowncounter(
    input clk,               // Clock signal
    input reset,             // Reset signal
    input set,               // Set signal for loading a specific value
    input up,                // Control for counting up
    input [3:0] value,       // 4-bit value to set the counter
    output [3:0] counter     // 4-bit counter output
);

    wire reset_neg = ~reset;  // Inverted reset signal
    
    // Wires for multiplexing the counter bits
    wire mux_out1, mux_out2;
    
    // First bit (counter[0]) logic
    mux mux1(1, value[0], set, mux_out1);
    mux mux2(1, ~value[0], set, mux_out2);
    
    wire reset_logic1, reset_logic2;
    assign reset_logic1 = (reset_neg & mux_out1);
    assign reset_logic2 = (reset | mux_out2);
    
    wire Q0, Q0_bar;
    jkFF ff1(reset_logic1, reset_logic2, clk, counter[0], Q0_bar);
    
    // Second bit (counter[1]) logic
    wire mux_out3, mux_out4, mux_out5;
    mux mux3(Q0_bar, counter[0], up, mux_out3);
    mux mux4(mux_out3, value[1], set, mux_out4);
    mux mux5(mux_out3, ~value[1], set, mux_out5);
    
    wire reset_logic3, reset_logic4;
    assign reset_logic3 = (mux_out4 & reset_neg);
    assign reset_logic4 = (mux_out5 | reset);
    
    wire Q1, Q1_bar;
    jkFF ff2(reset_logic3, reset_logic4, clk, counter[1], Q1_bar);
    
    // Third bit (counter[2]) logic
    wire mux_out6, mux_out7, mux_out8;
    mux mux6(Q1_bar, counter[1], up, mux_out6);
    assign mux_out7 = (mux_out6 & mux_out3);
    
    mux mux7(mux_out7, value[2], set, mux_out8);
    mux mux8(mux_out7, ~value[2], set, mux_out9);
    
    wire reset_logic5, reset_logic6;
    wire Q2, Q2_bar;
    assign reset_logic5 = (mux_out8 & reset_neg);
    assign reset_logic6 = (mux_out9 | reset);
    
    jkFF ff3(reset_logic5, reset_logic6, clk, counter[2], Q2_bar);
    
    // Fourth bit (counter[3]) logic
    wire mux_out10, mux_out11, mux_out12, mux_out13;
    mux mux9(Q2_bar, counter[2], up, mux_out10);
    assign mux_out11 = (mux_out10 & mux_out6);
    
    mux mux10(mux_out11, value[3], set, mux_out12);
    mux mux11(mux_out11, ~value[3], set, mux_out13);
    
    wire reset_logic7, reset_logic8;
    wire Q3, Q3_bar;
    assign reset_logic7 = (mux_out12 & reset_neg);
    assign reset_logic8 = (mux_out13 | reset);
    
    jkFF ff4(reset_logic7, reset_logic8, clk, counter[3], Q3_bar);

endmodule


// 2-to-1 multiplexer
module mux(
    input a,       // Input a
    input b,       // Input b
    input select,  // Select signal
    output y       // Output y
);
    assign y = (select == 0) ? a : b; // If select is 0, output a; else output b
endmodule


// JK flip-flop module
module jkFF(
    input j, k, clk,  // Inputs j, k, and clock signal
    output reg Q, Q_bar  // Outputs Q and its complement
);

    // On the rising edge of the clock, update the outputs based on J and K values
    always @(posedge clk) begin
        case ({j, k})
            2'b00: {Q, Q_bar} <= {Q, Q_bar};     // No change
            2'b01: {Q, Q_bar} <= {1'b0, 1'b1};   // Reset
            2'b10: {Q, Q_bar} <= {1'b1, 1'b0};   // Set
            2'b11: {Q, Q_bar} <= {~Q, Q};        // Toggle
            default: begin end
        endcase
    end

endmodule
