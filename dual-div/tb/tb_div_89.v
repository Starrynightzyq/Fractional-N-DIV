`timescale  1ns / 1ps

module tb_div_89;

// div_89 Parameters
parameter PERIOD  = 10;


// div_89 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   MC                                   = 0 ;

// div_89 Outputs
wire  f45                                  ;
wire  f89                                  ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

div_89  u_div_89 (
    .clk                     ( clk   ),
    .rst_n                   ( rst_n ),
    .MC                      ( MC    ),

    .f45                     ( f45   ),
    .f89                     ( f89   )
);

initial
begin
    MC = 0;
    #(PERIOD*100);
    MC = 1;
    #(PERIOD*100);

    $finish;
end

endmodule