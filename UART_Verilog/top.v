module top(
input clk ,
input baud_reset ,
input tx_reset ,
input rx_reset ,
input [2:0] Baud_Sel ,
input tx_enable ,
input rx_enable ,
input load ,
input [7:0] data_in,
output  tx_busy,
output rx_busy,
output  tx_error ,output  rx_error ,
output  [7:0] out_reg
);

 wire Tx_clk ;
 wire Rx_clk ;
 wire tx_data_out ;

Baud_Gen baud(
clk ,
baud_reset,
Baud_Sel ,
Tx_clk ,
Rx_clk 
);


Tx tx(
     Tx_clk, 
     tx_enable,
     tx_reset,
     load,
     data_in,
     tx_data_out, 
     tx_busy,   
     tx_error   
);

Rx rx(
 Rx_clk ,
 rx_reset,
 rx_enable ,
 tx_data_out,
 out_reg, 
 rx_busy ,
 rx_error
); 

endmodule 
