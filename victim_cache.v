/* Victim Cache
   To Do: Figure out a more elegant method to implement LRU.
 */

module victim_cache(clk,rst,addr,evict,victim_in,victim_out,dout,hit);

	input clk;			// Clock
	input rst;			// Reset
	input evict;			// Signal from cache that entry is being evicted.
	input [22:0] addr;		// Address of memory requested by processor.
	input [255:0] victim_in;	// Cache line being evicted by cache.
	output [255:0] victim_out;	// On victim cache hit, output cache line back to cache.
	output [31:0] dout;		// On victim cache hit, output requested data to processor
	output hit;			// Signal a victim cache hit.

	wire [19:0] addr1,addr2,addr3,addr4;	// Note that these are blk addressed.
	wire [255:0] victim1,victim2,victim3,victim4;
	wire valid1,valid2,valid3,valid4;
	wire we1,we2,we3,we4;

	/* Counters to implement LRU for victim cache.
	 * Initialized to LRU1=0,LRU2=1,LRU3=2,LRU4=3.
	 * On cache evict, replace entry i where LRUi == 0,
	 *  resetting it 3, and decrementing all others.
	 * On victime cache hit, we swap entries with the cache,
	 *  so set LRUi of swapped entry to 3, and decrement LRUj where j > i.
	 */
	reg [0:1] LRU1;
	reg [0:1] LRU2;
	reg [0:1] LRU3;
	reg [0:1] LRU4;

	/* On cache evict, replace entry i where LRUi == 0,
	 *  resetting it 3, and decrementing all others.
	 */
	always @ (evict) begin
		LRU1 <= ~LRU1 ? (LRU1 - 1) : 2'd3;
		LRU2 <= ~LRU2 ? (LRU2 - 1) : 2'd3;
		LRU3 <= ~LRU3 ? (LRU3 - 1) : 2'd3;
		LRU4 <= ~LRU4 ? (LRU4 - 1) : 2'd3;
	end

	/* On victime cache hit, we swap entries with the cache,
	 *  so set LRUi of swapped entry to 3, and decrement LRUj where j > i.
	 */
	always @ (hit) begin
		if (addr[22:3] == addr1 & valid1) begin
			if (LRU2 > LRU1) LRU2 = LRU2 - 1;
			if (LRU3 > LRU1) LRU3 = LRU3 - 1;
			if (LRU4 > LRU1) LRU4 = LRU4 - 1;
			LRU1 = 2'd3;
		end
		else if (addr[22:3] == addr2 & valid2) begin
			if (LRU1 > LRU2) LRU1 = LRU1 - 1;
			if (LRU3 > LRU2) LRU3 = LRU3 - 1;
			if (LRU4 > LRU2) LRU4 = LRU4 - 1;
			LRU1 = 2'd3;
		end
		else if (addr[22:3] == addr3 & valid3) begin
			if (LRU1 > LRU3) LRU1 = LRU1 - 1;
			if (LRU2 > LRU3) LRU2 = LRU2 - 1;
			if (LRU4 > LRU3) LRU4 = LRU4 - 1;
			LRU1 = 2'd3;
		end
		else if (addr[22:3] == addr4 & valid4) begin
			if (LRU1 > LRU4) LRU1 = LRU1 - 1;
			if (LRU2 > LRU4) LRU2 = LRU2 - 1;
			if (LRU3 > LRU4) LRU3 = LRU3 - 1;
			LRU1 = 2'd3;
		end

		/* Want to only decrement those which are greater than the one being replaced.
		 * Code below does not do that, thus the code above.
		LRU1 = (addr == addr1 & addr1[19]) ? 2'd3 : (LRU1 - 1);
		LRU2 = (addr == addr2 & addr2[19]) ? 2'd3 : (LRU2 - 1);
		LRU3 = (addr == addr3 & addr3[19]) ? 2'd3 : (LRU3 - 1);
		LRU4 = (addr == addr4 & addr4[19]) ? 2'd3 : (LRU4 - 1);
		 */
	end

	/* Victim cache entries are invalidated on reset,
	 * and becomes valid when an entry is evicted from the cache into the victim cache.
	 * Once an entry in the victim cache becomes valid, it always stays valid.
	 */
	register #(1) valid1_reg (.DIN(1'b1), .DOUT(valid1), .WE(evict & ~valid1 & ~LRU1), .CLK(clk), .RST(rst));
	register #(1) valid2_reg (.DIN(1'b1), .DOUT(valid2), .WE(evict & ~valid2 & ~LRU2), .CLK(clk), .RST(rst));
	register #(1) valid3_reg (.DIN(1'b1), .DOUT(valid3), .WE(evict & ~valid3 & ~LRU3), .CLK(clk), .RST(rst));
	register #(1) valid4_reg (.DIN(1'b1), .DOUT(valid4), .WE(evict & ~valid4 & ~LRU4), .CLK(clk), .RST(rst));

	ram20x2 block_addr12(
		addra(0),
		addrb(1),
		clka(clk),
		clkb(clk),
		dina({addr[22:3]}),
		dinb({addr[22:3]}),
		douta(addr1),
		doutb(addr2),
		sinita(rst),
		sinitb(rst),
		wea(we1),
		web(we2)
	);
	ram20x2 block_addr34(
		addra(0),
		addrb(1),
		clka(clk),
		clkb(clk),
		dina({addr[22:3]}),
		dinb({addr[22:3]}),
		douta(addr3),
		doutb(addr4),
		sinita(rst),
		sinitb(rst),
		wea(we3),
		web(we4)
	);
	
	ram256x2 victim12(
		addra(0),
		addrb(1),
		clka(clk),
		clkb(clk),
		dina(victim_in),
		dinb(victim_in),
		douta(victim1),
		doutb(victim2),
		sinita(rst),
		sinitb(rst),
		wea(we1),
		web(we2)
	);
	ram256x2 victim34(
		addra(0),
		addrb(1),
		clka(clk),
		clkb(clk),
		dina(victim_in),
		dinb(victim_in),
		douta(victim3),
		doutb(victim4),
		sinita(rst),
		sinitb(rst),
		wea(we3),
		web(we4)
	);

	assign hit = (addr[22:3] == addr1[19:0] | addr[22:3] == addr2[19:0] | addr[22:3] == addr3[19:0] | addr[22:3] == addr4[19:0]);

	assign victim_out = (addr[22:3] == addr1 & valid1) ? (victim1) :
				(addr[22:3] == addr2 & valid2) ? (victim2) :
				(addr[22:3] == addr3 & valid3) ? (victim3) :
				(addr[22:3] == addr4 & valid4) ? (victim4) :
				256'h0;

	assign we1 = (evict & LRU1) | (hit & valid1 & addr[22:3] == addr1);
	assign we2 = (evict & LRU2) | (hit & valid2 & addr[22:3] == addr2);
	assign we3 = (evict & LRU3) | (hit & valid3 & addr[22:3] == addr3);
	assign we4 = (evict & LRU4) | (hit & valid4 & addr[22:3] == addr4);

	assign dout = (addr[2:0] == 3'd0) ? victim_out[31:0] :
			(addr[2:0] == 3'd1) ? victim_out[63:32] :
			(addr[2:0] == 3'd2) ? victim_out[95:64] :
			(addr[2:0] == 3'd3) ? victim_out[127:96] :
			(addr[2:0] == 3'd4) ? victim_out[159:128] :
			(addr[2:0] == 3'd5) ? victim_out[191:160] :
			(addr[2:0] == 3'd6) ? victim_out[223:192] :
			(addr[2:0] == 3'd7) ? victim_out[255:224];

	/*
	always @ (posedge clk) begin
		if (rst) begin
			LRU1 <= 2'd0;
			LRU2 <= 2'd1;
			LRU3 <= 2'd2;
			LRU4 <= 2'd3;
		end
	end
	*/

endmodule