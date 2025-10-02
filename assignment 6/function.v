`timescale 1ns / 1ps

module MIN_MAX_ALGORITHM (
    input s_vi,
    input takein,
    input [3:0] ai,
    input [4:0] di,
    
    input clk,

    output [3:0] ao,
    output [4:0] do_min,
    output [4:0] do,
    output vo
);
    wire s_vd;       
    wire s_vd2;         
    wire s_ceq;  
    wire s_sel_MUX_REG_CNT;  
    wire s_sel_MUX_REG_MAXA;  
    wire s_sel_MUX_REG_MAXV;  
    wire s_sel_MUX_REG_MINA;  
    wire s_sel_MUX_REG_MINV;  
    wire [1:0] s_sel_MUX_MAR; 
    wire [1:0] s_sel_MUX_MDR;
    wire s_sel_MUX_ao;
    wire s_sel_MUX_do;
    wire s_ld_REG_CNT;    
    wire s_ld_REG_MAXA;    
    wire s_ld_REG_MAXV;   
    wire s_ld_REG_MINA;   
    wire s_ld_REG_MINV;   
    wire s_ld_REG_MDR;    
    wire s_ld_REG_MAR;
    wire s_ld_REG_ONE;
    wire s_ld_REG_ceq;
    wire s_ld_REG_vd;
    wire s_sel_MUX_ADDER; 
    wire [1:0] s_sel_MUX_COMP; 
    wire read;
    wire write;

    wire [3:0] MAR_IN;
    wire [4:0] MDR_dtom; 
    wire [4:0] MDR_mtod;

    //test wires
    wire [3:0] test_REG_CNT;    
    wire [3:0] test_REG_MAXA;    
    wire [4:0] test_REG_MAXV;   
    wire [3:0] test_REG_MINA;   
    wire [4:0] test_REG_MINV;   
    wire [4:0] test_REG_MDR;    
    wire [3:0] test_REG_MAR;
    wire [3:0] test_REG_ONE;
    wire test_REG_ceq;
    wire test_REG_vd;
    wire [3:0] test_current_state;
    wire [5:0] test_memory_0;
    wire [5:0] test_memory_1;
    wire [5:0] test_memory_2;
    wire [5:0] test_memory_3;
    wire [5:0] test_memory_4;
    wire [5:0] test_memory_5;
    wire [5:0] test_memory_6;
    wire [5:0] test_memory_7;
    wire [5:0] test_memory_8;
    wire [5:0] test_memory_9;
    wire [5:0] test_memory_10;
    wire [5:0] test_memory_11;
    wire [5:0] test_memory_12;
    wire [5:0] test_memory_13;
    wire [5:0] test_memory_14;
    wire [5:0] test_memory_15;


    CONTROLLER controller_module(
        s_vi,    
        takein,     
        s_vd2,         
        s_ceq,  
        clk,       
        s_sel_MUX_REG_CNT,  
        s_sel_MUX_REG_MAXA,  
        s_sel_MUX_REG_MAXV,  
        s_sel_MUX_REG_MINA,  
        s_sel_MUX_REG_MINV,  
        s_sel_MUX_MAR, 
        s_sel_MUX_MDR,
        s_sel_MUX_ao,
        s_sel_MUX_do,
        s_ld_REG_CNT,    
        s_ld_REG_MAXA,    
        s_ld_REG_MAXV,   
        s_ld_REG_MINA,   
        s_ld_REG_MINV,   
        s_ld_REG_MDR,    
        s_ld_REG_MAR,
        s_ld_REG_ONE,
        s_ld_REG_ceq,
        s_ld_REG_vd,
        s_sel_MUX_ADDER, 
        s_sel_MUX_COMP, 
        vo,
        read,
        write,

        test_current_state
    );

    DATAPATH datapath_module (
        do, 
        do_min,
        ao, 
        s_ceq, 
        s_vd2,
        MAR_IN,
        MDR_dtom, 
        s_sel_MUX_REG_CNT,  
        s_sel_MUX_REG_MAXA,  
        s_sel_MUX_REG_MAXV,  
        s_sel_MUX_REG_MINA,  
        s_sel_MUX_REG_MINV,  
        s_sel_MUX_MAR, 
        s_sel_MUX_MDR,
        s_sel_MUX_ao,
        s_sel_MUX_do,
        s_ld_REG_CNT,    
        s_ld_REG_MAXA,    
        s_ld_REG_MAXV,   
        s_ld_REG_MINA,   
        s_ld_REG_MINV,   
        s_ld_REG_MDR,    
        s_ld_REG_MAR,
        s_ld_REG_ONE,
        s_ld_REG_ceq,
        s_ld_REG_vd,
        s_sel_MUX_ADDER, 
        s_sel_MUX_COMP, 
        clk,
        di,
        ai,
        MDR_mtod,
        s_vd,

        //test wires
        test_REG_CNT,    
        test_REG_MAXA,    
        test_REG_MAXV,   
        test_REG_MINA,   
        test_REG_MINV,   
        test_REG_MDR,    
        test_REG_MAR,
        test_REG_ONE,
        test_REG_ceq,
        test_REG_vd
    );

    MEMORY memory_module(
        clk,
        MAR_IN,  
        MDR_dtom, 
        read,  
        write, 
        MDR_mtod, 
        s_vd,        
        test_memory_0,
        test_memory_1,
        test_memory_2,
        test_memory_3,
        test_memory_4,
        test_memory_5,
        test_memory_6,
        test_memory_7,
        test_memory_8,
        test_memory_9,
        test_memory_10,
        test_memory_11,
        test_memory_12,
        test_memory_13,
        test_memory_14,
        test_memory_15
    );
    
endmodule

// FSM Module Definition
module CONTROLLER(

    input s_vi, 
    input takein,        
    input s_vd,         
    input s_ceq,  
    input clk,       
    
    //signals for all the MUX of registers 
    output reg s_sel_MUX_REG_CNT,  
    output reg s_sel_MUX_REG_MAXA,  
    output reg s_sel_MUX_REG_MAXV,  
    output reg s_sel_MUX_REG_MINA,  
    output reg s_sel_MUX_REG_MINV,  
    output reg [1:0] s_sel_MUX_MAR, 
    output reg [1:0] s_sel_MUX_MDR,

    output reg s_sel_MUX_ao,
    output reg s_sel_MUX_do,
    
    //signals for all the registers 
    output reg s_ld_REG_CNT,    
    output reg s_ld_REG_MAXA,    
    output reg s_ld_REG_MAXV,   
    output reg s_ld_REG_MINA,   
    output reg s_ld_REG_MINV,   
    output reg s_ld_REG_MDR,    
    output reg s_ld_REG_MAR,
    output reg s_ld_REG_ONE,
    output reg s_ld_REG_ceq,
    output reg s_ld_REG_vd,

    //signals for all the MUX of functional unit 
    output reg s_sel_MUX_ADDER, 
    output reg [1:0] s_sel_MUX_COMP, 

    output reg vo,
    output reg read,
    output reg write,

    output [3:0] test_current_state


    );

    reg [3:0] current_state = 4'b0000; 
    reg [3:0] next_state; reg ovr;     

    always @(posedge clk)
        begin
            current_state <= next_state;
            // $display("[%t] State: %b", $time, next_state);
        end
        
    always @(current_state, s_vi, s_vd, s_ceq)
        begin

            case (current_state)
                4'b0000: begin
                    if (s_vi & takein) next_state = 4'b0001;   // q0' = 1 when s_vi is 1
                    else if (s_vi & ~takein) next_state = 4'b1101; 
                    else next_state = 4'b0000;         // q0' = 0 otherwise
                    ovr <= 0;
                end
                
                4'b1101: begin
                    if (takein) next_state = 4'b0001;   // q0' = 1 when s_vi is 1
                    else next_state = 4'b1101;         // q0' = 0 otherwise
                end
                
                4'b0001: begin
                    if (s_vi & takein) next_state = 4'b0001;
                    else if (s_vi & ~takein) next_state = 4'b1101;    // q0' = 1 when s_vi is 1
                    else next_state = 4'b1000;         // q0' = 0 otherwise
                end
                
                4'b1000: begin
                    next_state = 4'b0010;             // q0' = 1 for this transition
                end
                
                4'b0010: begin // 2 -> 12
                    next_state = 4'b1100;             // q0' = 0 otherwise
                end
                
                4'b1100: begin //12 -> 4 or 3
                    if (s_vd) next_state = 4'b0100;  // q0' = 1 for s_ceq transition
                    else next_state = 4'b0011;        // q0' = 1 for this transition
                end
                
                4'b0100: begin
                    next_state = 4'b0101;             // q0' = 1 for this transition
                end
                4'b0101: begin
                    next_state = 4'b1010;             // q0' = 1 for this transition
                end
                
                4'b1010: begin // 10 -> 3
                    next_state = 4'b0011;             // q0' = 1 for this transition
                end
                
                4'b0011: begin //3
                    next_state = 4'b1001;             // q0' = 1 for this transition
                end
                
                4'b1001: begin /// 9 -> 6 or 2
                    if (s_ceq & ovr ) next_state = 4'b0110;   // q0' = 1 for s_vi transition
                    else begin next_state <= 4'b0010; ovr <= 1; end         // q0' = 0 otherwise
                end
                
                4'b0110: begin // 6 -> 7
                    next_state = 4'b0111;             // q0' = 1 for this transition
                end
                
                4'b0111: begin // 7 -> 11
                    next_state = 4'b0111;             // q0' = 1 for this transition
                end
                
                4'b1011: begin // 11 -> 11
                    next_state = 4'b1011;             // q0' = 0 for this transition
                end
                
                default: begin
                    next_state = 4'b0000;             // Default state in case of any unknown state
                end
            endcase

            case(current_state) 
                // Start state
                4'b0000 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 1;    
                    s_ld_REG_MAXA = 1;    
                    s_ld_REG_MAXV = 1;   
                    s_ld_REG_MINA = 1;   
                    s_ld_REG_MINV = 1;   
                    s_ld_REG_MDR = 1;    
                    s_ld_REG_MAR = 1;
                    s_ld_REG_ONE = 1;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;


                end

                // Input state
                4'b0001 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 1;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b01; 
                    s_sel_MUX_MDR = 2'b01; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 1;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 1;    
                    s_ld_REG_MAR = 1;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 1;

                end

                // Loop state 2 
                4'b0010 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b10; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 1;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 1;
                    s_ld_REG_vd = 1;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 1;
                    write = 0;

                end

                // MAR ADD state
                4'b0011 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b10; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 1;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 1; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end

                // COMP1 state
                4'b0100 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 1;  
                    s_sel_MUX_REG_MAXV = 1; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 1;    
                    s_ld_REG_MAXV = 1;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b01;

                    vo = 0;
                    read = 0;
                    write = 0;

                end

                // COMP2 state
                4'b0101 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 1; 
                    s_sel_MUX_REG_MINV = 1; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 1;   
                    s_ld_REG_MINV = 1;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b10; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end


                // OUT1 state
                4'b0110 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 1;
                    read = 0;
                    write = 0;

                end

                // OUT2 state
                4'b0111 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 1;
                    s_sel_MUX_do = 1;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 1;
                    read = 0;
                    write = 0;

                end

                // inputnext state 8 
                4'b1000 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b11; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 1;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end

                // check idle state 9
                4'b1001 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end

                // check idle state 10
                4'b1010 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end

                // stop idle state 11
                4'b1011 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 0;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end
                
                //  state 12
                4'b1100 : begin 
                    //signals for all the MUX of registers 
                    s_sel_MUX_REG_CNT = 0;  
                    s_sel_MUX_REG_MAXA = 0;  
                    s_sel_MUX_REG_MAXV = 0; 
                    s_sel_MUX_REG_MINA = 0; 
                    s_sel_MUX_REG_MINV = 0; 
                    s_sel_MUX_MAR = 2'b00; 
                    s_sel_MUX_MDR = 2'b00; 

                    s_sel_MUX_ao = 0;
                    s_sel_MUX_do = 0;            

                    //signals for all the registers 
                    s_ld_REG_CNT = 0;    
                    s_ld_REG_MAXA = 0;    
                    s_ld_REG_MAXV = 0;   
                    s_ld_REG_MINA = 0;   
                    s_ld_REG_MINV = 0;   
                    s_ld_REG_MDR = 0;    
                    s_ld_REG_MAR = 0;
                    s_ld_REG_ONE = 0;
                    s_ld_REG_ceq = 0;
                    s_ld_REG_vd = 1;

                    //signals for all the MUX of functional unit 
                    s_sel_MUX_ADDER = 0; 
                    s_sel_MUX_COMP = 2'b00; 

                    vo = 0;
                    read = 0;
                    write = 0;

                end

            endcase
            
        end

        assign test_current_state = current_state;
       
endmodule

module DATAPATH(
    output [4:0] do, 
    output [4:0] do_min, 
    output [3:0] ao, 
    output ceq, 
    output vd, 
    output [3:0] MAR_OUT,
    output [4:0] MDR_OUT, // can be reg as well
    
    //signals for all the MUX of registers 
    input s_sel_MUX_REG_CNT,  
    input s_sel_MUX_REG_MAXA,  
    input s_sel_MUX_REG_MAXV,  
    input s_sel_MUX_REG_MINA,  
    input s_sel_MUX_REG_MINV,  
    input [1:0] s_sel_MUX_MAR, 
    input [1:0] s_sel_MUX_MDR,

    input s_sel_MUX_ao,
    input s_sel_MUX_do,
    
    //signals for all the registers 
    input s_ld_REG_CNT,    
    input s_ld_REG_MAXA,    
    input s_ld_REG_MAXV,   
    input s_ld_REG_MINA,   
    input s_ld_REG_MINV,   
    input s_ld_REG_MDR,    
    input s_ld_REG_MAR,
    input s_ld_REG_ONE,
    input s_ld_REG_ceq,
    input s_ld_REG_vd,
    

    //signals for all the MUX of functional unit 
    input s_sel_MUX_ADDER, 
    input [1:0] s_sel_MUX_COMP, 

    input clk,

    input [4:0] di,
    input [3:0] ai,

    //input from memory
    input [4:0] MDR_IN,
    input s_vd,


    output [3:0] test_REG_CNT,    
    output [3:0] test_REG_MAXA,    
    output [4:0] test_REG_MAXV,   
    output [3:0] test_REG_MINA,   
    output [4:0] test_REG_MINV,   
    output [4:0] test_REG_MDR,    
    output [3:0] test_REG_MAR,
    output [3:0] test_REG_ONE,
    output test_REG_ceq,
    output test_REG_vd


);
    //wire of all outputs of REG
    wire [3:0] REG_CNT_OUT;   
    wire [3:0] REG_MAXA_OUT;   
    wire [4:0] REG_MAXV_OUT;  
    wire [3:0] REG_MINA_OUT;  
    wire [4:0] REG_MINV_OUT;  
    wire [4:0] REG_MDR_OUT;   
    wire [3:0] REG_MAR_OUT;
    wire [3:0] REG_ONE_OUT;
    wire REG_ceq_OUT;
    wire REG_vd_OUT;

    //wire for all the MUX of registers 
    wire [3:0] MUX_REG_CNT_OUT;  
    wire [3:0] MUX_REG_MAXA_OUT;  
    wire [4:0] MUX_REG_MAXV_OUT;  
    wire [3:0] MUX_REG_MINA_OUT;  
    wire [4:0] MUX_REG_MINV_OUT;  
    wire [3:0] MUX_MAR_OUT; 
    wire [4:0] MUX_MDR_OUT;

    wire [3:0] MUX_ao_OUT;
    wire [4:0] MUX_do_OUT;

    wire [3:0] MUX_ADDER_OUT; 
    wire [4:0] MUX_1_COMP_OUT;
    wire [4:0] MUX_2_COMP_OUT;

    wire [3:0] MUX_2_REG_MAXA_OUT;    
    wire [4:0] MUX_2_REG_MAXV_OUT;    
    wire [3:0] MUX_2_REG_MINA_OUT;    
    wire [4:0] MUX_2_REG_MINV_OUT; 

    wire [4:0] ADDER_OUT;
    wire COMP_eq_OUT;
    wire COMP_eq2_OUT;
    wire COMP_g_OUT;

    register #(4) REG_CNT(REG_CNT_OUT, MUX_REG_CNT_OUT, clk, s_ld_REG_CNT);
    register #(4) REG_MAXA(REG_MAXA_OUT, MUX_REG_MAXA_OUT, clk, s_ld_REG_MAXA);
    register #(5) REG_MAXV(REG_MAXV_OUT, MUX_REG_MAXV_OUT, clk, s_ld_REG_MAXV);
    register #(4) REG_MINA(REG_MINA_OUT, MUX_REG_MINA_OUT, clk, s_ld_REG_MINA);
    register #(5) REG_MINV(REG_MINV_OUT, MUX_REG_MINV_OUT, clk, s_ld_REG_MINV);
    register #(4) REG_MAR(REG_MAR_OUT, MUX_MAR_OUT, clk, s_ld_REG_MAR);
    register #(5) REG_MDR(REG_MDR_OUT, MUX_MDR_OUT, clk, s_ld_REG_MDR);
    register #(4) REG_ONE(REG_ONE_OUT, 4'b0001, clk, s_ld_REG_ONE);
    register #(1) REG_ceq(REG_ceq_OUT, COMP_eq2_OUT, clk, s_ld_REG_ceq);
    register #(1) REG_vd(REG_vd_OUT, s_vd, clk, s_ld_REG_vd);

    mux2to1_4bit MUX_CNT(4'b0000, ADDER_OUT, s_sel_MUX_REG_CNT, MUX_REG_CNT_OUT);
    mux2to1_4bit MUX_MAXA(4'b0000, MUX_2_REG_MAXA_OUT, s_sel_MUX_REG_MAXA, MUX_REG_MAXA_OUT);
    mux2to1_5bit MUX_MAXV(5'b00000, MUX_2_REG_MAXV_OUT, s_sel_MUX_REG_MAXV, MUX_REG_MAXV_OUT);
    mux2to1_4bit MUX_MINA(4'b0000, MUX_2_REG_MINA_OUT, s_sel_MUX_REG_MINA, MUX_REG_MINA_OUT);
    mux2to1_5bit MUX_MINV(5'b11111, MUX_2_REG_MINV_OUT, s_sel_MUX_REG_MINV, MUX_REG_MINV_OUT);

    mux4to1_4bit MUX_MAR(ai, ai, ADDER_OUT, 4'b0000, s_sel_MUX_MAR, MUX_MAR_OUT);
    mux4to1_5bit MUX_MDR(di, di, MDR_IN, 5'b00000, s_sel_MUX_MDR, MUX_MDR_OUT);

    wire [3:0] refinedmar;
    assign refinedmar = REG_MAR_OUT - 1'b1;
    mux2to1_4bit MUX_2_MAXA(refinedmar, REG_MAXA_OUT, COMP_g_OUT, MUX_2_REG_MAXA_OUT);
    mux2to1_5bit MUX_2_MAXV(REG_MDR_OUT, REG_MAXV_OUT, COMP_g_OUT, MUX_2_REG_MAXV_OUT);
    mux2to1_4bit MUX_2_MINA(REG_MINA_OUT, refinedmar, COMP_g_OUT, MUX_2_REG_MINA_OUT);
    mux2to1_5bit MUX_2_MINV(REG_MINV_OUT, REG_MDR_OUT, COMP_g_OUT, MUX_2_REG_MINV_OUT);

    mux2to1_4bit MUX_ADDER(REG_CNT_OUT, REG_MAR_OUT, s_sel_MUX_ADDER, MUX_ADDER_OUT);
    mux4to1_5bit MUX_1_COMP( 5'b00000, REG_MAXV_OUT, REG_MINV_OUT, 5'b00000, s_sel_MUX_COMP, MUX_1_COMP_OUT);
    mux4to1_5bit MUX_2_COMP(5'b00000, REG_MDR_OUT, REG_MDR_OUT, 5'b00000, s_sel_MUX_COMP, MUX_2_COMP_OUT);

    adder_4bit ADDER(MUX_ADDER_OUT, REG_ONE_OUT, ADDER_OUT);
    comparator_5bit COMP(MUX_1_COMP_OUT, MUX_2_COMP_OUT, COMP_eq_OUT, COMP_g_OUT);
    comparator_4bit COMP2(REG_MAR_OUT, 4'B0000 , COMP_eq2_OUT);

    mux2to1_4bit MUX_ao(REG_MINA_OUT, REG_MAXA_OUT, s_sel_MUX_ao, MUX_ao_OUT);
    mux2to1_5bit MUX_do(REG_MINV_OUT, REG_MAXV_OUT, s_sel_MUX_do, MUX_do_OUT);


    //assigning output
    assign ao = MUX_ao_OUT;
    assign do = MUX_do_OUT;
    assign do_min = REG_MINV_OUT;
    assign ceq = REG_ceq_OUT;
    assign vd = REG_vd_OUT;
    assign MAR_OUT = REG_MAR_OUT;
    assign MDR_OUT = REG_MDR_OUT;

    //assigning to test wires:
    assign test_REG_CNT = REG_CNT_OUT;
    assign test_REG_MAXA = REG_MAXA_OUT;
    assign test_REG_MAXV = REG_MAXV_OUT;
    assign test_REG_MINA = REG_MINA_OUT;
    assign test_REG_MINV = REG_MINV_OUT; 
    assign test_REG_MDR = REG_MDR_OUT;    
    assign test_REG_MAR = REG_MAR_OUT;
    assign test_REG_ONE = REG_ONE_OUT;
    assign test_REG_ceq = REG_ceq_OUT;
    assign test_REG_vd = REG_vd_OUT;

endmodule

module MEMORY (
    input wire clk,
    input wire [3:0] REG_MAR,  // Memory Address Register (4-bit for 16 locations)
    input wire [4:0] REG_MDR, // Memory Data Register input (5-bit data)
    input wire read,  // Read signal
    input wire write, // Write signal
    output reg [4:0] MDR_out, // Memory Data Register output
    output reg s_vd, // Valid bit output
   
    output [5:0] test_memory_0,
    output [5:0] test_memory_1,
    output [5:0] test_memory_2,
    output [5:0] test_memory_3,
    output [5:0] test_memory_4,
    output [5:0] test_memory_5,
    output [5:0] test_memory_6,
    output [5:0] test_memory_7,
    output [5:0] test_memory_8,
    output [5:0] test_memory_9,
    output [5:0] test_memory_10,
    output [5:0] test_memory_11,
    output [5:0] test_memory_12,
    output [5:0] test_memory_13,
    output [5:0] test_memory_14,
    output [5:0] test_memory_15
  
);

    // Memory array: 16 locations, each storing 5-bit data + 1-bit valid
    reg [5:0] memory [15:0]; // {valid bit, 5-bit data}
    integer i;
    initial begin
            // Initialize all memory locations to {valid bit = 0, data = 5'b00000}
            
            for (i = 0; i < 16; i = i + 1) begin
                memory[i] = {1'b0, 5'b00000}; // Set valid bit to 0 and data to 00000
            end
    end
    
    always @(posedge clk) begin
        if (write) 
            memory[REG_MAR] <= {1'b1, REG_MDR}; // Store data and set valid bit to 1
        
        else if (read) 
            {s_vd, MDR_out} <= memory[REG_MAR]; // Read data and valid bit
        
        else ;
    end
    
    assign test_memory_0 = memory[0];
    assign test_memory_1= memory[1];
    assign test_memory_2= memory[2];
    assign test_memory_3= memory[3];
    assign test_memory_4= memory[4];
    assign test_memory_5= memory[5];
    assign test_memory_6= memory[6];
    assign test_memory_7= memory[7];
    assign test_memory_8= memory[8];
    assign test_memory_9= memory[9];
    assign test_memory_10= memory[10];
    assign test_memory_11= memory[11];
    assign test_memory_12= memory[12];
    assign test_memory_13= memory[13];
    assign test_memory_14= memory[14];
    assign test_memory_15 = memory[15];

endmodule 

module register #(
    parameter WIDTH = 4  // Default parameter value is 4
)(
    output reg [WIDTH-1:0] out,  // Output width depends on parameter
    input [WIDTH-1:0] in,        // Input width depends on parameter
    input clock,
    input writing_enable
);

    // Initialize the output to 0 at the start of simulation
    initial begin
        out = {WIDTH{1'b0}};  // Set all bits of the output to 0
    end

    always @(posedge clock) begin
        if (writing_enable) begin
            out <= in;  // Store input in output
        end
    end
endmodule

module mux2to1_4bit (
    input wire [3:0] A,  // 4-bit input A
    input wire [3:0] B,  // 4-bit input B
    input wire sel,       // Select signal
    output wire [3:0] Y   // 4-bit output Y
);
    wire sel_n;           // Complement of select signal
    wire [3:0] and_A, and_B; // Intermediate AND outputs

    // Generate NOT gate for select signal
    not(sel_n, sel);

    // Generate AND gates for each bit
    and(and_A[0], A[0], sel_n);
    and(and_A[1], A[1], sel_n);
    and(and_A[2], A[2], sel_n);
    and(and_A[3], A[3], sel_n);

    and(and_B[0], B[0], sel);
    and(and_B[1], B[1], sel);
    and(and_B[2], B[2], sel);
    and(and_B[3], B[3], sel);

    // Generate OR gates to combine results
    or(Y[0], and_A[0], and_B[0]);
    or(Y[1], and_A[1], and_B[1]);
    or(Y[2], and_A[2], and_B[2]);
    or(Y[3], and_A[3], and_B[3]);

endmodule


module mux2to1_5bit (
    input wire [4:0] A,  // 5-bit input A
    input wire [4:0] B,  // 5-bit input B
    input wire sel,       // Select signal
    output wire [4:0] Y   // 5-bit output Y
);
    wire sel_n;
    wire [4:0] nA, nB;

    not (sel_n, sel);

    and (nA[0], A[0], sel_n), (nA[1], A[1], sel_n), (nA[2], A[2], sel_n), (nA[3], A[3], sel_n), (nA[4], A[4], sel_n);
    and (nB[0], B[0], sel), (nB[1], B[1], sel), (nB[2], B[2], sel), (nB[3], B[3], sel), (nB[4], B[4], sel);

    or (Y[0], nA[0], nB[0]), (Y[1], nA[1], nB[1]), (Y[2], nA[2], nB[2]), (Y[3], nA[3], nB[3]), (Y[4], nA[4], nB[4]);

endmodule


module mux4to1_4bit (
    input wire [3:0] A,  
    input wire [3:0] B,  
    input wire [3:0] C,  
    input wire [3:0] D,  
    input wire [1:0] sel,  
    output wire [3:0] Y   
);

    wire [3:0] nA, nB, nC, nD;  
    wire s0, s1, ns0, ns1;  

    not (ns0, sel[0]);  
    not (ns1, sel[1]);  

    and (nA[0], A[0], ns1, ns0);
    and (nA[1], A[1], ns1, ns0);
    and (nA[2], A[2], ns1, ns0);
    and (nA[3], A[3], ns1, ns0);

    and (nB[0], B[0], ns1, sel[0]);
    and (nB[1], B[1], ns1, sel[0]);
    and (nB[2], B[2], ns1, sel[0]);
    and (nB[3], B[3], ns1, sel[0]);

    and (nC[0], C[0], sel[1], ns0);
    and (nC[1], C[1], sel[1], ns0);
    and (nC[2], C[2], sel[1], ns0);
    and (nC[3], C[3], sel[1], ns0);

    and (nD[0], D[0], sel[1], sel[0]);
    and (nD[1], D[1], sel[1], sel[0]);
    and (nD[2], D[2], sel[1], sel[0]);
    and (nD[3], D[3], sel[1], sel[0]);

    or (Y[0], nA[0], nB[0], nC[0], nD[0]);
    or (Y[1], nA[1], nB[1], nC[1], nD[1]);
    or (Y[2], nA[2], nB[2], nC[2], nD[2]);
    or (Y[3], nA[3], nB[3], nC[3], nD[3]);

endmodule


module mux4to1_5bit (
    input wire [4:0] A,  
    input wire [4:0] B,  
    input wire [4:0] C,  
    input wire [4:0] D,  
    input wire [1:0] sel,  
    output wire [4:0] Y   
);

    wire [4:0] nA, nB, nC, nD;  
    wire s0, s1, ns0, ns1;  

    not (ns0, sel[0]);  
    not (ns1, sel[1]);  

    and (nA[0], A[0], ns1, ns0);
    and (nA[1], A[1], ns1, ns0);
    and (nA[2], A[2], ns1, ns0);
    and (nA[3], A[3], ns1, ns0);
    and (nA[4], A[4], ns1, ns0);

    and (nB[0], B[0], ns1, sel[0]);
    and (nB[1], B[1], ns1, sel[0]);
    and (nB[2], B[2], ns1, sel[0]);
    and (nB[3], B[3], ns1, sel[0]);
    and (nB[4], B[4], ns1, sel[0]);

    and (nC[0], C[0], sel[1], ns0);
    and (nC[1], C[1], sel[1], ns0);
    and (nC[2], C[2], sel[1], ns0);
    and (nC[3], C[3], sel[1], ns0);
    and (nC[4], C[4], sel[1], ns0);

    and (nD[0], D[0], sel[1], sel[0]);
    and (nD[1], D[1], sel[1], sel[0]);
    and (nD[2], D[2], sel[1], sel[0]);
    and (nD[3], D[3], sel[1], sel[0]);
    and (nD[4], D[4], sel[1], sel[0]);

    or (Y[0], nA[0], nB[0], nC[0], nD[0]);
    or (Y[1], nA[1], nB[1], nC[1], nD[1]);
    or (Y[2], nA[2], nB[2], nC[2], nD[2]);
    or (Y[3], nA[3], nB[3], nC[3], nD[3]);
    or (Y[4], nA[4], nB[4], nC[4], nD[4]);

endmodule


module full_adder (
    input wire a,  
    input wire b,  
    input wire cin,  
    output wire sum,  
    output wire cout  
);
    wire axb, and1, and2;

    xor (axb, a, b);
    xor (sum, axb, cin);
    and (and1, axb, cin);
    and (and2, a, b);
    or (cout, and1, and2);
endmodule

module adder_4bit (
    input wire [3:0] a,  
    input wire [3:0] b,  
    output wire [3:0] sum  
);
    wire c1, c2, c3;  // Carry signals

    full_adder FA0 (a[0], b[0], 1'b0, sum[0], c1);
    full_adder FA1 (a[1], b[1], c1, sum[1], c2);
    full_adder FA2 (a[2], b[2], c2, sum[2], c3);
    full_adder FA3 (a[3], b[3], c3, sum[3], );

endmodule




module comparator_5bit (
    input wire [4:0] a,  
    input wire [4:0] b,  
    output wire ceq,  
    output wire cg   
);
    wire x0, x1, x2, x3, x4;  // XNOR outputs for equality check
    wire g4, g3, g2, g1, g0;  // Greater-than detection per bit
    wire eq4_0, n_b4, n_b3, n_b2, n_b1, n_b0; // Complement of b

    // XNOR gates for equality comparison
    xnor (x0, a[0], b[0]);
    xnor (x1, a[1], b[1]);
    xnor (x2, a[2], b[2]);
    xnor (x3, a[3], b[3]);
    xnor (x4, a[4], b[4]);

    // AND gate for full equality check
    and (eq4_0, x0, x1, x2, x3, x4);
    assign ceq = eq4_0;

    // NOT gates using NAND (to avoid ~ operator)
    nand (n_b4, b[4], b[4]);
    nand (n_b3, b[3], b[3]);
    nand (n_b2, b[2], b[2]);
    nand (n_b1, b[1], b[1]);
    nand (n_b0, b[0], b[0]);

    // Greater-than logic using priority checking
    and (g3, x4, a[3], n_b3);  
    and (g2, x4, x3, a[2], n_b2);  
    and (g1, x4, x3, x2, a[1], n_b1);  
    and (g0, x4, x3, x2, x1, a[0], n_b0);  

    or (cg, a[4], g3, g2, g1, g0);  

endmodule


module comparator_4bit (
    input wire [3:0] a,  
    input wire [3:0] b,  
    output wire ceq  
);
    wire x0, x1, x2, x3;  // XOR outputs for each bit

    // XOR gates to compare each bit
    xnor (x0, a[0], b[0]);
    xnor (x1, a[1], b[1]);
    xnor (x2, a[2], b[2]);
    xnor (x3, a[3], b[3]);

    // AND gate to ensure all bits are equal
    and (ceq, x0, x1, x2, x3);

endmodule
















// 0000 , 1XX > 0001
// 0000 , 0XX > 0000
// 0001 , 1XX > 0001
// 0001 , 0XX > 1000
// 1000 , 0xx > 0010
// 0010 , 00x > 0011
// 0010 , 01x > 0100
// 0100 , 0xx > 0101
// 0101 , 0xx > 1010
// 1010 , 0xx > 0011
// 0011 , 0xx > 1001
// 1001 , 0x0 > 0010
// 1001 , 0x1 > 0110
// 0110 , 0xx > 0111
// 0111 , 0xx > 1011
// 1011 , 0xx > 0000