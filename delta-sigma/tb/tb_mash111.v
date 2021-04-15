`timescale  1ns / 1ps

module tb_mash111;

// mash111 Parameters
parameter PERIOD = 10;
parameter WIDTH  = 24;
parameter A_GAIN = 1;

// mash111 Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [WIDTH-1:0]  x_i                     = 0 ;

// mash111 Outputs
wire  [3:0]  y_o                           ;
wire  [WIDTH-1:0]  e_o                     ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
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
    $fdisplay(dout_file,"%d",$signed(y_o));    //保存有符号数据
end    

mash111 #(
    .WIDTH ( WIDTH ),
    .A_GAIN(A_GAIN))
 u_mash111 (
    .clk                     ( clk                ),
    .rst_n                   ( rst_n              ),
    .x_i                     ( x_i    [WIDTH-1:0] ),

    .y_o                     ( y_o    [3:0]       ),
    .e_o                     ( e_o    [WIDTH-1:0] )
);

initial
begin
    x_i = 'd8388607; // 2^23 - 1
    # (PERIOD*10000);

    $finish;
end

endmodule