`timescale  1ns / 1ps

module dff (
    input clk,
    input LD,

    input P,
    input D,
    output reg Q,
    output Qn
);

    always @(posedge clk or posedge LD) begin
        if (LD) begin
            Q <= P;
        end else begin
            Q <= D;
        end
    end
    
    assign Qn = ~Q;
    
endmodule