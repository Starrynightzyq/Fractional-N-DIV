`timescale  1ns / 1ps

// P/S 双模分频器
module dual_div #(
    parameter P_WIDTH = 5,
    parameter S_WIDTH = 3
) (
    input wire clk,              // 时钟输入
    input wire rst_n,            // 复位信号，低有效
    input wire [S_WIDTH-1:0] Si, // S 计数器的最大值
    input wire [P_WIDTH-1:0] Pi, // P 计数器的最大值

    output wire Fdiv             // 分频输出
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