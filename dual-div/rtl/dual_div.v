`timescale  1ns / 1ps

module dual_div #(
    parameter P_WIDTH = 5,
    parameter S_WIDTH = 3
) (
    input wire clk,
    input wire rst_n,
    input wire [S_WIDTH-1:0] Si,
    input wire [P_WIDTH-1:0] Pi,

    output wire Fdiv
);

    wire  f89;
    wire  MC;
    wire  LD;

    div_89  u_div_89 (
        .clk                     ( clk     ),
        .rst_n                   ( rst_n   ),
        .MC                      ( MC      ),

        .f45                     (         ),
        .f89                     ( f89     )
    );

    p_counter #(
        .WIDTH ( P_WIDTH ))
    u_p_counter (
        .rst_n                   ( rst_n   ),
        .Fin                     ( f89     ),
        .Pi                      ( Pi      ),

        .Fout                    ( Fdiv    ),
        .LDo                     ( LD      )
    );

    s_counter #(
        .WIDTH ( S_WIDTH ))
    u_s_counter (
        .Fin                     ( f89   ),
        .Si                      ( Si    ),
        .LDi                     ( LD    ),

        .MCo                     ( MC    )
    );

endmodule