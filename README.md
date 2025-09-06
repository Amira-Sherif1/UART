# UART Verilog Implementation

A Verilog implementation of a **Universal Asynchronous Receiver-Transmitter (UART)** for serial communication, supporting configurable baud rates (9600 to 115200) with a 50 MHz system clock.  
This project includes modules for baud rate generation, transmission, reception, and a top-level integration, along with a testbench for simulation.

---

## Table of Contents
- [Overview](#overview)
- [Module Descriptions](#module-descriptions)
  - [Baud_Gen](#baud_gen)
  - [Tx](#tx)
  - [Rx](#rx)
  - [Top](#top)
  - [UART_tb](#uart_tb)
- [File Structure](#file-structure)
- [Usage](#usage)
- [Simulation](#simulation)

---

## Overview
This UART system enables serial communication with **8-bit data, 1 start bit, 1 stop bit, and no parity**.  
Key features include:

- **Configurable Baud Rates**: Supports 9600, 19200, 38400, 57600, and 115200 baud.  
- **Baud Rate Generator**: Produces Tx and Rx clocks from a 50 MHz system clock.  
- **Transmitter (Tx)**: Sends 8-bit data with start and stop bits.  
- **Receiver (Rx)**: Receives and decodes serial data, verifying the stop bit.  
- **Top Module**: Integrates all components for full-duplex operation.  
- **Testbench**: Simulates transmission/reception of test bytes (`0xA5`, `0x3C`, `0xFF`).  

---

## Module Descriptions

### Baud_Gen
**Purpose**: Generates transmit (`Tx_clk`) and receive (`Rx_clk`) clocks based on selected baud rate.  

- **Inputs**:  
  - `clk`: 50 MHz system clock  
  - `reset`: Synchronous reset  
  - `Baud_Sel[2:0]`: Selects baud rate (`000: 9600`, `001: 19200`, `010: 38400`, `011: 57600`, `100: 115200`)  

- **Outputs**:  
  - `Tx_clk`: Transmitter clock (baud rate / 2)  
  - `Rx_clk`: Receiver clock (8× `Tx_clk` for oversampling)  

- **Parameters**:  
  - `freq = 50_000_000` → System clock frequency  

---

### Tx
**Purpose**: Transmits 8-bit data serially with a start bit (`0`) and stop bit (`1`).  

- **Inputs**:  
  - `clk`: Tx clock from Baud_Gen  
  - `enable`: Enables transmission  
  - `reset`: Synchronous reset  
  - `load`: Loads 8-bit data  
  - `data_in[7:0]`: Data to transmit  

- **Outputs**:  
  - `data_out`: Serial output bit  
  - `busy`: High during transmission  
  - `error`: High if transmission fails  

---

### Rx
**Purpose**: Receives serial data, samples 8 bits, and verifies the stop bit.  

- **Inputs**:  
  - `clk`: Rx clock from Baud_Gen  
  - `reset`: Synchronous reset  
  - `enable`: Enables reception  
  - `in_bit`: Serial input bit  

- **Outputs**:  
  - `out_reg[7:0]`: Received 8-bit data  
  - `busy`: High during reception  
  - `error`: High if stop bit is invalid  

---

### Top
**Purpose**: Integrates Baud_Gen, Tx, and Rx for a complete UART system.  

- **Inputs**:  
  - `clk`, `baud_reset`, `tx_reset`, `rx_reset`: Clock and resets  
  - `Baud_Sel[2:0]`: Baud rate selection  
  - `tx_enable`, `rx_enable`: Enable Tx and Rx  
  - `load`: Loads data into Tx  
  - `data_in[7:0]`: Data to transmit  

- **Outputs**:  
  - `tx_busy`, `rx_busy`: Status indicators  
  - `tx_error`, `rx_error`: Error indicators  
  - `out_reg[7:0]`: Received data  

---

### UART_tb
**Purpose**: Testbench for simulating the UART system.  

- **Features**:  
  - 50 MHz clock (20 ns period)  
  - Tests **9600 baud** with bytes `0xA5`, `0x3C`, `0xFF`  
  - Monitors `tx_busy`, `rx_busy`, `tx_error`, `rx_error`, and `out_reg`  
  - Ensures proper timing for full UART frames (~520.8 µs per frame)  

---

## File Structure
UART_Verilog/ <br>
├── Baud_Gen.v # Baud rate generator module <br>
├── Baud_tb.v # Baud rate generator testbench module <br>
├── Tx.v # Transmitter module <br>
├── Tx_tb.v # Transmitter testbench module <br>
├── Rx.v # Receiver module <br>
├── Rx_tb.v # Receiver testbench module <br>
├── top.v # Top-level integration module <br>
├── UART_tb.v # Testbench for simulation <br>
└── README.md # Project documentation <br>


---

## Usage

### Synthesis
- Use a Verilog-compatible tool (e.g., **Xilinx Vivado**, **Intel Quartus**)  
- Compile all `.v` files **except** the testbench for synthesis  

### Simulation
- Use a simulator (e.g., **ModelSim**, **Vivado Simulator**)  
- Include all `.v` files  
- Run `UART_tb.v` to verify functionality  

### FPGA Implementation
- Map inputs/outputs to FPGA pins  
- Provide a **50 MHz clock source**  
- Connect `tx_data_out` to `in_bit` for loopback or to external UART devices  

---

## Simulation

- **Clock**: 50 MHz (20 ns period)  
- **Baud Rate**: Default 9600 baud (`Baud_Sel = 3'b000`)  
- **Test Sequence**:  
  1. Resets released after 100 ns  
  2. Tx and Rx enabled after 10 µs for clock stabilization  
  3. Sends bytes `0xA5`, `0x3C`, `0xFF` (~520.8 µs per frame)  
  4. Monitors outputs for correct data and error conditions  

- **Expected Output**:  
  - `out_reg` should match transmitted bytes (`0xA5`, `0x3C`, `0xFF`)  
  - `tx_error` and `rx_error` should remain low  

### Simulation Command Example (ModelSim)
```tcl
vlib work
vlog Baud_Gen.v Tx.v Rx.v top.v UART_tb.v
vsim -novopt UART_tb
add wave -r /*
run -all
