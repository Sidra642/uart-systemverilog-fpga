`timescale 1ns / 1ps

module UART_Top (
    input  logic        clk,          // System clock
    input  logic        reset,       // System reset (active high)
    input  logic [1:0]  baud_sel,    // Baud rate selection
    // Transmitter Interface
    input  logic        tx_start,    // Trigger transmission
    input  logic [7:0]  tx_data_in,  // Data to transmit
    output logic        tx_busy,     // Transmission in progress
    output logic        tx_out,      // Serial output
    // Receiver Interface
    input  logic        rx_in,       // Serial input
    output logic        rx_ready,    // Data received flag
    output logic [7:0]  rx_data_out  // Received data
);

    // Baud clock signals
    logic bclk;     // Standard baud clock
    logic bclkx8;   // 8x oversampling clock

    // Baud Rate Generator Instance
    BaudRate baud_gen (
        .sys_clk(clk),
        .reset(reset),
        .sel(baud_sel),
        .bclk(bclk),
        .bclkx8(bclkx8)
    );

    // Transmitter Instance
    Transmitter uart_tx (
        .reset(reset),
        .bclk(bclk),
        .load(tx_start),
        .data_in(tx_data_in),
        .tx_data(tx_out),
        .tx_busy(tx_busy)
    );

    // Receiver Instance
    Receiver uart_rx (
        .reset(reset),
        .bclkx8(bclkx8),
        .rx_data(rx_in),
        .rx_ready(rx_ready),
        .data_out(rx_data_out)
    );

endmodule
