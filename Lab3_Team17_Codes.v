// --- Question 1 --- //

module LFSR(Out, CLK, RESET);
    input CLK, RESET;
    output Out;

    // Edit your module contents here
    reg [4:0] DFF;
    always @(posedge CLK) begin
      if(RESET==0) begin
        DFF <= 5'b00001;
      end else begin
        DFF[4] <= DFF[3];
        DFF[3] <= DFF[2];
        DFF[2] <= DFF[1];
        DFF[1] <= DFF[0];
        DFF[0] <= DFF[1] ^ DFF[4];
      end
    end
    assign Out = DFF[4];
endmodule

// --- Question 2 --- //
module Pingpong_Counter(Out, Direction, CLK, RESET, Enable);
    input CLK, RESET, Enable;
	output [3:0] Out;
    output Direction;

	// Edit your module contents here
	reg [3:0] counter;
    reg Direction = 0;
    always @(posedge CLK) begin 
      if ( RESET == 0 ) begin
        counter = 4'b0000;
      end else begin
        if ( Enable == 1 ) begin
          if ( (counter==4'b1111 & Direction==0) | (counter==4'b0000 & Direction==1) ) begin
            Direction = ~Direction;
          end
          if (Direction == 0) begin
            counter = counter + 1'b1;
          end else begin
            counter = counter - 1'b1;
          end
        end
      end
    end
    assign Out = counter;
endmodule


