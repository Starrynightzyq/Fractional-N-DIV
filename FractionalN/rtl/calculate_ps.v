`timescale  1ns / 1ps

module calculate_ps #(
    parameter P_WIDTH = 5,
    parameter S_WIDTH = 3,
    parameter INT_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,

    input wire [INT_WIDTH-1:0] Integer,
    // input wire [FRAC_WIDTH-1:0] Fraction,

    input wire [3:0] delta_sigma,

    output wire [S_WIDTH-1:0] Si,
    output wire [P_WIDTH-1:0] Pi
);

    reg [INT_WIDTH-1:0] real_integer;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            real_integer <= Integer;
        end else begin
            real_integer <= Integer + {{(INT_WIDTH-4){delta_sigma[3]}}, delta_sigma};
        end
    end

    assign Pi = real_integer[INT_WIDTH-1:INT_WIDTH-P_WIDTH];
    assign Si = real_integer[S_WIDTH-1:0];
    
endmodule