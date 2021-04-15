`timescale  1ns / 1ps

module tb_p_counter;

// p_counter Parameters
parameter PERIOD = 10;
parameter P_WIDTH  = 5;
parameter S_WIDTH  = 3;

// p_counter Inputs
reg   rst_n                                = 0 ;
reg   Fin                                  = 0 ;
reg   [P_WIDTH-1:0]  Pi                      = 0 ;

// p_counter Outputs
wire  Fout                                 ;
wire  LDo                                  ;


initial
begin
    forever #(PERIOD/2)  Fin=~Fin;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

p_counter #(
    .P_WIDTH ( P_WIDTH ))
u_p_counter (
    .rst_n                   ( rst_n             ),
    .Fin                     ( Fin               ),
    .Pi                      ( Pi    [P_WIDTH-1:0] ),

    .Fout                    ( Fout              ),
    .LDo                     ( LDo               )
);

// s_counter Inputs
reg   [S_WIDTH-1:0]  Si;

// s_counter Outputs
wire  MCo;

s_counter #(
    .WIDTH ( S_WIDTH ))
 u_s_counter (
    .Fin                     ( Fin     ),
    .Si                      ( Si      ),
    .LDi                     ( LDo     ),

    .MCo                     ( MCo     )
);

initial
begin
    Pi = 6'b000111;
    Si = 3'b011;
    #(PERIOD*100);
    $finish;
end

endmodule