`timescale  1ns / 1ps

module tb_div2;

// div2 Parameters
parameter PERIOD     = 10;
parameter WIDTH      = 1;
parameter RST_VALUE  = 0;

// div2 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// div2 Outputs
wire  fout                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

div2 #(
    .WIDTH     ( WIDTH     ),
    .RST_VALUE ( RST_VALUE ))
 u_div2 (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   ),

    .fout                    ( fout    )
);

initial
begin

    #(PERIOD*50);

    $finish;
end

endmodule