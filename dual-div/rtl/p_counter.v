`timescale  1ns / 1ps

module p_counter #(
    parameter WIDTH = 5
) (
    input rst_n,
    input wire Fin,
    input wire [WIDTH-1:0] Pi,

    output wire Fout,
    output wire LDo
);

    wire [WIDTH-1:0] clk_i;
    wire [WIDTH-1:0] d_i;
    wire [WIDTH-1:0] q_o;
    wire [WIDTH-1:0] qn_o;
    wire [WIDTH-1:0] LD_i;

    wire h_nand;
    wire ld_d;
    wire ld_q;
    wire [WIDTH-1:0] Pi_correct;

    // Generate block
    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1) begin:BLOCK1
            dff  u_dff (
                .clk                     ( clk_i[i]   ),
                .LD                      ( LD_i[i]    ),
                .P                       ( Pi_correct[i]      ),
                .D                       ( d_i[i]     ),

                .Q                       ( q_o[i]     ),
                .Qn                      ( qn_o[i]    )
            );
            // buffer_1 buffer_1_1(.in(din[i]), .out(dout[i]));
        end
    endgenerate

    dff  u_ld_dff (
        .clk                     ( Fin      ),
        .LD                      ( ~rst_n   ),
        .P                       ( 1'b1     ),
        .D                       ( ld_d     ),

        .Q                       ( ld_q     ),
        .Qn                      (     )
    );

    assign Pi_correct = Pi - 1'b1;
    assign d_i = qn_o;
    assign clk_i[0] = Fin;
    assign clk_i[WIDTH-1:1] = q_o[WIDTH-2:0];
    assign Fout = qn_o[WIDTH-1] & qn_o[WIDTH-2];
    assign h_nand = ~(&qn_o[WIDTH-1:1]);
    assign ld_d = ~(qn_o[0]|h_nand);
    assign LD_i = {WIDTH{ld_q}};
    assign LDo = ld_q;
    
endmodule