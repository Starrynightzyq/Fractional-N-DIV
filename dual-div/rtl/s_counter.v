`timescale  1ns / 1ps

module s_counter #(
    parameter WIDTH = 3
) (
    // input rst_n,
    input wire Fin,
    input wire [WIDTH-1:0] Si,
    input wire LDi,

    output wire MCo
);

    wire [WIDTH-1:0] clk_i;
    wire [WIDTH-1:0] d_i;
    wire [WIDTH-1:0] q_o;
    wire [WIDTH-1:0] qn_o;
    wire [WIDTH-1:0] LD_i;

    wire h_and;
    wire mc_d;
    wire mc_q;

    // Generate block
    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1) begin:BLOCK1
            dff  u_dff (
                .clk                     ( clk_i[i]   ),
                .LD                      ( LD_i[i]    ),
                .P                       ( Si[i]      ),
                .D                       ( d_i[i]     ),

                .Q                       ( q_o[i]     ),
                .Qn                      ( qn_o[i]    )
            );
            // buffer_1 buffer_1_1(.in(din[i]), .out(dout[i]));
        end
    endgenerate

    dff  u_mc_dff (
        .clk                     ( Fin      ),
        .LD                      ( 1'b0     ),
        .P                       ( 1'b1     ),
        .D                       ( mc_d     ),

        .Q                       ( mc_q     ),
        .Qn                      (     )
    );

    assign d_i = qn_o;
    assign h_and = &qn_o;
    assign clk_i[0] = ~((~h_and)&(~Fin));
    assign clk_i[WIDTH-1:1] = q_o[WIDTH-2:0];
    assign mc_d = ~(LDi|h_and);
    assign MCo = mc_q;
    assign LD_i = {WIDTH{LDi}};
    
endmodule