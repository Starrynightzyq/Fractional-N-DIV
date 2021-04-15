`timescale  1ns / 1ps

module tb_fractionaln;

// fractionaln Parameters
parameter PERIOD      = 10;
parameter P_WIDTH     = 5 ;
parameter S_WIDTH     = 3 ;
parameter INT_WIDTH   = 8 ;
parameter FRAC_WIDTH  = 24;

// fractionaln Inputs
reg   Fin                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [INT_WIDTH-1:0]  Integer             = 0 ;
reg   [FRAC_WIDTH-1:0]  Fraction           = 0 ;
reg clk=0;

// fractionaln Outputs
wire  Fout                                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

fractionaln #(
    .P_WIDTH    ( P_WIDTH    ),
    .S_WIDTH    ( S_WIDTH    ),
    .INT_WIDTH  ( INT_WIDTH  ),
    .FRAC_WIDTH ( FRAC_WIDTH ))
 u_fractionaln (
    .Fin                     ( clk                        ),
    .rst_n                   ( rst_n                      ),
    .Integer                 ( Integer   [INT_WIDTH-1:0]  ),
    .Fraction                ( Fraction  [FRAC_WIDTH-1:0] ),

    .Fout                    ( Fout                       )
);

initial
begin
    Integer = 8'd132;
    Fraction = 24'd8388607; // 2^23 - 1 (0.5)
    #(PERIOD*132*10000);
    $finish;
end

integer dout_file;
initial begin
    dout_file=$fopen("/home/EDA/vsim/mash/tb/data.txt");    //打开所创建的文件
    if(dout_file == 0)begin 
        $display ("can not open the file!");    //创建文件失败，显示can not open the file!
        $stop;
    end
end

always @(posedge clk) begin
    // $fdisplay(dout_file,"%d",$signed(Fout));    //保存有符号数据
    $fdisplay(dout_file,"%b",Fout);    //使能信号有效，每来一个时钟，写入到所创建的文件中
end   

endmodule