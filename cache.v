module cache (clk, en, rst, word_addr_read, word_addr_write, din, write_if_cached, line_in, 
			mem_req, tag_index_mem, we_mem, dout);

	input clk;
	input en;				// if deasserted, *certain* registers freeze
	input rst;			// it's for tagsfile and random register
	input [22:0] word_addr_read;	// from pipeline, for lw

	input [22:0] word_addr_write; // from store buffer, for possibly updating cache entry
	input [31:0] din;		// from store buffer
	input write_if_cached;	// from store buffer.  will update cache entry at the second cycle if data is cached

	input [255:0] line_in;	// from memory
//	input [255:0] victim_in;	// from victim cache
//	input victim_swap;		// asserted if swapping cache line with victim cache

	
	output mem_req;		// memory request.  Asserted if requesting data from memory
	output [22:0] tag_index_mem;  // The block cache requests to read
	input we_mem;			// asserted when din_mem is valid

	output [31:0] dout;		// output to pipeline
//	output [255:0] victim_out; // evicted cache line
//	output evict;			// asserted when cache is evicting a cache line

	wire [12:0] tag;		// 13 bits for 2-way set associative cache
	wire [6:0] index;		// set index (7 bits as there are 128 sets total)
	wire [2:0] word_offset;  // 8 words in a block
	reg set_element;		// selects the correct element (0 or 1) within a block

	wire [12:0] tag_out0, tag_out1;
	wire valid_out0, valid_out1;
	wire [12:0] tag_out0_2, tag_out1_2;
	wire valid_out0_2, valid_out1_2;

	wire tag_match0, tag_match1;
	// Just a reminder: _2 is associated with the port dedicated to write_if_cached
	wire tag_match0_2, tag_match1_2; // update cache only if tag_match0_2 | tag_match1_2
	wire tag_miss;
	wire tag_miss_2;

	wire [12:0] write_tag; 
	wire [6:0] write_index;  // index for tagsfile and cache will be different when writing!
	wire [2:0] write_offset;


	wire write_if_cached_reg;
	register #(1) write_if_cached_register (.DIN(write_if_cached), .DOUT(write_if_cached_reg), .WE(1'b1), .CLK(clk), .RST(rst));

	wire [22:0] word_addr_read_reg;
	register #(23) word_addr_read_register (.DIN(word_addr_read), .DOUT(word_addr_read_reg), .WE(en), .CLK(clk), .RST(rst));

	assign {tag, index, word_offset} = word_addr_read;
	assign {write_tag, write_index, write_offset} = word_addr_write;

	wire [12:0] write_tag_reg;
	wire [6:0] write_index_reg;
	wire [2:0] write_offset_reg;
	register #(23) word_addr_write_register (.DIN({write_tag, write_index, write_offset}), .DOUT({write_tag_reg, write_index_reg, write_offset_reg}), 
									.WE(en), .CLK(clk), .RST(rst));	

	wire [12:0] tag_reg;
	register #(13) tag_register (.DIN(tag), .DOUT(tag_reg), .WE(en), .CLK(clk), .RST(rst));

	assign tag_index_mem = {word_addr_read_reg[22:3],3'b0};

	wire [31:0] din_reg;

	register #(32) din_register (.DIN(din), .DOUT(din_reg), .WE(en), .CLK(clk), .RST(rst));


	// Cache 

	wire [255:0] cache_line0, cache_line1;

	
	// true dual port, nice!
	// ram block for all set_element 0 blocks
	ram32x1024 cache0 (
		.addra({write_index_reg, write_offset_reg}),
		.addrb(index),
		.clka(clk),
		.clkb(clk),
		.dina(din_reg),
//		.dinb((victim_swap) ? victim_in : line_in),
		.dinb(line_in),
		.douta(),
		.doutb(cache_line0),
		.wea(write_if_cached_reg & tag_match0_2 & ~(we_mem & ~set_element)),
		                                        // if we_mem and write_if_cached at the same time
										// write_if_cached will give way because
										// the next cycle write_if_cached will still
										// be on
//		.web((we_mem | victim_swap) & ~set_element));
		.web(we_mem & ~set_element));

	// ram block for all set_element 1 blocks
	ram32x1024 cache1 (
		.addra({write_index_reg, write_offset_reg}),
		.addrb(index),
		.clka(clk),
		.clkb(clk),
		.dina(din_reg),
		.dinb(line_in),
		.douta(),
		.doutb(cache_line1),
		.wea(write_if_cached_reg & tag_match1_2 & ~(we_mem & set_element)),
		.web(we_mem & set_element));



	reg [31:0] curr_dout;

	wire [255:0] curr_line;
	assign curr_line = (set_element) ? cache_line1 : cache_line0;

	always @ (word_addr_read_reg[2:0] or curr_line) begin
		case (word_addr_read_reg[2:0])
		3'd0: curr_dout <= curr_line[31:0];
		3'd1: curr_dout <= curr_line[63:32];
		3'd2: curr_dout <= curr_line[95:64];
		3'd3: curr_dout <= curr_line[127:96];
		3'd4: curr_dout <= curr_line[159:128];
		3'd5: curr_dout <= curr_line[191:160];
		3'd6: curr_dout <= curr_line[223:192];
		3'd7: curr_dout <= curr_line[255:224];
		endcase
	end
	

	wire en_reg;
	register #(1) en_register (.DIN(en), .DOUT(en_reg), .WE(1'b1), .CLK(clk), .RST(1'b0));

	wire [31:0] dout_reg;
	register #(32) dout_register (.DIN(curr_dout), .DOUT(dout_reg), .WE(en_reg & ~en), .CLK(clk), .RST(1'b0));

	assign dout = (~en_reg) ? dout_reg : curr_dout;
	
//	assign victim_out = curr_line;
//	assign evict = we_mem & (tag_match0 | tag_match1);

	// tagsfile

	tagsfile tagsfile0 (.set_addr(index),
					.we(we_mem), .set_element(set_element), // set_element to write to
					.tag_in(tag_reg), .valid_in(1'b1),
					.tag_out0(tag_out0), .valid_out0(valid_out0), 
					.tag_out1(tag_out1), .valid_out1(valid_out1), 
					.set_addr_2(write_index),
					.tag_out0_2(tag_out0_2), .valid_out0_2(valid_out0_2), 
					.tag_out1_2(tag_out1_2), .valid_out1_2(valid_out1_2), 
					.clk(clk), .rst(rst));


	// Set element selector

	wire rand_bit;
	register #(1) random_bit (.DIN(~rand_bit), .DOUT(rand_bit), .WE(1'b1), .CLK(clk), .RST(rst));

	/*   set_element truth table / Replacement policy:

		a = valid_out0
		b = tag_out0 == tag
		c = valid_out1
		d = tag_out1 == tag
		e = desired set_element when writing (we)
		f = desired set_element when reading (~we)
		g = actual set_element

          a b c d    e     f    g
		------------------------
		0 0 0 0    r	  x    r 
		0 0 0 1    r	  x 	  r 
		0 0 1 0    0     x    0 
		0 0 1 1    1     1    1
		0 1 0 0    r     x    r
		0 1 0 1    r     x    r
		0 1 1 0    0     x    0
		0 1 1 1    1     1    1
		1 0 0 0    1     x    1
		1 0 0 1    1     x    1
		1 0 1 0    r     x    r
		1 0 1 1    1     1    1
		1 1 0 0    0     0    0
		1 1 0 1    0     0    0
		1 1 1 0    0     0    0
		1 1 1 1  Error Error  0	  (block not supposed to go into both set elements)

		(r = rand_bit, x = don't care)
	*/


	assign tag_match0 = valid_out0 & (tag_out0 == tag_reg);
	assign tag_match1 = valid_out1 & (tag_out1 == tag_reg);
	assign tag_match0_2 = valid_out0_2 & (tag_out0_2 == write_tag_reg);
	assign tag_match1_2 = valid_out1_2 & (tag_out1_2 == write_tag_reg);

//	wire set_element_reg;
//	register #(1) set_element_register (.DIN(set_element), .DOUT(set_element_reg), .WE(1'b1), .CLK(clk), .RST(1'b0));

	wire we_mem_reg;
	register #(1) we_mem_register (.DIN(we_mem), .DOUT(we_mem_reg), .WE(1'b1), .CLK(clk), .RST(1'b0));

	always @ (tag_reg or tag_out0 or tag_out1 or valid_out0 or valid_out1 or rand_bit or
			tag_match0 or tag_match1) begin
		if (tag_match0 || (~valid_out0 & valid_out1 & (tag_out1 != tag_reg)))
			set_element = 1'b0;
		else if (tag_match1 || (valid_out0 & ~valid_out1 & (tag_out0 != tag_reg)))
			set_element = 1'b1;
		else
			set_element = rand_bit;
	end

	
	// memory request

//	wire mem_req_reg;

	assign tag_miss = ~tag_match0 & ~tag_match1;

	assign tag_miss_2 = ~tag_match0_2 & ~tag_match1_2;

//	register #(1) mem_req_register (.DIN(tag_miss & ~we_mem), .DOUT(mem_req_reg), .CLK(clk), 
//							.WE(tag_miss | we_mem), .RST(1'b0));	

	//assign mem_req = tag_miss | mem_req_reg;
	assign mem_req = tag_miss & ~(we_mem | we_mem_reg);

	// sanity check: 
	// 1) we_mem and we should never be asserted at the same time
	// 2) for a given tagsfile index, valid0 and valid1 cannot be asserted at the same
	//    time if tags0 == tags1.  (entry cannot go in both set elements)
	wire ERROR;			
	assign ERROR = (we_mem & write_if_cached_reg) | 
				(valid_out0 & valid_out1 & (tag_out0 == tag_out1)) |
				(valid_out0_2 & valid_out1_2 & (tag_out0_2 == tag_out1_2));

	
endmodule
