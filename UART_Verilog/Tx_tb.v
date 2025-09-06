`timescale 1ns/1ps
`define clkperiod 10

module tb_Tx;

  
    reg clk;
    reg enable;
    reg reset;
    reg load;
    reg [7:0] data_in;
    wire data_out;
    wire busy;
    wire error;

    
    Tx dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .load(load),
        .data_in(data_in),
        .data_out(data_out),
        .busy(busy),
        .error(error)
    );

    
    always #(`clkperiod/2) clk = ~clk;

    initial begin
       
        clk = 0;
        reset = 1;
        enable = 0;
        load = 0;
        data_in = 8'b0;

      
        #20 reset = 0;
        #20;

        
        data_in = 8'hA5;
        enable  = 1;
        load    = 1;
        #10 load = 0;
        #200;

      
        data_in = 8'h3C;
        load    = 1;
        #10 load = 0;
        #200;

        
        data_in = 8'h00;
        load    = 1;
        #10 load = 0;
        #200;

        
        data_in = 8'hFF;
        load    = 1;
        #10 load = 0;
        #200;

       
        data_in = 8'h55;
        load    = 1;
        #10 load = 0;
        #40 reset = 1;
        #20 reset = 0;
        #100;

        
        data_in = 8'hAA;
        load    = 1;
        #10 load = 0;
        #40 enable = 0;   
        #100 enable = 1;  
        #100;

       
        data_in = 8'h12;
        load    = 1;
        #10 load = 0;
        #120;

        data_in = 8'h34;
        load    = 1;
        #10 load = 0;
        #120;

        data_in = 8'h56;
        load    = 1;
        #10 load = 0;
        #200;

        $stop;
    end

endmodule

