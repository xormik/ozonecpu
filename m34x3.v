module m34x3(in0, in1, in2, sel, out0);

  	input [33:0] in0;
	input [33:0] in1;
	input [33:0] in2;
	input [1:0] sel;
	output [33:0] out0;
	reg [33:0] out0;

always @ (in0 or in1 or in2 or sel)
begin
	if (sel == 2'b00)
		out0 <= in0;
	else if (sel == 2'b01)
		out0 <= in1;
	else	if (sel == 2'b10)
		out0 <= in2;
	else
		out0 <= 0;
end
endmodule
