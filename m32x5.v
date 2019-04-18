module m32x5(in0, in1, in2, in3, in4, sel, out0);

	input [31:0] in0;
	input [31:0] in1;
	input [31:0] in2;
	input [31:0] in3;
	input [31:0] in4;
	input [2:0] sel;
	output [31:0] out0;
	reg [31:0] out0;

always @ (in0 or in1 or in2 or in3 or in4 or sel)
begin
	if (sel == 3'b000)
		out0 <= in0;
	else if (sel == 3'b001)
		out0 <= in1;
	else if (sel == 3'b010)
		out0 <= in2;		
	else if (sel == 3'b011)
		out0 <= in3;
	else if (sel == 3'b100)
		out0 <= in4;
	else
		out0 <= 0;
end
endmodule
