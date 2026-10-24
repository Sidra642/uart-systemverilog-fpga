`timescale 1ns / 1ps

module BaudRate(
    input  logic sys_clk, reset,
    input  logic [1:0] sel,
    output logic bclk, bclkx8
);

// For 100MHz system clock
localparam CLK_FREQ = 100_000_000;

// Calculate exact divisors for standard baud rates
logic [15:0] divisor;
logic [15:0] count_bclk;
logic [15:0] count_bclkx8;

always_ff @(posedge sys_clk or posedge reset) begin
    if (reset) begin
        divisor <= 10416; // Default to 9600 baud
    end else begin
        case(sel)
            2'b00: divisor <= (CLK_FREQ/(9600*2));    // 9600 baud (10416)
            2'b01: divisor <= (CLK_FREQ/(115200*2));   // 115200 baud (434)
            2'b10: divisor <= (CLK_FREQ/(38400*2));    // 38400 baud (1302)
            2'b11: divisor <= (CLK_FREQ/(57600*2));    // 57600 baud (868)
            default: divisor <= 10416;
        endcase
    end
end

// Baud clock generation (1x)
always_ff @(posedge sys_clk or posedge reset) begin
    if (reset) begin
        count_bclk <= 0;
        bclk <= 0;
    end else if (count_bclk >= divisor - 1) begin
        count_bclk <= 0;
        bclk <= ~bclk;
    end else begin
        count_bclk <= count_bclk + 1;
    end
end

// 8x Baud clock generation
always_ff @(posedge sys_clk or posedge reset) begin
    if (reset) begin
        count_bclkx8 <= 0;
        bclkx8 <= 0;
    end else if (count_bclkx8 >= (divisor/8) - 1) begin
        count_bclkx8 <= 0;
        bclkx8 <= ~bclkx8;
    end else begin
        count_bclkx8 <= count_bclkx8 + 1;
    end
end

endmodule
