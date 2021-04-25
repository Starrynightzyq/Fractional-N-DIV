`timescale  1ns / 1ps

module div_89 (
    input clk,
    input rst_n,
    input MC,    // MC = 0 时，8分频；MC = 1 时，9分频

    output f45,
    output f89
);

    wire D1;
    wire Q1;
    wire Qn1;
    wire D2;
    wire Q2;
    wire Qn2;
    wire D3;
    wire Q3;
    wire Qn3;
    wire D4;
    wire Q4;
    wire Qn4;

    // 这部分原理见 8/9 分频器的结构图
    assign D1 = ~(Q2 & Q3);
    assign D2 = Q1;
    assign D3 = ~(Qn2 & (Qn4 & MC));
    assign D4 = Qn4;

    assign f89 = Qn4; // 异步 8/9 分频
    assign f45 = Qn1; // 同步 4/5 分频

    // D 触发器
    reg_sync #(
        .WIDTH ( 1 ))
    u1_reg_sync (
        .clk                     ( clk   ),
        .rst_n                   ( rst_n ),
        .D                       ( D1    ),
        .Q                       ( Q1    ),
        .Qn                      ( Qn1   )
    );

    reg_sync #(
        .WIDTH ( 1 ))
    u2_reg_sync (
        .clk                     ( clk   ),
        .rst_n                   ( rst_n ),
        .D                       ( D2    ),
        .Q                       ( Q2    ),
        .Qn                      ( Qn2   )
    );

    reg_sync #(
        .WIDTH ( 1 ))
    u3_reg_sync (
        .clk                     ( clk   ),
        .rst_n                   ( rst_n ),
        .D                       ( D3    ),
        .Q                       ( Q3    ),
        .Qn                      ( Qn3   )
    );

    reg_sync #(
        .WIDTH ( 1 ))
    u4_reg_sync (
        .clk                     ( Q1    ),
        .rst_n                   ( rst_n ),
        .D                       ( D4    ),
        .Q                       ( Q4    ),
        .Qn                      ( Qn4   )
    );
    
endmodule