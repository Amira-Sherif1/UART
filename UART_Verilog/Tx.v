module Tx(
    input clk, 
    input enable,
    input reset,
    input load,
    input [7:0] data_in,
    output reg data_out, 
    output reg busy,
    output reg error 
);

reg [2:0] data_counter;
reg [7:0] data_trans;

parameter Idle  = 2'b00;
parameter Start = 2'b01;
parameter Data  = 2'b10;
parameter Stop  = 2'b11;

reg [1:0] State = Idle;

always @(posedge clk or posedge reset) begin 
    if (reset) begin 
        data_out     <= 1;
        error        <= 0;      
        data_counter <= 0;
        data_trans   <= 0;
        busy         <= 0;
        State        <= Idle;
    end
    else begin 
        case (State)
            // ----------------- IDLE -----------------
            Idle: begin 
                if (enable && load) begin
                    data_out     <= 0;           // start bit
                    busy         <= 1;
                    error        <= 0;
                    data_trans   <= data_in;     // load data
                    data_counter <= 0;
                    State        <= Start; 
                end
                else begin
                    data_out     <= 1;
                    busy         <= 0;
                    error        <= 0;           // No error in Idle
                    data_counter <= 0;
                    State        <= Idle; 
                end
            end

            // ----------------- START -----------------
            Start: begin
                if (enable) begin
                    data_out     <= data_trans[0];
                    data_counter <= 1;           
                    busy         <= 1;
                    error        <= 0;
                    State        <= Data; 
                end
                else begin
                    data_out     <= 1;
                    busy         <= 0;
                    error        <= 1;           
                    data_counter <= 0;           
                    State        <= Idle; 
                end
            end

            // ----------------- DATA -----------------
            Data: begin
                if (enable && data_counter < 7) begin   
                    data_out     <= data_trans[data_counter];
                    data_counter <= data_counter + 1;
                    busy         <= 1;
                    error        <= 0;
                    State        <= Data; 
                end
                else if (enable && data_counter == 7) begin
                    data_out     <= data_trans[7];   
                    busy         <= 1;  
                    error        <= 0;
                    State        <= Stop;          
                end
                else begin
                    data_out     <= 1;
                    busy         <= 0;
                    error        <= 1;               
                    data_counter <= 0;             
                    State        <= Idle; 
                end
            end

            // ----------------- STOP -----------------
            Stop: begin
                data_out     <= 1;                 
                busy         <= 0;
                data_counter <= 0;
		data_trans <= 0 ;
                if (enable && load) begin
                    data_trans   <= data_in;        
                    data_out     <= 0;               
                    busy         <= 1;
                    error        <= 0;
                    State        <= Start;         
                end
                else begin 
                    State        <= Idle;           
                end
            end
        endcase
    end
end
endmodule
