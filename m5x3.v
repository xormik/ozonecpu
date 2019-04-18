module m5x3(in0, in1, in2, sel, out0);

  input [4:0] in0;
  input [4:0] in1;
  input [4:0] in2;
  input [1:0] sel;
  output [4:0] out0;
  reg [4:0] out0;

  always @ (in0 or in1 or in2 or sel)
  begin
    if (sel == 2'd0)
      out0 <= in0;
    else if (sel == 2'd1)
	 out0 <= in1;
    else if (sel == 2'd2)
      out0 <= in2;
    else if (sel == 2'd3)
      out0 <= 5'bxxxxx;
  end

endmodule
