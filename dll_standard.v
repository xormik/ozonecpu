// XAPP132 
//  
// Standard DLL Example
// From ftp://ftp.xilinx.com/pub/applications/xapp/xapp132.zip
// for use in Fall 2003 CS152
// to see what the input/outputs are for CLKDLL, see the xapp132.pdf file
//

module dll_standard (CLKIN, RESET, CLK0, CLK_DIV_OUT, LOCKED);
   input CLKIN, RESET;
   output CLK0, CLK_DIV_OUT, LOCKED;
   
   wire   CLKIN_w, RESET_w, CLK0_dll, LOCKED_dll, CLK_DIV;

   IBUFG clkpad (.I(CLKIN), .O(CLKIN_w));
   //IBUF  rstpad (.I(RESET), .O(RESET_w));
   //commented out the IBUFG because it was causing Xilinx Problems
   //says Jack 10/11/2003
   CLKDLLE  dll (.CLKIN(CLKIN_w), .CLKFB(CLK0), .RST(RESET), 
		.CLK0(CLK0_dll), .CLK90(), .CLK180(), .CLK270(),
		.CLK2X(), .CLKDV(CLK_DIV), .LOCKED(LOCKED_dll));

   /* synthesis translate_off */
   defparam dll.STARTUP_WAIT = TRUE; 
   defparam dll.CLKDV_DIVIDE = 4.0;
   /* synthesis translate_on */
   //you can use similar attributes here to set the parameters inside of the clkdlle module
   //values you set using defpram here will overwrite parameter values inside of the clkdlle
   //look inside of the clkdlle file to see more examples.

   BUFG   clkg   (.I(CLK0_dll), .O(CLK0));
   BUFG   clkdiv   (.I(CLK_DIV), .O(CLK_DIV_OUT));
   OBUF   lckpad (.I(LOCKED_dll), .O(LOCKED));

endmodule