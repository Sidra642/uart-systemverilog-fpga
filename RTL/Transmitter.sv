`timescale 1ns / 1ps

module Transmitter (
    input  logic        reset,       // Synchronous reset (active high)
    input  logic        bclk,        // Baud clock (bit timing)
    input  logic        load,        // Trigger to load new data
    input  logic [7:0]  data_in,     // 8-bit parallel input data
    output logic        tx_data,     // Serial data output (1-bit)
    output logic        tx_busy      // Transmission in progress
);

    // FSM state encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t state;

    // Internal registers
    logic [7:0] data_hold;       // Data to be transmitted
    logic [2:0] bit_count;       // Counts bits sent (0-7)

    // FSM and Data Transmission
    always_ff @(posedge bclk or posedge reset) begin
        if (reset) begin
            state      <= IDLE;
            tx_data    <= 1'b1;    // Idle line is high
            tx_busy    <= 1'b0;
            bit_count  <= 3'd0;
            data_hold  <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx_data <= 1'b1;
                    tx_busy <= 1'b0;
                    bit_count <= 3'd0;
                    
                    if (load) begin
                        data_hold <= data_in;
                        state <= START;
                        tx_busy <= 1'b1;
                    end
                end

                START: begin
                    tx_data <= 1'b0;  // Start bit
                    state <= DATA;
                end

                DATA: begin
                    tx_data <= data_hold[0];          // Send LSB first
                    data_hold <= {1'b0, data_hold[7:1]}; // Right shift
                    
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    tx_data <= 1'b1;  // Stop bit
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule