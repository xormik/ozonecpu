// Module: load buffer
// Author: Thomas Yiu, Mike Lee
// Interfaces with: dispatch unit
// lw $1, 100 ($2);  rt=$1, rs=$2, imm=100

module load_buffer(immed_in, Vj_in, Qj_in, issue, issued_to_in, cdb_in, cdb_en, 
				data, data_mem_req, write_if_cached, write_addr,
				bus_granted, clk, rst, flush, full, cdb_out, req_bus,
				loadAddrBus, issued_to1, issued_to2, issued_to3, issued_to4, 
				issued_to5, issued_to6, curr_ptr, loadIsCC,
				rob_loadDataValid, rob_readyToExe, rob_commitPtr);
	input [15:0] immed_in;
	input [31:0] Vj_in;
	input [4:0] Qj_in; // register status.  it's an ROB number
	input issue; // asserted for one cycle when load instruction is issued
	input [4:0] issued_to_in; // the ROB slot being issued to
	input [36:0] cdb_in;
	input cdb_en;
	
	input [31:0] data; // can come from data_cache or store_buffer
	input data_mem_req;
	// ** when data comes in from memory, if the slot is no longer valid, then ignore! ** \\

	input [22:0] write_addr; // comes from rob; used to determine if we're trying to
						// load word from cache while rob is writing to the same address
	input write_if_cached;  // signal rob uses to write to the data cache
	

	input bus_granted;
	input clk;
	input rst; 
	input flush;
	input [4:0] rob_commitPtr; // we'll check the rob_commitPtr against the issued_to number of our entries
					       // to see if it's the branch delay slot; if it is, we cannot flush it


	input rob_loadDataValid;
	input [6:1] rob_readyToExe; // not ready to execute if there are dependent sw instructions
							// in the rob

	output full;
	output [68:0] cdb_out;
	output req_bus; // requests common data bus access

	output [28:0] loadAddrBus;
	output [4:0] issued_to1; // send to ROB
	output [4:0] issued_to2;
	output [4:0] issued_to3;
	output [4:0] issued_to4;
	output [4:0] issued_to5;
	output [4:0] issued_to6;
	output [2:0] curr_ptr;							   
	output [6:1] loadIsCC; // tells if the load instruction is a cycle counter operation

	parameter data_ready = 5'h0;

	wire [4:0] cdb_in_tag;
	wire [31:0] cdb_in_data;
	assign cdb_in_tag = cdb_in[36:32];
	assign cdb_in_data = cdb_in[31:0];
	
	reg [2:0] curr_ptr; // points at current entry.  Current entry goes around modulo looking for next entry whose valid bit is 1 and Qj is zero
	reg [2:0] next_ptr; // points at the next empty entry that we can write to (whose valid bit is 0)

	// Load buffer entry:
	// | ------- Vj (32 bits) ------ | Qj (5 bits) | immed (16 bits) | issued_to (5 bits) | valid (1 bit) |

	reg [31:0] Vj[0:6];
	reg [4:0] Qj[0:6];
	reg [15:0] immed[0:6];
	reg [4:0] issued_to[0:6];
	reg valid[0:6];

	reg cdb_in_Qj[0:6];
	always @ (cdb_in_tag or Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or Qj[6] or cdb_en)
	  begin
	  	cdb_in_Qj[1] <= cdb_en & cdb_in_tag == Qj[1];
	  	cdb_in_Qj[2] <= cdb_en & cdb_in_tag == Qj[2];
	  	cdb_in_Qj[3] <= cdb_en & cdb_in_tag == Qj[3];
	  	cdb_in_Qj[4] <= cdb_en & cdb_in_tag == Qj[4];
	  	cdb_in_Qj[5] <= cdb_en & cdb_in_tag == Qj[5];
	  	cdb_in_Qj[6] <= cdb_en & cdb_in_tag == Qj[6];
	  end		   

	reg ready_to_exe[0:6];
	always @ (Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or Qj[6] or cdb_in_Qj[1] or 
			cdb_in_Qj[2] or cdb_in_Qj[3] or cdb_in_Qj[4] or cdb_in_Qj[5] or cdb_in_Qj[6] or 
			valid[1] or valid[2] or valid[3] or valid[4] or valid[5] or valid[6] or
			rob_readyToExe)
	  begin
		ready_to_exe[1] <= valid[1] & (!Qj[1]/* | cdb_in_Qj[1]*/) & rob_readyToExe[1];
		ready_to_exe[2] <= valid[2] & (!Qj[2]/* | cdb_in_Qj[2]*/) & rob_readyToExe[2];
		ready_to_exe[3] <= valid[3] & (!Qj[3]/* | cdb_in_Qj[3]*/) & rob_readyToExe[3];
		ready_to_exe[4] <= valid[4] & (!Qj[4]/* | cdb_in_Qj[4]*/) & rob_readyToExe[4];
		ready_to_exe[5] <= valid[5] & (!Qj[5]/* | cdb_in_Qj[5]*/) & rob_readyToExe[5];
		ready_to_exe[6] <= valid[6] & (!Qj[6]/* | cdb_in_Qj[6]*/) & rob_readyToExe[6];
	  end

/* Thomas thinks we don't need this anymore since we're now ensuring that
   we won't try to rollback if delay slot is not ready

	// determining possible branch delay slot.  when flush signal comes in, we flush all
	// slots except the possible branch delay instruction
	wire [4:0] branchDelayRobEntry; // this is rob_commitPtr + 1;
	wire [2:0] branchDelayPtr;
	wire [2:0] branchDelayPtr_plus1;
	assign branchDelayRobEntry = (rob_commitPtr == 31) ? 1 : (rob_commitPtr + 31);
	assign branchDelayPtr = (branchDelayRobEntry == issued_to[6]) ? 6 :
					    (branchDelayRobEntry == issued_to[5]) ? 5 :
					    (branchDelayRobEntry == issued_to[4]) ? 4 :
					    (branchDelayRobEntry == issued_to[3]) ? 3 :
					    (branchDelayRobEntry == issued_to[2]) ? 2 :
					    (branchDelayRobEntry == issued_to[1]) ? 1 : 0;
	assign branchDelayPtr_plus1 = (branchDelayPtr == 6) ? 1 : (branchDelayPtr + 1);
*/


	// next/curr pointer logic
	  // If buffer is full, next_ptr stays at previous slot but valid[next_ptr] == 1
	  // If no slot is ready, curr_ptr stays at previous slot but valid[next_ptr] == 0

	wire [2:0] curr_plus1, curr_plus2, curr_plus3, curr_plus4, curr_plus5,
			 next_plus1, next_plus2, next_plus3, next_plus4, next_plus5;

	assign curr_plus1 = (curr_ptr == 6) ? 1 : (curr_ptr + 1);
	assign curr_plus2 = (curr_ptr == 6) ? 2 :
						     (curr_ptr == 5) ? 1 : (curr_ptr + 2);
	assign curr_plus3 = (curr_ptr == 6) ? 3 :
						     (curr_ptr == 5) ? 2 : 
							  (curr_ptr == 4) ? 1 : (curr_ptr + 3);
	assign curr_plus4 = (curr_ptr == 6) ? 4 :
						     (curr_ptr == 5) ? 3 : 
							  (curr_ptr == 4) ? 2 : 
							  (curr_ptr == 3) ? 1 : (curr_ptr + 4);
	assign curr_plus5 = (curr_ptr == 6) ? 5 :
						     (curr_ptr == 5) ? 4 : 
							  (curr_ptr == 4) ? 3 : 
							  (curr_ptr == 3) ? 2 : 
							  (curr_ptr == 2) ? 1 : (curr_ptr + 5);

  	assign next_plus1 = (next_ptr == 6) ? 1 : (next_ptr + 1);
	assign next_plus2 = (next_ptr == 6) ? 2 :
						     (next_ptr == 5) ? 1 : (next_ptr + 2);
	assign next_plus3 = (next_ptr == 6) ? 3 :
						     (next_ptr == 5) ? 2 : 
							  (next_ptr == 4) ? 1 : (next_ptr + 3);
	assign next_plus4 = (next_ptr == 6) ? 4 :
						     (next_ptr == 5) ? 3 : 
							  (next_ptr == 4) ? 2 : 
							  (next_ptr == 3) ? 1 : (next_ptr + 4);
	assign next_plus5 = (next_ptr == 6) ? 5 :
						     (next_ptr == 5) ? 4 : 
							  (next_ptr == 4) ? 3 : 
							  (next_ptr == 3) ? 2 : 
							  (next_ptr == 2) ? 1 : (next_ptr + 5);

	always @ (posedge clk)
	  begin
	  	if (rst | flush)
		  begin
			curr_ptr <= 1;
			next_ptr <= 1;
		  end
