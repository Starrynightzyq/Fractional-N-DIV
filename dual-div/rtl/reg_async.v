`timescale  1ns / 1ps

module reg_async #(
    parameter WIDTH = 1
) (
    input clk,
    // input rst_n,

    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q,
    output [WIDTH-1:0] Qn
);

    always @(posedge clk) begin
        Q <= Q;
    end
    
    assign Qn = ~Q;
    
endmodule