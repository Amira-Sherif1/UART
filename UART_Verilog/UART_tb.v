`timescale 1ns/1ps

module UART_tb;

    // Testbench signals
    reg clk;
    reg baud_reset;
    reg tx_reset;
    reg rx_reset;
    reg [2:0] Baud_Sel;
    reg tx_enable;
    reg rx_enable;
    reg load;
    reg [7:0] data_in;
    wire tx_busy;
    wire rx_busy;
    wire tx_error;
    wire rx_error;
    wire [7:0] out_reg;

    // Instantiate DUT (Device Under Test)
    top uut (
        .clk(clk),
        .baud_reset(baud_reset),
        .tx_reset(tx_reset),
        .rx_reset(rx_reset),
        .Baud_Sel(Baud_Sel),
        .tx_enable(tx_enable),
        .rx_enable(rx_enable),
        .load(load),
        .data_in(data_in),
        .tx_busy(tx_busy),
        .rx_busy(rx_busy),
        .tx_error(tx_error),
        .rx_error(rx_error),
        .out_reg(out_reg)
    );

    // Clock generator: 50 MHz -> 20 ns period
    always #10 clk = ~clk;

    // Calculate baud period for 9600 baud (assuming freq = 50_000_000 in Baud_Gen)
    // Tx_k = 50_000_000 / (2 * 9600) ? 2604, Tx_clk period = 2604 * 20 ns ? 52.08 µs
    // Full UART frame (1 start, 8 data, 1 stop = 10 bits) ? 520.8 µs
    parameter BAUD_PERIOD = 52080; // Approximate period for 9600 baud in ns

    initial begin
        // Initialize signals
        clk = 0;
        baud_reset = 1;
        tx_reset = 1;
        rx_reset = 1;
        Baud_Sel = 3'b000; // 9600 baud
        tx_enable = 0;
        rx_enable = 0;
        load = 0;
        data_in = 8'b0;

        // Release resets
        #100;
        baud_reset = 0;
        tx_reset = 0;
        rx_reset = 0;

        // Enable Tx and Rx
        #100;
        tx_enable = 1;
        rx_enable = 1;

        // Wait for clocks to stabilize
        #10000;

        // Send first byte
        data_in = 8'hA5; // 10100101
        load = 1;
        #BAUD_PERIOD; // Hold load for one baud period to ensure detection
        load = 0;

        // Wait for transmission and reception to complete
        # (BAUD_PERIOD * 12); // Wait for ~12 baud periods (covers full frame + margin)

        // Send second byte
        data_in = 8'h3C; // 00111100
        load = 1;
        #BAUD_PERIOD;
        load = 0;

        // Wait for transmission and reception to complete
        # (BAUD_PERIOD * 12);

        // Send third byte
        data_in = 8'hFF; // 11111111
        load = 1;
        #BAUD_PERIOD;
        load = 0;

        // Wait for transmission and reception to complete
        # (BAUD_PERIOD * 12);

        // Finish simulation
        #10000;
        $display("Simulation completed. Final out_reg = 0x%h, rx_error = %b", out_reg, rx_error);
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | TX_busy=%b RX_busy=%b TX_err=%b RX_err=%b OUT=0x%h",
                 $time, tx_busy, rx_busy, tx_error, rx_error, out_reg);
    end

endmodule
