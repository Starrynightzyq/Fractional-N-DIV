`timescale  1ns / 1ps

module reg_sync #(
    parameter WIDTH = 1,
    parameter RST_VALUE = 0
) (
    input clk,
    input rst_n,

    input [WIDTH-1:0] D,
    output reg [WIDTH-1:0] Q=0,
    output [WIDTH-1:0] Qn
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= {WIDTH{RST_VALUE}};
        end else begin
            Q <= D;
        end
    end
    
    assign Qn = ~Q;
    
endmodule