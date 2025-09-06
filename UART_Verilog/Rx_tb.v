`define clckperiod 10 

module Rx_tb;

reg clk ;
reg reset ;
reg enable ;
reg in_bit ;
wire [7:0] out_reg ; 
wire busy ;
wire error ;

Rx rx (clk , reset , enable , in_bit , out_reg , busy , error);

parameter tx_clkperiod = `clckperiod * 8 ;

always #(`clckperiod / 2) clk = ~clk ;
initial begin

		clk = 0;
		reset = 1;
		enable = 0;
		in_bit = 1;

		// Wait 100 ns for global reset to finish
		#(3*tx_clkperiod) reset = 0; enable = 1;
      
		#(3*tx_clkperiod) in_bit = 0; //start
		#tx_clkperiod in_bit = 1; //Data0
		#tx_clkperiod in_bit = 0; //Data1
		#tx_clkperiod in_bit = 1; //Data2
		#tx_clkperiod in_bit = 0; //Data3
		#tx_clkperiod in_bit = 1; //Data4
		#tx_clkperiod in_bit = 0; //Data5
		#tx_clkperiod in_bit = 1; //Data6
		#tx_clkperiod in_bit = 0; //Data7
		#tx_clkperiod in_bit = 1; //Stop
		
		#tx_clkperiod in_bit = 0; //start
		#tx_clkperiod in_bit = 0; //Data0
		#tx_clkperiod in_bit = 0; //Data1
		#tx_clkperiod in_bit = 1; //Data2
		#tx_clkperiod in_bit = 1; //Data3
		#tx_clkperiod in_bit = 1; //Data4
		#tx_clkperiod in_bit = 0; //Data5
		#tx_clkperiod in_bit = 1; //Data6
		#tx_clkperiod in_bit = 0; //Data7
		#tx_clkperiod in_bit = 1; //Stop
		
		#(3*tx_clkperiod) in_bit = 0; //start
		#tx_clkperiod in_bit = 0; //Data0
		#tx_clkperiod in_bit = 0; //Data1
		#tx_clkperiod in_bit = 1; //Data2
		#tx_clkperiod in_bit = 0; //Data3
		#tx_clkperiod in_bit = 1; //Data4
		#tx_clkperiod in_bit = 0; //Data5
		#tx_clkperiod in_bit = 1; //Data6
		#tx_clkperiod in_bit = 1; //Data7
		#tx_clkperiod in_bit = 1; //Stop
		
		#(3*tx_clkperiod) in_bit = 0; //start
		
		#tx_clkperiod in_bit = 1; //Data0
		#tx_clkperiod in_bit = 0; //Data1
		#tx_clkperiod in_bit = 1; //Data2
		#tx_clkperiod in_bit = 0; enable = 0; //Data3
		#tx_clkperiod in_bit = 1; //Data4
		#tx_clkperiod in_bit = 0; //Data5
		#tx_clkperiod in_bit = 1; enable = 1; //Data6
		#tx_clkperiod in_bit = 0; //Data7
		#tx_clkperiod in_bit = 1; //Stop
		// Add stimulus here

	end




endmodule 
