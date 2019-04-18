/*
  
  module: shifter
  function: shifts left or right (zero/sign extend) according
            to shiftType by shiftAmt bits
  parameters:
    shiftType = 0;  sll
    shiftType = 2;	srl
    shiftType = 3;	sra
   
    *In control, shiftType based on funct(1:0)

*/

module shifter(in0, out0, shiftType, shiftAmt);

  input [31:0] in0;
  input [4:0] shiftAmt;
  input [1:0] shiftType;
	
  output [31:0] out0;
  reg [31:0] out0;

  always @ (shiftType or shiftAmt or in0)
    begin

      if (shiftType == 2'b0)           // sll
	   out0 <= in0 << shiftAmt;	
	 else if (shiftType == 2'b10)     // srl
	   out0 <= in0 >> shiftAmt;
	 else //(shiftType == 2'b11)     // sra
        //out0 <= (in0[31]) ? {{-shiftAmt'd1},in0[31:shiftAmt])} : {{shiftAmt'd0},in0[31:shiftAmt]};	   
	   
	   out0 <= in0[31] ? {32'hFFFFFFFF, in0} >> shiftAmt : {32'h0, in0} >> shiftAmt;

	   //out0 = in0 >> shiftAmt;
	   //out0[31:shiftAmt] = out0[shiftAmt] ? -1 : 0;
	   //out0 <= {{shiftAmt{in0[31]}}, in0 >> shiftAmt}; 		                                    
	 //else
	   //$display("shifter: undefined shiftType");
    end

endmodule
