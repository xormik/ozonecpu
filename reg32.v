module reg32(clk, rst, writeEnable, in0, out0);
	
  input [31:0] in0;
  input clk, rst, writeEnable;
  output [31:0] out0;
  reg [31:0] out0;

always @ (posedge clk)
  begin
    if (rst == 1) out0 <= 0;
    else if (writeEnable == 1) out0 <= in0;
  end
	
endmodule
