`timescale  1ns / 1ps

// 整个小数分频器的顶层模块，包含 mash111-Sigma-Delta 调制器，双模分频器
module fractionaln #(
    parameter P_WIDTH = 5,                  // P 计数器的位宽
    parameter S_WIDTH = 3,                  // S 计数器的位宽
    parameter INT_WIDTH = 8,                // 分频整数的位宽
    parameter FRAC_WIDTH = 24               // 分频小数的位宽
) (
    input wire Fin,                         // 分频器的时钟输入
    input wire rst_n,                       // 复位信号，低有效

    input wire [INT_WIDTH-1:0] Integer,     // 分频整数部分
    input wire [FRAC_WIDTH-1:0] Fraction,   // 分频小数部分

    output wire Fout                        // 分频输出
);

    wire [3:0] delta_sigma;
    wire clk_delta_sigma;
    wire [S_WIDTH-1:0] Si;
    wire [P_WIDTH-1:0] Pi;

    assign clk_delta_sigma = Fout;

    // Sigma-Delta 调制器
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

    // 将分频的整数部分和 Sigma-Delta 调制器的结果相加，将结果分成两部分分别送到 P 计数器和 S 计数器
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
    
    // P/S 双模分频器
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