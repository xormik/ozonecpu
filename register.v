module register(DIN, DOUT, WE, CLK, RST);
	parameter width = 1;
	
	input[width-1:0] DIN;
	input CLK;
	input WE;
	input RST;
	output[width-1:0] DOUT;

	reg [width-1:0] DOUT;
	initial DOUT = 0;

	always @(posedge CLK)
		begin
			if (RST)
				DOUT = 0;
			else if (WE == 1) begin
				//#1000
				DOUT = DIN;
			end
		  	else DOUT = DOUT; 
		end

endmodule