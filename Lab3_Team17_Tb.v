`timescale 1ns/10ps
module Tb_Q1;
  reg CLK, RESET;
  wire Out;
  LFSR Q1(Out, CLK, RESET);
  initial begin
    CLK = 0;
    RESET = 1;
    #40 RESET = 0;
    #40 RESET = 1;
  end
  always begin
    #20
    CLK = ~CLK;
  end
endmodule

module Tb_Q2;
  reg CLK, RESET, Enable;
  wire Direction;
  wire [3:0] Out;
  Pingpong_Counter Q2(Out, Direction, CLK, RESET, Enable);
  initial begin
    CLK = 0;
    RESET = 1;
    Enable = 0;
    #20 Enable = 1;
    RESET = 0;
    #20 RESET = 1;
    #80 Enable = 0;
    #80 Enable = 1;
    #640 RESET = 0;
    #40 RESET = 1;
  end
  always begin
    #20
    CLK = ~CLK;
  end
endmodule

module Tb_Q3;
  reg CLK, RESET;
  reg [1:0] SEL;
  wire  CLK1_2, CLK1_4, CLK1_8, CLK1_3, DCLK;
  CLK_Divider Q3(CLK1_2, CLK1_4, CLK1_8, CLK1_3, DCLK, CLK, RESET, SEL);
  initial begin
    CLK = 0;
    RESET = 0;
    SEL = 2'b00;
    #40 RESET = 1;
  end
  always begin
    #20
    CLK = ~CLK;
  end
  always begin
    #40
    SEL = SEL + 1;
  end
endmodule