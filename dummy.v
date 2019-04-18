module dummy(in1,in8,in1_2,out32,out8,out1,out12,out1_2,out1_3,out1_4,out1_5,
                in1_3,out2,out2_2,in1_4,bi32);
    input in1;
    input [7:0] in8;
    input in1_2;
    output [31:0] out32;
    output [7:0] out8;
    output out1;
    output [11:0] out12;
    output out1_2;
    output out1_3;
    output out1_4;
    output out1_5;
    input in1_3;
    output [1:0] out2;
    output [1:0] out2_2;
    input in1_4;
    inout [31:0] bi32;

	assign {out32, out8, out1, out12, out1_2, out1_3, out1_4, out1_5, out2, out2_2} = 0;


endmodule
