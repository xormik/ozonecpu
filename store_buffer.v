// Module: Store buffer
// Author: Thomas Yiu
// Interfaces with:
// sw $1, 100($2); rs=$2, rt=$1

// The store buffer could possibly be a misnomer.  All it does is
// calculate the store address, wait for the stored value, and send
// them to Rob.  It doesn't actually communicate with cache or memory.

// not completed.  need to implement all the outputs.  

module store_buffer(immed_in, Vj_in, Qj_in, Vstore_in, Qstore_in, issue, issued_to_in, cdb_in, cdb_en, bus_granted, clk, rst, flush,
				full, addr_out, cdb_out, req_bus, rob_commitPtr);
	input [15:0] immed_in;						  
	input [31:0] Vj_in; // Vj is the base address
	input [4:0] Qj_in;
	input [31:0] Vstore_in; // Vstore is the stored value
	input [4:0] Qstore_in;
	input issue;
	input [4:0] issued_to_in; // the ROB slot being issued to
	input [36:0] cdb_in;
	input cdb_en;

	input bus_granted;
	input clk;
	input rst;
	input flush; // when we're unrolling after misprediction
	input [4:0] rob_commitPtr; // we'll check the rob_commitPtr against the issued_to number of our entries
					       // to see if it's the branch delay slot; if it is, we cannot flush it

	output full;
	output [28:0] addr_out; // the store address BUS.  {rob slot #, memio, 23 bit address}
	output [68:0] cdb_out; // the store value 
	output req_bus; // req_bus doubles as the addr_out_en signal which goes into rob

	parameter data_ready = 5'h0;

	wire [4:0] cdb_in_tag;
	wire [31:0] cdb_in_data;
	assign cdb_in_tag = cdb_in[36:32];
	assign cdb_in_data = cdb_in[31:0];

	reg [2:0] curr_ptr; // points at current entry.  Current entry goes around modulo looking for next entry whose valid bit is 1 and Qj and Qstore are zero
	reg [2:0] next_ptr; // points at the next empty entry that we can write to (whose valid bit is 0)

	// Store buffer entry:
	// | Vj (32) | Qj (5) | Vstore (32) | Qstore (5) | immed (16) | issued_to (5) | valid (1) |

	reg [31:0] Vj[0:6];
	reg [4:0] Qj[0:6];
	reg [31:0] Vstore[0:6];
	reg [4:0] Qstore[0:6];
	reg [15:0] immed[0:6];
	reg [4:0] issued_to[0:6];
	reg valid[0:6];


	reg cdb_in_Qj[0:6];
	reg cdb_in_Qstore[0:6];
	always @ (cdb_in_tag or Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or Qj[6] or
			Qstore[1] or Qstore[2] or Qstore[3] or Qstore[4] or Qstore[5] or Qstore[6] or cdb_en)
	  begin
	  	cdb_in_Qj[1] <= cdb_en & cdb_in_tag == Qj[1];
	  	cdb_in_Qj[2] <= cdb_en & cdb_in_tag == Qj[2];
	  	cdb_in_Qj[3] <= cdb_en & cdb_in_tag == Qj[3];
	  	cdb_in_Qj[4] <= cdb_en & cdb_in_tag == Qj[4];
	  	cdb_in_Qj[5] <= cdb_en & cdb_in_tag == Qj[5];
	  	cdb_in_Qj[6] <= cdb_en & cdb_in_tag == Qj[6];
	  	cdb_in_Qstore[1] <= cdb_en & cdb_in_tag == Qstore[1];
	  	cdb_in_Qstore[2] <= cdb_en & cdb_in_tag == Qstore[2];
	  	cdb_in_Qstore[3] <= cdb_en & cdb_in_tag == Qstore[3];
	  	cdb_in_Qstore[4] <= cdb_en & cdb_in_tag == Qstore[4];
	  	cdb_in_Qstore[5] <= cdb_en & cdb_in_tag == Qstore[5];
	  	cdb_in_Qstore[6] <= cdb_en & cdb_in_tag == Qstore[6];
	  end		   

	reg ready_to_exe[0:6];
	always @ (Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or Qj[6] or
			Qstore[1] or Qstore[2] or Qstore[3] or Qstore[4] or Qstore[5] or Qstore[6] or
			cdb_in_Qj[1] or cdb_in_Qj[2] or cdb_in_Qj[3] or cdb_in_Qj[4] or 
			cdb_in_Qj[5] or cdb_in_Qj[6] or cdb_in_Qstore[1] or cdb_in_Qstore[2] or 
			cdb_in_Qstore[3] or cdb_in_Qstore[4] or cdb_in_Qstore[5] or cdb_in_Qstore[6] or
			valid[1] or valid[2] or valid[3] or valid[4] or valid[5] or valid[6])
	  begin
		ready_to_exe[1] <= valid[1] & (!Qj[1] | cdb_in_Qj[1]) & (!Qstore[1] | cdb_in_Qstore[1]);
		ready_to_exe[2] <= valid[2] & (!Qj[2] | cdb_in_Qj[2]) & (!Qstore[2] | cdb_in_Qstore[2]);
		ready_to_exe[3] <= valid[3] & (!Qj[3] | cdb_in_Qj[3]) & (!Qstore[3] | cdb_in_Qstore[3]);
		ready_to_exe[4] <= valid[4] & (!Qj[4] | cdb_in_Qj[4]) & (!Qstore[4] | cdb_in_Qstore[4]);
		ready_to_exe[5] <= valid[5] & (!Qj[5] | cdb_in_Qj[5]) & (!Qstore[5] | cdb_in_Qstore[5]);
		ready_to_exe[6] <= valid[6] & (!Qj[6] | cdb_in_Qj[6]) & (!Qstore[6] | cdb_in_Qstore[6]);
	  end