/*
		else if (flush)
		  begin
			curr_ptr <= (branchDelayPtr) ? branchDelayPtr : 1;
			next_ptr <= (branchDelayPtr) ? branchDelayPtr_plus1 : 1;
		  end
*/
		else 
		  begin
		  	// curr_ptr;
			if (bus_granted | ~ready_to_exe[curr_ptr])
			  begin
				if (ready_to_exe[curr_plus1])
			  		curr_ptr <= curr_plus1;
				else if (ready_to_exe[curr_plus2])
			  		curr_ptr <= curr_plus2;
				else if (ready_to_exe[curr_plus3])
			  		curr_ptr <= curr_plus3;
				else if (ready_to_exe[curr_plus4])
			  		curr_ptr <= curr_plus4;
				else if (ready_to_exe[curr_plus5])
			  		curr_ptr <= curr_plus5;
				else if (issue & !Qj_in & rob_readyToExe[next_ptr]) // only want to execute if no dependencies
					curr_ptr <= next_ptr;
			  end

			// next_ptr
			if (issue)
			  begin
				if (~valid[next_plus1])
					next_ptr <= next_plus1;
				else if (~valid[next_plus2])
					next_ptr <= next_plus2;
				else if (~valid[next_plus3])
					next_ptr <= next_plus3;
				else if (~valid[next_plus4])
					next_ptr <= next_plus4;
				else if (~valid[next_plus5])
					next_ptr <= next_plus5;
				else if (bus_granted)  // curr_ptr's entry will be free next cycle
					next_ptr <= curr_ptr;
			  end
			else // if ~issue
				if (valid[next_ptr] & bus_granted) // currently buffer is full
					next_ptr <= curr_ptr; // because curr slot is finished
								
		  end
	  end


	// registers
	always @ (posedge clk)
	  begin
	  	if (rst | flush)
		  begin
			{valid[1], immed[1], Vj[1], Qj[1], issued_to[1]} <= 0;
			{valid[2], immed[2], Vj[2], Qj[2], issued_to[2]} <= 0;
			{valid[3], immed[3], Vj[3], Qj[3], issued_to[3]} <= 0;
			{valid[4], immed[4], Vj[4], Qj[4], issued_to[4]} <= 0;
			{valid[5], immed[5], Vj[5], Qj[5], issued_to[5]} <= 0;
			{valid[6], immed[6], Vj[6], Qj[6], issued_to[6]} <= 0;
		  end
