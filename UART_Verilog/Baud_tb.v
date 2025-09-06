`define clk_period 10 

module Baud_tb ; 

reg clk ; 
reg reset ;
reg [2:0] Baud_Sel ;
wire Tx_clk ;
wire Rx_clk ;


Baud_Gen baudgen (clk , reset , Baud_Sel , Tx_clk , Rx_clk ) ; 

always #(`clk_period/ 2) clk = ~clk ;

initial begin 
 
clk = 0 ;
reset = 1 ;
Baud_Sel = 3'b000 ; 

#10
reset = 0;
Baud_Sel = 3'b000;

#200000
Baud_Sel = 3'b010;

#100000
Baud_Sel = 3'b100;

#50000 
reset = 1;
reset = 0;
Baud_Sel = 3'b001;


end 

endmodule 




