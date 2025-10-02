// Top Module
module adder_top(
    input clk,
    input reset,
    input start,         // Start signal to begin operation
    input [3:0] in_data, // 4-bit input data
    input [2:0] in_select, // 3-bit select signal for input register
    input in_valid,      // Signal indicating input data is valid
    output [6:0] result, // 7-bit result output
    output ready_for_input, // Indicates system is ready for input
    output done          // Indicates computation is complete
);
    // Internal signals for connecting controller and datapath
    wire load_input;
    wire init_acc;
    wire add_input;
    wire [2:0] input_sel;
    wire update_result;
    
    // Instantiate controller
    controller ctrl(
        .clk(clk),
        .reset(reset),
        .start(start),
        .in_valid(in_valid),
        .load_input(load_input),
        .init_acc(init_acc),
        .add_input(add_input),
        .input_sel(input_sel),
        .update_result(update_result),
        .ready_for_input(ready_for_input),
        .done(done)
    );
    
    // Instantiate datapath with ripple carry adder
    datapath dp(
        .clk(clk),
        .reset(reset),
        .in_data(in_data),
        .in_select(in_select),
        .load_input(load_input),
        .init_acc(init_acc),
        .add_input(add_input),
        .input_sel(input_sel),
        .update_result(update_result),
        .result(result)
    );
    
endmodule


// 1-bit Full Adder
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 7-bit Ripple Carry Adder
module ripple_carry_adder(
    input [6:0] a,
    input [6:0] b,
    input cin,
    output [6:0] sum,
    output cout
);
    // Intermediate carry signals
    wire [6:0] carry;
    
    // First full adder with input carry
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );
    
    // Remaining full adders
    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );
    
    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );
    
    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(carry[3])
    );
    
    full_adder fa4(
        .a(a[4]),
        .b(b[4]),
        .cin(carry[3]),
        .sum(sum[4]),
        .cout(carry[4])
    );
    
    full_adder fa5(
        .a(a[5]),
        .b(b[5]),
        .cin(carry[4]),
        .sum(sum[5]),
        .cout(carry[5])
    );
    
    full_adder fa6(
        .a(a[6]),
        .b(b[6]),
        .cin(carry[5]),
        .sum(sum[6]),
        .cout(carry[6])
    );
    
    // Final carry out
    assign cout = carry[6];
endmodule

// Controller Module
module controller(
    input clk,
    input reset,
    input start,
    input in_valid,
    output reg load_input,
    output reg init_acc,
    output reg add_input,
    output reg [2:0] input_sel,
    output reg update_result,
    output reg ready_for_input,
    output reg done
);
    // FSM States
    parameter IDLE = 3'b000;
    parameter INPUT_COLLECTION = 3'b001;
    parameter INIT_ACC = 3'b010;
    parameter ADD_INPUTS = 3'b011;
    parameter FINALIZE = 3'b100;
    
    reg [2:0] state, next_state;
    reg [2:0] computation_counter;
    
    // State and counter registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            computation_counter <= 3'd0;
            ready_for_input <= 1'b1;
            done <= 1'b0;
        end
        else begin
            state <= next_state;
            
            case(state)
                IDLE: begin
                    computation_counter <= 3'd0;
                    ready_for_input <= 1'b1;
                    done <= 1'b0;
                end
                
                INPUT_COLLECTION: begin
                    ready_for_input <= 1'b1;
                end
                
                INIT_ACC: begin
                    ready_for_input <= 1'b0;
                    computation_counter <= 3'd1; // Start from 1 for addition phases
                end
                
                ADD_INPUTS: begin
                    if (computation_counter < 3'd7)
                        computation_counter <= computation_counter + 1'b1;
                end
                
                FINALIZE: begin
                    done <= 1'b1;
                end
            endcase
        end
    end
    
    // Control signals based on current state
    always @(*) begin
        // Default values
        load_input = 1'b0;
        init_acc = 1'b0;
        add_input = 1'b0;
        input_sel = 3'd0;
        update_result = 1'b0;
        
        case(state)
            INPUT_COLLECTION: begin
                load_input = in_valid;
            end
            
            INIT_ACC: begin
                init_acc = 1'b1;
                input_sel = 3'd0;
            end
            
            ADD_INPUTS: begin
                add_input = 1'b1;
                input_sel = computation_counter;
            end
            
            FINALIZE: begin
                update_result = 1'b1;
            end
        endcase
    end
    
    // Next state logic
    always @(*) begin
        case(state)
            IDLE: 
                next_state = start ? INPUT_COLLECTION : IDLE;
                
            INPUT_COLLECTION: 
                next_state = (start && ready_for_input) ? INIT_ACC : INPUT_COLLECTION;
                
            INIT_ACC:
                next_state = ADD_INPUTS;
                
            ADD_INPUTS:
                next_state = (computation_counter == 3'd7) ? FINALIZE : ADD_INPUTS;
                
            FINALIZE:
                next_state = IDLE;
                
            default: 
                next_state = IDLE;
        endcase
    end

endmodule

// Datapath Module with Ripple Carry Adder
module datapath(
    input clk,
    input reset,
    input [3:0] in_data,
    input [2:0] in_select,
    input load_input,
    input init_acc,
    input add_input,
    input [2:0] input_sel,
    input update_result,
    output reg [6:0] result
);
    reg [3:0] inputs [0:7];  // Storage for 8 4-bit inputs
    reg [6:0] accumulator;   // 7-bit accumulator for running sum
    
    // Signals for ripple carry adder
    wire [6:0] rca_a;
    wire [6:0] rca_b;
    wire [6:0] rca_sum;
    wire rca_cout;
    
    // Connect accumulator to RCA input A
    assign rca_a = accumulator;
    
    // Connect selected input (zero-extended) to RCA input B
    assign rca_b = {3'b000, inputs[input_sel]};
    
    // Instantiate the ripple carry adder
    ripple_carry_adder rca(
        .a(rca_a),
        .b(rca_b),
        .cin(1'b0),
        .sum(rca_sum),
        .cout(rca_cout)
    );
    
    // Input registers and accumulator logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all input registers
            inputs[0] <= 4'b0;
            inputs[1] <= 4'b0;
            inputs[2] <= 4'b0;
            inputs[3] <= 4'b0;
            inputs[4] <= 4'b0;
            inputs[5] <= 4'b0;
            inputs[6] <= 4'b0;
            inputs[7] <= 4'b0;
            accumulator <= 7'b0;
            result <= 7'b0;
        end
        else begin
            // Load input when instructed
            if (load_input)
                inputs[in_select] <= in_data;
                
            // Initialize accumulator with first input
            if (init_acc)
                accumulator <= {3'b000, inputs[0]};
                
            // Add selected input to accumulator using RCA
            if (add_input)
                accumulator <= rca_sum;
                
            // Update result register
            if (update_result)
                result <= accumulator;
        end
    end
    
endmodule