/*
		else if (flush)
		  begin
		  	if (~(branchDelayPtr == 1 & valid[1]))
				{valid[1], immed[1], Vj[1], Qj[1], issued_to[1]} <= 0;
		  	if (~(branchDelayPtr == 2 & valid[2]))
				{valid[2], immed[2], Vj[2], Qj[2], issued_to[2]} <= 0;
		  	if (~(branchDelayPtr == 3 & valid[3]))
				{valid[3], immed[3], Vj[3], Qj[3], issued_to[3]} <= 0;
		  	if (~(branchDelayPtr == 4 & valid[4]))
				{valid[4], immed[4], Vj[4], Qj[4], issued_to[4]} <= 0;
		  	if (~(branchDelayPtr == 5 & valid[5]))
				{valid[5], immed[5], Vj[5], Qj[5], issued_to[5]} <= 0;
		  	if (~(branchDelayPtr == 6 & valid[6]))
				{valid[6], immed[6], Vj[6], Qj[6], issued_to[6]} <= 0;
		  end
*/
		else
		  begin
			if (issue)
			  begin
				Vj[next_ptr] <= Vj_in;
				Qj[next_ptr] <= Qj_in;
				immed[next_ptr] <= immed_in;
				issued_to[next_ptr] <= issued_to_in;
				valid[next_ptr] <= 1;
			  end

			if (cdb_in_Qj[1])
			  begin
				Vj[1] <= cdb_in_data;
				Qj[1] <= data_ready;		 
			  end
			if (cdb_in_Qj[2])
			  begin
				Vj[2] <= cdb_in_data;
				Qj[2] <= data_ready;		 
			  end
			if (cdb_in_Qj[3])
			  begin
				Vj[3] <= cdb_in_data;
				Qj[3] <= data_ready;		 
			  end
			if (cdb_in_Qj[4])
			  begin
				Vj[4] <= cdb_in_data;
				Qj[4] <= data_ready;		 
			  end
			if (cdb_in_Qj[5])
			  begin
				Vj[5] <= cdb_in_data;
				Qj[5] <= data_ready;		 
			  end
			if (cdb_in_Qj[6])
			  begin
				Vj[6] <= cdb_in_data;
				Qj[6] <= data_ready;		 
			  end

			if (bus_granted)
				valid[curr_ptr] <= 0;	  	
		  end
	  end

	
	assign full = valid[1] & valid[2] & valid[3] & valid[4] & valid[5] & valid[6];

	wire [22:0] addr_out; // output to data_cache and store_buffer // changed 31:0 to 22:0 -mike on thanksgiving (not error, just warning)
	wire [31:0] immed_ext; // changed 22 to 31 so port connection size matches (warning) -mike on thanksgiving
	extend immed_extend (.in0(immed[curr_ptr]), .out0(immed_ext), .extendType(2'b01));
	wire [31:0] address;
	assign address = (Qj[curr_ptr]) ? 0 : (Vj[curr_ptr] + immed_ext);
	assign addr_out = (ready_to_exe[curr_ptr]) ? address[24:2] : 0; // word addressable

//	assign memio_out = address[31]; 
     // we want output the registered value of the memio bit because we'll use it at the other side of the
	// posedge in the next cycle
	reg memio_out;	  // asserted if loading from memio
	always @ (posedge clk)
	  begin
		memio_out <= address[31];
	  end



	// ready_to_exe_reg is used to determine when data coming from cache, memio, or rob is valid 
	// ready_to_exe_reg always goes high one cycle after curr_ptr switches to a new slot

	reg ready_to_exe_regs[0:6];
	wire ready_to_exe_reg;
	always @ (posedge clk)
	  begin
		ready_to_exe_regs[1] <= (curr_ptr == 1) & ready_to_exe[1];
		ready_to_exe_regs[2] <= (curr_ptr == 2) & ready_to_exe[2];
		ready_to_exe_regs[3] <= (curr_ptr == 3) & ready_to_exe[3];
		ready_to_exe_regs[4] <= (curr_ptr == 4) & ready_to_exe[4];
		ready_to_exe_regs[5] <= (curr_ptr == 5) & ready_to_exe[5];
		ready_to_exe_regs[6] <= (curr_ptr == 6) & ready_to_exe[6];
	  end

	assign ready_to_exe_reg = ready_to_exe_regs[curr_ptr];


	// data is valid one cycle after mem_req goes from high to low, hence the need for its registered value
	reg data_mem_req_reg;
	reg data_mem_req_reg_reg;
	reg [22:0] write_addr_reg;
	reg [22:0] write_addr_reg_reg;
	reg write_if_cached_reg;
	reg write_if_cached_reg_reg;
	always @ (posedge clk)
	  begin
		data_mem_req_reg <= data_mem_req;
		data_mem_req_reg_reg <= data_mem_req_reg;
		write_addr_reg <= write_addr;
		write_addr_reg_reg <= write_addr_reg;
		write_if_cached_reg <= write_if_cached;
		write_if_cached_reg_reg <= write_if_cached_reg;
	  end

	wire writing_to_cache; // if we're trying to load from cache at the same cycle that 
	                       // rob is updating the cache, then we'll wait two cycles for write to complete
	assign writing_to_cache = (addr_out == write_addr_reg_reg) & write_if_cached_reg_reg;

 
	// Data can never be valid at the first posedge after curr_ptr switches.  
	//   ready_to_exe_reg takes care of this.
	// After the first cycle, data is valid either when
	//   1) data_mem_req doesn't go high at all
	//   2) if mem_req goes high, one cycle after it goes low

	// Even if loading from ROB, can get it whenever rob_loadDataValid is asserted,
	// but still have to wait for cache line to be loaded into lw before proceeding
	// with next entry
	wire data_valid;
	assign data_valid = (ready_to_exe_reg & ~data_mem_req & 
			~data_mem_req_reg & ~data_mem_req_reg_reg & ~writing_to_cache);

	wire rob_loadDataValid_reg;
	wire [31:0] data_reg;
	register #(1) rob_loadDataValid_register (.DIN(rob_loadDataValid), .DOUT(rob_loadDataValid_reg), 
			.WE(ready_to_exe[curr_ptr] & ~ready_to_exe_reg), // first cycle of execution
			.CLK(clk), .RST(rst));
	register #(32) data_register (.DIN(data), .DOUT(data_reg), .WE(ready_to_exe[curr_ptr] & ~ready_to_exe_reg), 
			.CLK(clk), .RST(rst));



	assign cdb_out[68:37] = Vj[curr_ptr];
	assign cdb_out[36:32] = issued_to[curr_ptr];
	assign cdb_out[31:0] = (rob_loadDataValid) ? data :  // load from ROB
					   (rob_loadDataValid_reg) ? data_reg : // registered value from ROB
					   data;  // value from data cache
	assign req_bus = valid[curr_ptr] & !Qj[curr_ptr] & data_valid;



	wire [31:0] immed_ext1, immed_ext2, immed_ext3, immed_ext4, immed_ext5, immed_ext6; 
	extend immed_extend1 (.in0(immed[1]), .out0(immed_ext1), .extendType(2'b01));
	extend immed_extend2 (.in0(immed[2]), .out0(immed_ext2), .extendType(2'b01));
	extend immed_extend3 (.in0(immed[3]), .out0(immed_ext3), .extendType(2'b01));
	extend immed_extend4 (.in0(immed[4]), .out0(immed_ext4), .extendType(2'b01));
	extend immed_extend5 (.in0(immed[5]), .out0(immed_ext5), .extendType(2'b01));
	extend immed_extend6 (.in0(immed[6]), .out0(immed_ext6), .extendType(2'b01));
	wire [31:0] address1, address2, address3, address4, address5, address6;
	assign address1 = (!Qj[1]) ? (Vj[1] + immed_ext1) : 0;
	assign address2 = (!Qj[2]) ? (Vj[2] + immed_ext2) : 0;
	assign address3 = (!Qj[3]) ? (Vj[3] + immed_ext3) : 0;
	assign address4 = (!Qj[4]) ? (Vj[4] + immed_ext4) : 0;
	assign address5 = (!Qj[5]) ? (Vj[5] + immed_ext5) : 0;
	assign address6 = (!Qj[6]) ? (Vj[6] + immed_ext6) : 0;
/*
	assign loadAddrBus1 = {issued_to[1], address1[31], address1[24:2]};
	assign loadAddrBus2 = {issued_to[2], address2[31], address2[24:2]};
	assign loadAddrBus3 = {issued_to[3], address3[31], address3[24:2]};
	assign loadAddrBus4 = {issued_to[4], address4[31], address4[24:2]};
	assign loadAddrBus5 = {issued_to[5], address5[31], address5[24:2]};
	assign loadAddrBus6 = {issued_to[6], address6[31], address6[24:2]};
*/

	assign loadAddrBus = {issued_to[curr_ptr], memio_out, addr_out};
	assign issued_to1 = (issue & next_ptr == 1) ? issued_to_in : issued_to[1];
	assign issued_to2 = (issue & next_ptr == 2) ? issued_to_in : issued_to[2];
	assign issued_to3 = (issue & next_ptr == 3) ? issued_to_in : issued_to[3];
	assign issued_to4 = (issue & next_ptr == 4) ? issued_to_in : issued_to[4];
	assign issued_to5 = (issue & next_ptr == 5) ? issued_to_in : issued_to[5];
	assign issued_to6 = (issue & next_ptr == 6) ? issued_to_in : issued_to[6];

	assign loadIsCC[1] = address1[31:4] == 28'hfffffef;
	assign loadIsCC[2] = address2[31:4] == 28'hfffffef;
	assign loadIsCC[3] = address3[31:4] == 28'hfffffef;
	assign loadIsCC[4] = address4[31:4] == 28'hfffffef;
	assign loadIsCC[5] = address5[31:4] == 28'hfffffef;
	assign loadIsCC[6] = address6[31:4] == 28'hfffffef;

endmodule
						 