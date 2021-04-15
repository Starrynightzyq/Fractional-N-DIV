`timescale  1ns / 1ps

module efm #(
    parameter WIDTH = 24
) (
    input clk,
    input rst_n,

    input [WIDTH-1:0] x_i,
    output y_o,
    output [WIDTH-1:0] e_o
);

    wire [WIDTH:0] sum;
    reg [WIDTH-1:0] error_r;

    assign sum = x_i + error_r;

    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         sum_r <= 'b0;
    //     end else begin
    //         sum_r <= x_i + error_r; 
    //     end
    // end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            error_r <= 'b0;
        end else begin
            error_r <= sum[WIDTH-1:0];
        end
    end

    // 原始输出
    assign e_o = sum[WIDTH-1:0];
    assign y_o = sum[WIDTH];
    // // 优化输出
    // reg [WIDTH:0] sum_r;
    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         sum_r <= 'b0;
    //     end else begin
    //         sum_r <= sum; 
    //     end
    // end
    // assign e_o = sum_r[WIDTH-1:0];
    // assign y_o = sum_r[WIDTH];

endmodule