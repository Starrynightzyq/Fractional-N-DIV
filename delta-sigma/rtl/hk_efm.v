`timescale  1ns / 1ps

module hk_efm #(
    parameter WIDTH = 24,
    parameter A_GAIN = 1 // A = A_GAIN*2-1
) (
    input clk,
    input rst_n,

    input [WIDTH-1:0] x_i,
    output y_o,
    output [WIDTH-1:0] e_o
);

    wire [WIDTH:0] sum;
    reg [WIDTH:0] sum_r;

    assign sum = x_i + sum_r[WIDTH-1:0] - {A_GAIN{sum_r[WIDTH]}};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_r <= 'b0;
        end else begin
            sum_r <= sum;
        end
    end

    // 原始输出
    assign e_o = sum[WIDTH-1:0];
    // assign y_o = sum[WIDTH];
    // 优化输出
    assign y_o = sum_r[WIDTH];

endmodule