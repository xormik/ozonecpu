module memio(rst, clk, din, dout, we, en, writeAddr, readAddr, 
			in_bus, out_bus, out_sel, MEM_addr);

  input rst;
  input [22:0] writeAddr;	// 23-bit word, addressable
  input [22:0] readAddr;  
  input clk;
  
  input [31:0] din;
  output [31:0] dout;
  
  input we;
  input en; // if EX/MEM pipeline register is stalling, en == 0
  input out_sel;
  input [7:0] in_bus;

  output [31:0] out_bus;

  input [22:0] MEM_addr;

	



  wire  [31:0] counter_out;
  wire  [31:0] dataSrc_out;
  reg [31:0] dout_internal;

  reg [31:0] dp0, dp1;
  wire [31:0] dout;

  `ifdef synthesis
  `else
    integer out_fd = 0;
    integer in_fd = 0;
    initial begin
      out_fd = $fopen("iooutput.trace", "w");
	 in_fd = $fopen("ioinput.trace", "r");
    end
  `endif

  counter #(32) thirtytwo_counter(.OUT(counter_out),
				   		    .CLK(clk),
		     		  	    .ENABLE(1'b1),
		     		  	    .RESET(rst));

  wire [63:0] count64;
  reg count64_en;  // enable 64 bit cycle counter; also doubles as state
  reg count64_rst;

  counter #(64) counter64(.OUT(count64),
  					 .CLK(clk),
					 .ENABLE(count64_en),
					 .RESET(count64_rst));

  `ifdef synthesis
  // the arguments for data_source need to be checked in the following line.
  // maybe consider data_source vs. datasource.
  data_source myDataSrc (.addr(readAddr[10:0]), .en(en), .clk(clk), .do(dataSrc_out));
  `else
  data_source myDataSrc (.addr(readAddr[10:0]),
  					.en(en),
                         .clk(clk),
					.dout(dataSrc_out)
					);
  `endif
					 
  always @ (posedge clk) begin
    if (rst) begin
      dout_internal <= 32'b0;
      dp0 <= 32'b0;
      dp1 <= 32'b0;
	 count64_en <= 1'b0;		// enable 64 bit counter at global rst
      count64_rst <= 1'b1;	// reset 64 bit counter at global rst
    end
    else begin

          count64_rst <= 1'b0;		

		if (we & en) begin // store word
			case (writeAddr)	 
			23'h7FFFFC: begin
		     `ifdef synthesis
			  dp0 <= din;
			`else
			  //$fscanf(in_fd, "%h\n", dp0);
			  dp0 = din;
			  $display("I/O write to DP0: %h", dp0);			
			  $fwrite(out_fd, "I/O write to DP0: %h\n", dp0);
			`endif
			end
			23'h7FFFFD: begin
	          `ifdef synthesis
	            dp1 <= din;
			`else
	            //$fscanf(in_fd, "%h\n", dp1);
	            dp1 = din;
	            $display("I/O write to DP1: %h", dp1);				
	            $fwrite(out_fd, "I/O write to DP1: %h\n", dp1);			 
	          `endif
	        	end
		     23'h7FFFBE: begin	// write timer command
			`ifdef synthesis
				case(din)
				32'h00000001: count64_rst <= 1'b1;
				32'h00000002: count64_en <= 1'b1;
				32'h00000004: count64_en <= 1'b0;
				endcase
			`else
				case(din)
				32'h00000001: begin
				  count64_rst <= 1'b1;
				  $display("Reset 64-bit counter");
				  $write(out_fd, "Reset 64-bit counter");
				end
				32'h00000002: begin
				  count64_en <= 1'b1;
				  $display("Start 64-bit counter");
				  $write(out_fd, "Start 64-bit counter");
				end
				32'h00000004: begin
				  count64_en <= 1'b0;
				  $display("Stop 64-bit counter");
				  $write(out_fd, "Stop 64-bit counter");
				end
				endcase
			`endif
			end
 						

			endcase
		end

		if (en) begin //reading mem (load word)
		     case (readAddr)
			23'h7FFFFC: dout_internal <= dp0;	// h7ffffc
			23'h7FFFFD: dout_internal <= dp1;	// h7ffffd
			23'h7FFFFE: begin
		       `ifdef synthesis
		         dout_internal <= {24'b0, in_bus};
		       `else
		         $fscanf(in_fd, "%h\n", dout_internal);
			    $display("Reading from dipswitch");
		       `endif
		      end
			23'h7FFFFF: dout_internal <= counter_out; //For the Cycle Counter	// h7fffff
		   	23'h7FFFBC: dout_internal <= count64[31:0]; 			// read lower 32-bits
			23'h7FFFBD: dout_internal <= count64[63:32];			// read upper 32-bits
			23'h7FFFBE: dout_internal <= {31'h0, count64_en};		// read timer state
			default: dout_internal <= 32'h0;  // solve fix for dout_internal outputting 32'hx;
			endcase
    		end
	end
end    
//wire [22:0] addr_reg;
//register #(23) addr_register(.DIN(addr), .DOUT(addr_reg), .WE(1'b1), .CLK(clk), .RST(rst));

assign out_bus = (out_sel) ? dp1 : dp0;
//assign dout = (addr_reg[22:11] == 12'h0) ? dataSrc_out : dout_internal;
assign dout = (readAddr[22:11] == 12'h0) ? dataSrc_out : dout_internal;
//used this instead of addr_reg to make sure if EX/MEM pipeline register
//stalls, we still output the correct dout value


endmodule
