`timescale  1ns / 1ps

module mash111 #(
    parameter WIDTH = 24,  // 小数分频的位宽
    parameter A_GAIN = 1   // A = A_GAIN*2-1, 控制反馈的大小，具体原理去论文中看
) (
    input clk,             // 时钟输入
    input rst_n,           // 复位信号，低有效

    input [WIDTH-1:0] x_i, // Sigma-Delta 调制器的输入，即分频中小数的输入
    output [3:0] y_o,      // 量化输出
    output [WIDTH-1:0] e_o // 最后一级 EFM 的误差输出，实际上用不到，不用管
);

    wire [WIDTH-1:0] x_i_1;
    wire [WIDTH-1:0] e_o_1;
    wire y_o_1;
    wire [WIDTH-1:0] x_i_2;
    wire [WIDTH-1:0] e_o_2;
    wire y_o_2;
    wire [WIDTH-1:0] x_i_3;
    wire [WIDTH-1:0] e_o_3;
    wire y_o_3;

    wire signed [2:0] c1;
    wire signed [3:0] c2;
    reg signed [0:0] c0_reg;
    reg signed [2:0] c1_reg; 

    // 前一级 efm 的误差输出作为后一级 efm 的输入
    assign x_i_1 = x_i;
    assign x_i_2 = e_o_1;
    assign x_i_3 = e_o_2;

    // 将 3 级 efm 的输出求和
    assign c1 = y_o_2 + y_o_3 - c0_reg;
    assign c2 = y_o_1 + {c1[2], c1} - {c1_reg[2], c1_reg}; // 补全符号位

    assign y_o = c2;
    assign e_o = e_o_3;

    // 延迟
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c0_reg <= 'b0;
            c1_reg <= 'b0;
        end else begin
            c0_reg <= y_o_3;
            c1_reg <= c1;
        end 
    end

    // 三级 efm 级联
    hk_efm #(
        .WIDTH ( WIDTH ),
        .A_GAIN(A_GAIN))
    u_hk_efm_1 (
        .clk                     ( clk     ),
        .rst_n                   ( rst_n   ),
        .x_i                     ( x_i_1   ),

        .y_o                     ( y_o_1   ),
        .e_o                     ( e_o_1   )
    );

    hk_efm #(
        .WIDTH ( WIDTH ),
        .A_GAIN(A_GAIN))
    u_hk_efm_2 (
        .clk                     ( clk     ),
        .rst_n                   ( rst_n   ),
        .x_i                     ( x_i_2   ),

        .y_o                     ( y_o_2   ),
        .e_o                     ( e_o_2   )
    );

    hk_efm #(
        .WIDTH ( WIDTH ),
        .A_GAIN(A_GAIN))
    u_hk_efm_3 (
        .clk                     ( clk     ),
        .rst_n                   ( rst_n   ),
        .x_i                     ( x_i_3   ),

        .y_o                     ( y_o_3   ),
        .e_o                     ( e_o_3   )
    );
    
endmodule