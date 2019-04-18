module m5x2(in0, in1, sel, out0);

  input [4:0] in0;
  input [4:0] in1;
  input sel;
  output [4:0] out0;
  reg [4:0] out0;

  // select in0 if sel=0
  // select in1 if sel=1

  always @ (in0 or in1 or sel)
  begin
    if (sel == 0)
      out0 <= in0;
    else if (sel == 1)
	 out0 <= in1;
  end

endmodule
