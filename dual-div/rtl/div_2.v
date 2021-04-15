`timescale  1ns / 1ps

module div2 (
    input clk,
    input rst_n,

    output fout
);

// reg_sync Parametersnc.v
parameter WIDTH      = 1;
parameter RST_VALUE  = 0;

// // reg_sync Inputs
// reg   clk;
// reg   rst_n;
wire  [WIDTH-1:0]  D;

// reg_sync Outputs
wire  [WIDTH-1:0]  Q;
wire  [WIDTH-1:0]  Qn;

assign D = Q;
assign fout = Q;

reg_sync #(
    .WIDTH     ( WIDTH ),
    .RST_VALUE ( RST_VALUE ))
 u_reg_sync (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   ),
    .D                       ( D       ),

    .Q                       ( Q       ),
    .Qn                      ( Qn      )
);
    
endmodule