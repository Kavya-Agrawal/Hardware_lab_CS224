`timescale 1ns / 1ps

module tb_top_MIPS();
  reg clk;
  reg reset;
  
  top_MIPS uut (.reset(reset), .clk(clk));
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    
    // Monitor register/memory writes in real-time
    $display("=== Simulation Started ===");
    
    // Release reset after 20ns
    #20 reset = 0;
    
    // Display header
    $display("Time(ns) | Operation | Address/Reg | Value");
    $display("-----------------------------------------");
    
    // Monitor control signals and display changes
    forever begin
      @(posedge clk) begin
        // Register write monitoring
        if (uut.ctrl.RegWrite) begin
          $display("%8t | REG WRITE | R%-2d         | %h", 
                  $time, uut.datapath.write_reg_final, 
                  uut.datapath.write_data);
        end
        
        // Memory write monitoring
        if (uut.ctrl.MemWrite) begin
          $display("%8t | MEM WRITE | 0x%h | %h", 
                  $time, uut.datapath.ALU_result, 
                  uut.datapath.reg_read_data2);
        end
      end
    end
  end

  initial begin
    #920;  // Match original simulation duration
    $display("\n=== Final State ===");
    
    // Display register contents
    $display("Register File Contents:");
    for(integer i=0; i<32; i++) begin
      if(uut.datapath.Registers.regs[i].r.q != 0) begin
        $display("R%-2d = %h", i, uut.datapath.Registers.regs[i].r.q);
      end
    end
    
    // Display memory contents
    $display("\nData Memory Contents:");
    for(integer j=0; j<16; j++) begin  // Display first 16 locations
      $display("Mem[%2d] = %h", j, uut.datapath.Data_Memory.memory[j]);
    end
    
    $display("\n=== Simulation Completed ===");
    $finish;
  end
endmodule