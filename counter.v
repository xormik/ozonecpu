`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////
//variable width binary counter with enable and sync reset
module counter (OUT, CLK, ENABLE, RESET);
   parameter width = 4; // to be overwriten
   output [width-1:0] OUT;
   input 	      CLK;
   input 	      ENABLE;
   input 	      RESET;

   reg [width-1:0]    OUT;

   always @(posedge CLK)
     if (RESET)
	  	 //#1
       OUT <= 0;
     else if (ENABLE)
	  begin
	  	 //#1
       OUT <= OUT + 1;
	  end

endmodule // counter//

module updown_counter (OUT, CLK, ENABLE, RESET, INC);
   parameter something = 0; //default value for 64ms/(DRAMCLKPERIOD @ 25MHz)/4096
   parameter width = 4;
   output [width-1:0] OUT;
   input CLK;
   input ENABLE;
   input RESET;
   input INC;
   
   reg [width-1:0] OUT;
  
   always @(posedge CLK)
     if (RESET)
       OUT <= something;
     else if (ENABLE & INC)
	  begin
       OUT <= OUT + 1;
	  end
     else if (ENABLE & (~INC) & (OUT == 0))
	  begin 
		 OUT <= something;
	  end
	  else if (ENABLE & (~INC))
	  begin
       OUT <= OUT - 1;
	  end
endmodule //updown_counter
