module m32x2(in0, in1, sel, out0);

	input [31:0] in0;
	input [31:0] in1;
	input sel;
	output [31:0] out0;
	reg [31:0] out0;

always @ (in0 or in1 or sel)
begin
	if (sel == 0)
		out0 <= in0;
	else out0 <= in1;
end

endmodule
