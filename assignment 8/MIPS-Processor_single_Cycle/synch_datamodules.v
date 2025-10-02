module data_mem #(parameter L = 256)(clk,address,read_data, write_data, read_en, write_en);
  //synchronous memory with 256 32-bit locations

  parameter S=32; 


  input [$clog2(L) - 1:0] address;
  input [S-1:0] write_data;
  input clk;
  input write_en;
  input read_en;
  output [(S-1):0] read_data;

  reg [S-1:0] memory [L-1:0];

    assign read_data=memory[address/4];
    
  always @(posedge clk) begin
    if (write_en==1) begin
        memory[address/4]<=write_data;
    end
  end

  // the current program doesn't require the data memory to be loaded
  // initial $readmemh("memdata.dat", memory);

  

endmodule




module reg_file (
  input         clk,
  input         reset,
  input         write_en,
  input  [4:0]  read_reg1,
  input  [4:0]  read_reg2,
  input  [4:0]  write_reg,
  input  [31:0] write_data,
  output [31:0] read_data1,
  output [31:0] read_data2
);
  wire [31:0]        write_decode; 
  wire [1023:0]      regs_flat;     // 32×32-bit wide

  // one-hot decode
  decoder5to32 dec (
    .in  (write_reg),
    .en  (write_en),
    .out (write_decode)
  );

  // 32× register32 instances, each hooked to a 32‑bit slice
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : regs
      register32 r (
        .clk     (clk),
        .reset   (reset),
        .write_en(write_decode[i]),
        .d       (write_data),
        .q       (regs_flat[i*32 +: 32])
      );
    end
  endgenerate

  // two read ports via the same flattened‐bus mux
  mux32_1 m1 (
    .in_flat(regs_flat),
    .sel    (read_reg1),
    .out    (read_data1)
  );
  mux32_1 m2 (
    .in_flat(regs_flat),
    .sel    (read_reg2),
    .out    (read_data2)
  );
endmodule





module PC (
  input clk,
  input reset,  // Active high reset
  input en,
  input [31:0] d,
  output reg [31:0] q
);
  
  // Internal wire for next state logic
  wire [31:0] next_q;
  
  // Next state logic with enable functionality
  assign next_q = en ? d : q;
  
  // D flip-flop implementation with synchronous active-high reset
  always @(posedge clk) begin
    if (reset)
      q <= 32'b0;
    else
      q <= next_q;
  end
  
endmodule