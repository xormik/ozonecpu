module pc(addrIN, addrOUT, WE, CLK, RST);

  input [31:0] addrIN;
  input WE, CLK, RST;

  output [31:0] addrOUT;
  reg    [31:0] addrOUT;

  always @(posedge CLK)
	begin
		if (RST)
			addrOUT <= 32'hFFFFFF00;
		else if (WE == 1)
			addrOUT <= addrIN;
	  	else addrOUT <= addrOUT; 
	end

endmodule