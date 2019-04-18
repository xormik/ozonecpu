module tagsfile (clk, rst, we, set_addr, set_element, tag_in, valid_in,
			  tag_out0, tag_out1, valid_out0, valid_out1,
			  set_addr_2, 
			  tag_out0_2, tag_out1_2, valid_out0_2, valid_out1_2);

	input clk;
	input rst;
	input we;
	input [6:0] set_addr, set_addr_2; 	// the 2-way set associative set address
	input set_element;				// select the correct block within the set, *ONLY FOR WRITING TAGSFILE*
	input [12:0] tag_in;	
	input valid_in;
	output [12:0] tag_out0, tag_out0_2;	// tag for set address addr, set element 0
	output [12:0] tag_out1, tag_out1_2;	// tag for set address addr, set element 1
	output valid_out0, valid_out0_2;
	output valid_out1, valid_out1_2;

	wire we_reg, set_element_reg;
	wire [6:0] set_addr_reg, set_addr_2_reg;
	register #(16) allRegs (.DIN({we, set_element, set_addr, set_addr_2}), 
						.DOUT({we_reg, set_element_reg, set_addr_reg, set_addr_2_reg}), 
						.WE(1'b1), .RST(rst), .CLK(clk));

	wire [12:0] tag_out0_2_pre;
	wire [12:0] tag_out1_2_pre;

	// tagsfile for all blocks that are element 0 within the set
	ram13x128 tagsfile0 (
		.addra(set_addr_2),
		.addrb(set_addr),
		.clka(clk),
		.clkb(clk),
		.dinb(tag_in),
		.douta(tag_out0_2_pre),
		.doutb(tag_out0),
		.web(we & ~set_element));

	// tagsfile for all blocks that are element 1 within the set
	ram13x128 tagsfile1 (
		.addra(set_addr_2),
		.addrb(set_addr),
		.clka(clk),
		.clkb(clk),
		.dinb(tag_in),
		.douta(tag_out1_2_pre),
		.doutb(tag_out1),
		.web(we & set_element));

	assign tag_out0_2 = (we_reg & /*~set_element_reg &*/ set_addr_reg == set_addr_2_reg) ? tag_out0 : tag_out0_2_pre;
	assign tag_out1_2 = (we_reg & /*set_element_reg &*/ set_addr_reg == set_addr_2_reg) ? tag_out1 : tag_out1_2_pre;



	// valid bit is implemented as register so we can reset it
	wire [127:0] valid_reg0_out, valid_reg1_out;
	wire [127:0] valid_reg0_in, valid_reg1_in;

	register #(128) valid_bits0 (.DIN(valid_reg0_in), .DOUT(valid_reg0_out), 
				.WE(we & ~set_element), .CLK(clk), .RST(rst));

	register #(128) valid_bits1 (.DIN(valid_reg1_in), .DOUT(valid_reg1_out), 
				.WE(we & set_element), .CLK(clk), .RST(rst));

	assign valid_reg0_in = valid_reg0_out | 
					({127'b0, (we & ~set_element & valid_in)} << {1'b0, set_addr});

	assign valid_reg1_in = valid_reg1_out | 
					({127'b0, (we & set_element & valid_in)} << {1'b0, set_addr});

	// valid_out put into posedge clk block to synchronize register and blockram

	reg valid_out0, valid_out0_2;
	reg valid_out1, valid_out1_2;

//	always @ (valid_reg0_out or valid_reg1_out or set_addr or set_addr_2) begin
	always @ (posedge clk) begin // we want to delay valid by a cycle just like rest of tagsfile
		valid_out0 = valid_reg0_out >> set_addr;
		valid_out1 = valid_reg1_out >> set_addr;
		valid_out0_2 = valid_reg0_out >> set_addr_2;
		valid_out1_2 = valid_reg1_out >> set_addr_2;
	end


endmodule
