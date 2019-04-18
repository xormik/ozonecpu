module data_source(addr, en, clk, dout);

  input [10:0] addr; // can reference mem address 0 to 2047
  input en;
  input clk;
  output [31:0] dout;



  // we do not write to data source, therefore just set din=32'b0
  // and we=1'b0 in ramblock2048b(addr, clk, din, dout, asynchdout, 1, we);

	`ifdef synthesis
			//datasource(addr,clk,di,en,rst,we,do);
			datasource tempBlock(.addr(addr), .clk(clk), .di(32'b0), .en(en), .rst(1'b0), .we(1'b0), .do(dout));

	`else
		  wire [31 : 0] asynchdout;
		  datasource tempBlock(addr, clk, 32'b0, dout, asynchdout, en, 1'b0);

		  // ramblock port list
		  // ramblock2048b tempBlock(.addr(addr), .clk(clk), .din(din), .dout2(dout), 
		  //				    .en(1), .we(we));



		  //----------EDIT MEMORY INITIALIZATION FILE HERE---------------------
		  defparam tempBlock.inputFile = "datasource.contents";
		  //---------- if you want to have this mem block initialize with the
		  //---------- initialization file, set noInitVector to 0, else the mem
		  //---------- block will initialize to all 0 values.
		  defparam tempBlock.noInitVector = 0;
		  //-------------------------------------------------------------------
	`endif

endmodule
