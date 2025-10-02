`timescale 1ns / 1ps

module upDownCounter_tb;

    // Inputs to the DUT (Device Under Test)
    reg clk;          // Clock signal
    reg reset;        // Reset signal
    reg set;          // Set signal to initialize counter
    reg up;           // Up/Down control signal
    reg [3:0] value;  // 4-bit value to load into the counter

    // Outputs from the DUT
    wire [3:0] counter; // 4-bit counter value

    // Instantiate the updowncounter module (DUT)
    updowncounter uut (
        .clk(clk),
        .reset(reset),
        .set(set),
        .up(up),
        .value(value),
        .counter(counter)
    );

    // Clock generation: Toggle clock every 5 ns (10 ns period)
    always #5 clk = ~clk; 

    initial begin
        // Initialize inputs
        clk = 0;       // Start clock at 0
        reset = 1;     // Apply reset initially
        set = 0;       // Set is initially off
        up = 1;        // Initially counting up
        value = 4'b0000; // Initial value to load into counter

        // Apply reset for 1 clock cycle (reset to 0 after 10 ns)
        #10 reset = 0;

        // Wait for a few clock cycles (50 ns)
        #50;

        // Set the counter value to 7 (0111)
        set = 1;
        value = 4'b0111;  // Load 7 into counter
        #10 set = 0;     // Disable set

        // Wait for the counter to reach its maximum value and then reset (200 ns)
        #200;

        // Set the counter value to 2 (0010)
        set = 1;
        value = 4'b0010;  // Load 2 into counter
        #10 set = 0;     // Disable set

        // Wait for a few clock cycles (50 ns)
        #50;

        // Apply reset again
        reset = 1;
        #10 reset = 0;

        // Wait for a few clock cycles (50 ns)
        #50;
        
        // Change control to count down (up = 0)
        up = 0;
        
        // Wait for a few clock cycles (20 ns)
        #20;
        
        // Apply reset once more
        reset = 1;
        #10 reset = 0;
        
        // Wait for 100 ns, then set up to count up again
        #100 up = 1;

        // Finish simulation
        $finish;
    end

endmodule
