`timescale  1ns / 1ps

module tb_dual_div;

// dual_div Parameters
parameter PERIOD   = 10;
parameter P_WIDTH  = 5;
parameter S_WIDTH  = 3;

// dual_div Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [S_WIDTH-1:0]  Si                    = 0 ;
reg   [P_WIDTH-1:0]  Pi                    = 0 ;

// dual_div Outputs
wire  Fdiv                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

dual_div #(
    .P_WIDTH ( P_WIDTH ),
    .S_WIDTH ( S_WIDTH ))
 u_dual_div (
    .clk                     ( clk                  ),
    .rst_n                   ( rst_n                ),
    .Si                      ( Si     [S_WIDTH-1:0] ),
    .Pi                      ( Pi     [P_WIDTH-1:0] ),

    .Fdiv                    ( Fdiv                 )
);

initial
begin
    Pi = 6'd16;
    Si = 3'd4;
    #(PERIOD*1000);

    $finish;
end

endmodule