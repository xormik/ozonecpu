module bts32(DIN, ENABLE, DOUT);

	input [31:0] DIN;
	input ENABLE;
	output [31:0] DOUT;
 
assign DOUT = ENABLE ? DIN : 32'hzzzzzzzz;

endmodule