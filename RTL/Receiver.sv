`timescale 1ns / 1ps

module Receiver(
    input  logic       reset,        // Synchronous reset
    input  logic       bclkx8,       // 8x Baud clock (oversampling)
    input  logic       rx_data,      // Serial data input
    output logic       rx_ready,     // Data ready flag
    output logic [7:0] data_out      // Received parallel data
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
    logic [7:0] shift_reg;      // Shift register for incoming bits
    logic [2:0] bit_count;      // Counts bits received (0-7)
    logic [2:0] sample_count;   // Oversampling counter (0-7)
    logic rx_sync;              // Synchronized input

    // Input synchronization (2-stage FF)
    always_ff @(posedge bclkx8 or posedge reset) begin
        if (reset) begin
            rx_sync <= 1'b1;
        end else begin
            rx_sync <= rx_data;
        end
    end

    // FSM and Data Reception
    always_ff @(posedge bclkx8 or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            shift_reg    <= 8'd0;
            bit_count    <= 3'd0;
            sample_count <= 3'd0;
            data_out     <= 8'd0;
            rx_ready     <= 1'b0;
        end else begin
            rx_ready <= 1'b0;  // Default to not ready
            
            case (state)
                IDLE: begin
                    sample_count <= 3'd0;
                    if (rx_sync == 1'b0) begin  // Start bit detected
                        state <= START;
                    end
                end

                START: begin
                    if (sample_count == 3'd3) begin  // Sample mid-start bit
                        if (rx_sync == 1'b0) begin   // Valid start bit
                            state <= DATA;
                            bit_count <= 3'd0;
                        end else begin
                            state <= IDLE;  // False start
                        end
                        sample_count <= 3'd0;
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end

                DATA: begin
                    if (sample_count == 3'd7) begin  // Sample mid-data bit
                        shift_reg <= {rx_sync, shift_reg[7:1]};  // LSB first
                        sample_count <= 3'd0;
                        
                        if (bit_count == 3'd7) begin
                            state <= STOP;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end

                STOP: begin
                    if (sample_count == 3'd7) begin  // Sample mid-stop bit
                        if (rx_sync == 1'b1) begin   // Valid stop bit
                            data_out <= shift_reg;
                            rx_ready <= 1'b1;
                        end
                        state <= IDLE;
                    end else begin
                        sample_count <= sample_count + 1;
                    end
                end
            endcase
        end
    end

endmodule