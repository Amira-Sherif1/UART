module Baud_Gen(

input clk ,
input reset,
input [2:0] Baud_Sel ,
output reg Tx_clk ,
output reg Rx_clk 
);

parameter freq = 50_000_000 ; 

reg [12:0] Tx_k ; 
reg [9:0] Rx_k ;
reg [12:0] Tx_counter = 0 ; 
reg [9:0] Rx_counter = 0  ;

always@(*) begin 
case(Baud_Sel)
	3'b000: Tx_k = freq / (2*9600);  // 5208
	3'b001: Tx_k = freq / (2*19200);
	3'b010: Tx_k = freq / (2*38400);
	3'b011: Tx_k = freq / (2*57600);
	3'b100: Tx_k = freq / (2*115200);
	default:Tx_k = freq / (2*115200);

endcase
 Rx_k = Tx_k / 8 ;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
       Tx_counter <= 0 ;
       Tx_clk <= 0 ; 
    end
    else begin
	if(Tx_counter == Tx_k -1 ) begin
	   Tx_clk <= ~ Tx_clk ; 
	   Tx_counter <= 0 ; 
	end
	else 
	   Tx_counter <= Tx_counter +1  ; 
	end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
       Rx_counter <= 0 ;
       Rx_clk <= 0 ; 
    end
    else begin
	if(Rx_counter == Rx_k -1) begin
	   Rx_clk <= ~ Rx_clk ; 
	   Rx_counter <= 0 ; 
	end
	else 
	   Rx_counter <= Rx_counter +1  ; 
	end 
end
endmodule  
 
 