/*
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
				else if (issue & !Qj_in & !Qstore_in) // only want to execute if no dependencies
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
				Vstore[next_ptr] <= Vstore_in;
				Qstore[next_ptr] <= Qstore_in;
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

			if (cdb_in_Qstore[1])
			  begin
				Vstore[1] <= cdb_in_data;
				Qstore[1] <= data_ready;		 
			  end
			if (cdb_in_Qstore[2])
			  begin
				Vstore[2] <= cdb_in_data;
				Qstore[2] <= data_ready;		 
			  end
			if (cdb_in_Qstore[3])
			  begin
				Vstore[3] <= cdb_in_data;
				Qstore[3] <= data_ready;		 
			  end
			if (cdb_in_Qstore[4])
			  begin
				Vstore[4] <= cdb_in_data;
				Qstore[4] <= data_ready;		 
			  end
			if (cdb_in_Qstore[5])
			  begin
				Vstore[5] <= cdb_in_data;
				Qstore[5] <= data_ready;		 
			  end
			if (cdb_in_Qstore[6])
			  begin
				Vstore[6] <= cdb_in_data;
				Qstore[6] <= data_ready;		 
			  end

			if (bus_granted)
				valid[curr_ptr] <= 0;	  	
		  end
	  end


	assign full = valid[1] & valid[2] & valid[3] & valid[4] & valid[5] & valid[6];

	wire [31:0] address;
     wire [15:0] imm16;
     wire [31:0] imm32;  // sign extended

	assign imm16 = immed[curr_ptr];
	assign imm32 = imm16[15] ? {16'hffff, imm16} : {16'h0, imm16};	

	// address is byte addressable
	assign address = Vj[curr_ptr] + imm32;
	
	// addr_out[22:0] is word-addressable
	assign addr_out[22:0] = address[24:2];
	
	assign addr_out[23] = address[31];
	assign addr_out[28:24] = issued_to[curr_ptr];
	assign cdb_out = {Vj[curr_ptr], issued_to[curr_ptr], Vstore[curr_ptr]};
	assign req_bus = valid[curr_ptr] & !Qj[curr_ptr] & !Qstore[curr_ptr];
	  // note that req_bus also serves as the addr_out enable signal which goes into rob


endmodule
