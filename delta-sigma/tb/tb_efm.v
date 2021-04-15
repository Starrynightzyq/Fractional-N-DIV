`timescale  1ns / 1ps

module tb_efm;

// efm Parameters
parameter PERIOD = 10;
parameter WIDTH  = 9;

// efm Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [WIDTH-1:0]  x_i                     = 0 ;

// efm Outputs
wire  y_o                                  ;
wire  [WIDTH-1:0]  e_o                     ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

hk_efm #(
    .WIDTH ( WIDTH ))
 u_efm (
    .clk                     ( clk                ),
    .rst_n                   ( rst_n              ),
    .x_i                     ( x_i    [WIDTH-1:0] ),

    .y_o                     ( y_o                ),
    .e_o                     ( e_o    [WIDTH-1:0] )
);

initial
begin
    x_i = 'd254;
    # (PERIOD*100);

    $finish;
end

endmodule