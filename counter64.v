module counter64 (COUNT, CLK, ENABLE, RESET);
   
   output [63:0] COUNT;
   input 	      CLK;
   input 	      ENABLE;
   input 	      RESET;

   reg [63:0]    COUNT;

   always @(posedge CLK)
     if (RESET)
	  	 //#1
       COUNT <= 0;
     else if (ENABLE)
	  begin
	  	 //#1
       COUNT <= COUNT + 1;
	  end

endmodule // counter//