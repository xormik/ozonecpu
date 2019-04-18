module extend(in0, out0, extendType);

  input [15:0] in0;
  input [1:0] extendType;
  output [31:0] out0;
  reg [31:0] out0;

  always @ (in0 or extendType)
    begin
    
	 // extendType:
	 // 00: zero-extend
	 // 01: sign-extend
	 // 10: lui-extend

		if (extendType == 2'b01 && in0[15])
			out0 <= {16'hffff, in0};		
		else if (extendType == 2'b10)
			out0 <= {in0, 16'h0000};
      	else
			out0 <= {16'b0, in0};  
    end

endmodule


