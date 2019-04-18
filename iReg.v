// Instruction register
// Note: may be expanded to store other values such as PC, PC+4
// Note^2: may be replaced by instruction queue if need be

module iReg(clk, rst, we, instrIN, addrIN, instrOUT, addrOUT);
	
  input clk, rst, we;
  input [31:0] instrIN, addrIN;
  output [31:0] instrOUT, addrOUT;
  reg [31:0] instrOUT, addrOUT; 

  always @ (posedge clk)
  begin
    if (rst)
      begin
	 	instrOUT <= 32'h0;
		addrOUT <= 32'h0;
	 end
    else if (we)
      begin
	 	instrOUT <= instrIN;
		addrOUT <= addrIN;
	 end
    else
      begin
	 	instrOUT <= instrOUT;
		addrOUT <= addrOUT;
	 end
  end
	
endmodule