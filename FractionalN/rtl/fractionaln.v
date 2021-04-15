`timescale  1ns / 1ps

module fractionaln #(
    parameter P_WIDTH = 5,
    parameter S_WIDTH = 3,
    parameter INT_WIDTH = 8,
    parameter FRAC_WIDTH = 24
) (
    input wire Fin,
    input wire rst_n,

    input wire [INT_WIDTH-1:0] Integer,
    input wire [FRAC_WIDTH-1:0] Fraction,

    output wire Fout
);

    wire [3:0] delta_sigma;
    wire clk_delta_sigma;
    wire [S_WIDTH-1:0] Si;
    wire [P_WIDTH-1:0] Pi;

    assign clk_delta_sigma = Fout;

    mash111 #(
        .WIDTH  ( FRAC_WIDTH ),
        .A_GAIN ( 1  ))
    u_mash111 (
        .clk                     ( clk_delta_sigma ),
        .rst_n                   ( rst_n           ),
        .x_i                     ( Fraction        ),

        .y_o                     ( delta_sigma     ),
        .e_o                     (                 )
    );

    calculate_ps #(
        .P_WIDTH   ( P_WIDTH ),
        .S_WIDTH   ( S_WIDTH ),
        .INT_WIDTH ( INT_WIDTH ))
    u_calculate_ps (
        .clk                     ( clk_delta_sigma ),
        .rst_n                   ( rst_n           ),
        .Integer                 ( Integer         ),
        .delta_sigma             ( delta_sigma     ),
        .Si                      ( Si              ),
        .Pi                      ( Pi              )
    );
    
    dual_div #(
        .P_WIDTH ( P_WIDTH ),
        .S_WIDTH ( S_WIDTH ))
    u_dual_div (
        .clk                     ( Fin     ),
        .rst_n                   ( rst_n   ),
        .Si                      ( Si      ),
        .Pi                      ( Pi      ),

        .Fdiv                    ( Fout    )
    );    
    
endmodule