// --- Question 3 --- //
module CLK_Divider(CLK1_2, CLK1_4, CLK1_8, CLK1_3, DCLK, CLK, RESET, SEL);
    input CLK, RESET;
	input [1:0] SEL;
    output CLK1_2, CLK1_4, CLK1_8, CLK1_3, DCLK;

	// Edit your module contents here
	reg cnt2;
    reg [1:0] cnt4,cnt3;
    reg [2:0] cnt8;
    always @(posedge CLK) begin
      if (!RESET) begin
        cnt2 <= 0;
        cnt4 <= 1;
        cnt8 <= 3;
        cnt3 <= 0;
      end else begin 
        if (cnt2==1) begin
          cnt2 <= 0;
        end else begin
          cnt2 <= cnt2 + 1;
        end
        if (cnt4==3) begin
          cnt4 <= 0;
        end else begin
          cnt4 <= cnt4 + 1;
        end
        if (cnt8==7) begin
          cnt8 <= 0;
        end else begin
          cnt8 <= cnt8 + 1;
        end
        if (cnt3==2) begin
          cnt3 <= 0;
        end else begin;
          cnt3 <= cnt3 + 1;
        end
      end
    end
    assign CLK1_2=cnt2;
    assign CLK1_4=cnt4[1];
    assign CLK1_8=cnt8[2];
    assign CLK1_3=(cnt3==2'b00)?0:1;
    assign DCLK=(SEL==2'b00)?CLK1_2:(SEL==2'b01)?CLK1_4:(SEL==2'b10)?CLK1_8:CLK1_3;

endmodule


// --- Question 4 --- //
module FPGA_SW_LED(LED, SW);
    input [15:0] SW;
    output [15:0] LED;

    // Edit your module contents here
    assign LED[0]=SW[0];
    assign LED[1]=SW[1];
    assign LED[2]=SW[2];
    assign LED[3]=SW[3];
    assign LED[4]=SW[4];
    assign LED[5]=SW[5];
    assign LED[6]=SW[6];
    assign LED[7]=SW[7];
    assign LED[8]=SW[8];
    assign LED[9]=SW[9];
    assign LED[10]=SW[10];
    assign LED[11]=SW[11];
    assign LED[12]=SW[12];
    assign LED[13]=SW[13];
    assign LED[14]=SW[14];
    assign LED[15]=SW[15];

endmodule

module FullAdder(Sum, C_out, C_in, A, B);
    output Sum, C_out;
    input  C_in, A, B;
    wire xor_w, w1, w2;
    xor xor1(xor_w, A, B);
    xor xor2(Sum, xor_w, C_in);
    and and1(w1, C_in, xor_w);
    and and2(w2, A, B);
    or or1(C_out, w1, w2);
endmodule

// --- Question 5 --- //
module FPGA_Adder(Sum, C_out, A, B, C_in);
    input [5:0] A;
    input [5:0] B;
    input C_in;
    output C_out;
    output [5:0] Sum;

    // Edit your module contents here
    wire [4:0]  w;
    FullAdder Fa0(Sum[0], w[0], C_in, A[0], B[0]);
    FullAdder Fa1(Sum[1], w[1], w[0], A[1], B[1]);
    FullAdder Fa2(Sum[2], w[2], w[1], A[2], B[2]);
    FullAdder Fa3(Sum[3], w[3], w[2], A[3], B[3]); 
    FullAdder Fa4(Sum[4], w[4], w[3], A[4], B[4]); 
    FullAdder Fa5(Sum[5], C_out, w[4], A[5], B[5]); 
endmodule

// --- Optional Question 1 ---- //
module FPGA_Pingpong_Counter(Out, Direction, CLK, RESET, Enable);
    input CLK, RESET, Enable;		// You are allowed to use asynchronous RESET
	output [3:0] Out;
    output Direction;

    // Edit your module contents here
    reg [24:0] divider;
    wire o_clk;
    reg [3:0] Out;
    reg Direction;
    always @(posedge CLK or negedge RESET) begin
      if (!RESET)
        divider <= 25'b0;
      else
        divider <= divider + 1;
    end
    assign o_clk = divider[24];
    always @(posedge o_clk or negedge RESET) begin  
      if (!RESET) begin
        Out = 4'b0000;
      end else begin
        if ( Enable == 0 ) begin
          if ( (Out==4'b1111 & Direction==0) | (Out==4'b0000 & Direction==1) ) begin
            Direction = ~Direction;
          end
          if (Direction == 0) begin
            Out = Out + 1'b1;
          end else begin
            Out = Out - 1'b1;
          end
        end
      end
    end
    
endmodule

module hexseg(hex,seg);
    input [3:0] hex;
    output reg [6:0] seg;
    always @(hex)
        begin
            case(hex)
                4'b0000:seg=7'b1000000;//0
                4'b0001:seg=7'b1111001;//1
                4'b0010:seg=7'b0100100;//2
                4'b0011:seg=7'b0110000;//3
                4'b0100:seg=7'b0011001;//4
                4'b0101:seg=7'b0010010;//5
                4'b0110:seg=7'b0000010;//6
                4'b0111:seg=7'b1111000;//7
                4'b1000:seg=7'b0000000;//8
                4'b1001:seg=7'b0011000;//9
                4'b1010:seg=7'b0001000;//a
                4'b1011:seg=7'b0000011;//b
                4'b1100:seg=7'b1000110;//c
                4'b1101:seg=7'b0100001;//d
                4'b1110:seg=7'b0000110;//e
                4'b1111:seg=7'b0001110;//f
            endcase
        end
endmodule

// --- Optional Question 2 ---- //
module FPGA_7_Segment(AN, Seg, CLK, SW);
    input CLK;		
    input [15:0] SW; // use SW[0] as your synchronous RESET
    output [3:0] AN;
	output [6:0] Seg;

    // Edit your module contents here
    reg [16:0] divider;
    wire       o_clk;
    reg [3:0] AN;
    reg [3:0] Sel_SW;
    hexseg hs(Sel_SW,Seg);
    always @(posedge CLK or negedge SW[0]) begin
      if (!SW[0])
        divider <= 17'b0;
      else
        divider <= divider + 1;
    end
    assign o_clk = divider[16];   
    always @(posedge o_clk or negedge SW[0]) begin
      if (!SW[0]) begin
        AN <= 4'b1110;
        Sel_SW <= 4'b0000;
      end else begin
         if (AN==4'b0111) begin
           Sel_SW=SW[3:0];
           AN <= 4'b1110;
         end
         if (AN==4'b1110) begin
           Sel_SW=SW[7:4];
           AN <= 4'b1101;
         end
         if (AN==4'b1101) begin
           Sel_SW=SW[11:8];
           AN <= 4'b1011;
         end
         if (AN==4'b1011) begin
           Sel_SW=SW[15:12];
           AN <= 4'b0111;
         end
      end
    end
    
endmodule
