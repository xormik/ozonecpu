// ALU Reservation Stations
// Author: Thomas Yiu

module alu_res_stations(Vj_in, Vk_in, Qj_in, Qk_in, alu_type_in, issue, issued_to_in, cdb_in, cdb_en, alu_result,
				    bus_granted, clk, rst, flush, full, alu_inA, alu_inB, alu_type_out, cdb_out, req_bus,
				    rob_commitPtr);
	
	input [31:0] Vj_in;		// shamt for shift instructions, PC+4 for jal, rs for the rest
	input [31:0] Vk_in;		// rt for r-type instructions, extended immed for i-type, 4 for jal
	input [4:0] Qj_in;		// register status for j
	input [4:0] Qk_in;		// register status for k
	input [5:0] alu_type_in;	// alu instruction type
						// addu/addiu/jal: 000000 
						// and/andi: 000001 
						// or/ori: 000010 
						// xor/xori: 000011 
						// subu: 000100 
						// slt/slti: 010100 
						// sltu/sltiu: 011100 
						// sll: 100000 
						// srl: 100010 
						// sra: 100011 
	input issue;			// asserted for one cycle when alu instruction is issued
	input [4:0] issued_to_in; // the ROB slot being issued to
	input [36:0] cdb_in;	
	input cdb_en;			// cdb enable

	input [31:0] alu_result;

	input bus_granted; 
	input clk;
	input rst;
	input flush;
	input [4:0] rob_commitPtr; // we'll check the rob_commitPtr against the issued_to number of our entries
					       // to see if it's the branch delay slot; if it is, we cannot flush it

	output full;
	output [31:0] alu_inA; 
	output [31:0] alu_inB;
	output [5:0] alu_type_out;
	output [100:0] cdb_out; 
	output req_bus; // requests common data bus access  

	parameter data_ready = 5'h0;
	
	wire [4:0] cdb_in_tag;
	wire [31:0] cdb_in_data;
	assign cdb_in_tag = cdb_in[36:32];
	assign cdb_in_data = cdb_in[31:0];

	reg [2:0] curr_ptr; // points at current entry.  Current entry goes around modulo looking for next entry whose valid bit is 1 and Qj and Qk are zero
	reg [2:0] next_ptr; // points at the next empty entry that we can write to (whose valid bit is 0)

	// ALU RS entry:
	// | Vj (23) | Qj (5) | Vk (32) | Qk (5) | alu_type (6) | issued_to (5) | valid (1) |

	reg [31:0] Vj[0:5];
	reg [4:0] Qj[0:5];
	reg [31:0] Vk[0:5];
	reg [4:0] Qk[0:5];
	reg [5:0] alu_type[0:5];
	reg [4:0] issued_to[0:5];
	reg valid[0:5];

 	reg cdb_in_Qj[0:5];
	reg cdb_in_Qk[0:5];
	always @ (cdb_in_tag or Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or
			Qk[1] or Qk[2] or Qk[3] or Qk[4] or Qk[5] or cdb_en)
	  begin
	  	cdb_in_Qj[1] <= cdb_en & cdb_in_tag == Qj[1];
	  	cdb_in_Qj[2] <= cdb_en & cdb_in_tag == Qj[2];
	  	cdb_in_Qj[3] <= cdb_en & cdb_in_tag == Qj[3];
	  	cdb_in_Qj[4] <= cdb_en & cdb_in_tag == Qj[4];
	  	cdb_in_Qj[5] <= cdb_en & cdb_in_tag == Qj[5];
	  	cdb_in_Qk[1] <= cdb_en & cdb_in_tag == Qk[1];
	  	cdb_in_Qk[2] <= cdb_en & cdb_in_tag == Qk[2];
	  	cdb_in_Qk[3] <= cdb_en & cdb_in_tag == Qk[3];
	  	cdb_in_Qk[4] <= cdb_en & cdb_in_tag == Qk[4];
	  	cdb_in_Qk[5] <= cdb_en & cdb_in_tag == Qk[5];
	  end

	reg ready_to_exe[0:5];
	always @ (Qj[1] or Qj[2] or Qj[3] or Qj[4] or Qj[5] or
			Qk[1] or Qk[2] or Qk[3] or Qk[4] or Qk[5] or
			cdb_in_Qj[1] or cdb_in_Qj[2] or cdb_in_Qj[3] or cdb_in_Qj[4] or 
			cdb_in_Qj[5] or cdb_in_Qk[1] or cdb_in_Qk[2] or 
			cdb_in_Qk[3] or cdb_in_Qk[4] or cdb_in_Qk[5] or
			valid[1] or valid[2] or valid[3] or valid[4] or valid[5])
	  begin
		ready_to_exe[1] <= valid[1] & (!Qj[1] | cdb_in_Qj[1]) & (!Qk[1] | cdb_in_Qk[1]);
		ready_to_exe[2] <= valid[2] & (!Qj[2] | cdb_in_Qj[2]) & (!Qk[2] | cdb_in_Qk[2]);
		ready_to_exe[3] <= valid[3] & (!Qj[3] | cdb_in_Qj[3]) & (!Qk[3] | cdb_in_Qk[3]);
		ready_to_exe[4] <= valid[4] & (!Qj[4] | cdb_in_Qj[4]) & (!Qk[4] | cdb_in_Qk[4]);
		ready_to_exe[5] <= valid[5] & (!Qj[5] | cdb_in_Qj[5]) & (!Qk[5] | cdb_in_Qk[5]);
	  end

/*
	// determining possible branch delay slot.  when flush signal comes in, we flush all
	// slots except the possible branch delay instruction
	wire [4:0] branchDelayRobEntry; // this is rob_commitPtr + 1;
	wire [2:0] branchDelayPtr;
	wire [2:0] branchDelayPtr_plus1;

	assign branchDelayRobEntry = (rob_commitPtr == 31) ? 1 : (rob_commitPtr + 31);
	assign branchDelayPtr = (branchDelayRobEntry == issued_to[5]) ? 5 :
					    (branchDelayRobEntry == issued_to[4]) ? 4 :
					    (branchDelayRobEntry == issued_to[3]) ? 3 :
					    (branchDelayRobEntry == issued_to[2]) ? 2 :
					    (branchDelayRobEntry == issued_to[1]) ? 1 : 0;
	assign branchDelayPtr_plus1 = ((branchDelayPtr == 5) ? 0 : branchDelayPtr) + 1;
*/						

	// next/curr pointer logic
	  // If buffer is full, next_ptr stays at previous slot but valid[next_ptr] == 1
	  // If no slot is ready, curr_ptr stays at previous slot but valid[next_ptr] == 0

	wire [2:0] curr_plus1, curr_plus2, curr_plus3, curr_plus4,
			 next_plus1, next_plus2, next_plus3, next_plus4;
	assign curr_plus1 = (curr_ptr == 5) ? 1 : (curr_ptr + 1);
	assign curr_plus2 = (curr_ptr == 5) ? 2 :
						     (curr_ptr == 4) ? 1 : (curr_ptr + 2);
	assign curr_plus3 = (curr_ptr == 5) ? 3 :
						     (curr_ptr == 4) ? 2 : 
							  (curr_ptr == 3) ? 1 : (curr_ptr + 3);
	assign curr_plus4 = (curr_ptr == 5) ? 4 :
						     (curr_ptr == 4) ? 3 : 
							  (curr_ptr == 3) ? 2 : 
							  (curr_ptr == 2) ? 1 : (curr_ptr + 4);

  	assign next_plus1 = (next_ptr == 5) ? 1 : (next_ptr + 1);
	assign next_plus2 = (next_ptr == 5) ? 2 :
						     (next_ptr == 4) ? 1 : (next_ptr + 2);
	assign next_plus3 = (next_ptr == 5) ? 3 :
						     (next_ptr == 4) ? 2 : 
							  (next_ptr == 3) ? 1 : (next_ptr + 3);
	assign next_plus4 = (next_ptr == 5) ? 4 :
						     (next_ptr == 4) ? 3 : 
							  (next_ptr == 3) ? 2 : 
							  (next_ptr == 2) ? 1 : (next_ptr + 4);


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
				else if (issue & !Qj_in & !Qk_in) // only want to execute if no dependencies
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
				else if (bus_granted)  // curr_ptr's entry will be free next cycle
					next_ptr <= curr_ptr;
			  end
			else // if ~issue
				if (valid[next_ptr] & bus_granted)
					next_ptr <= curr_ptr; // because curr slot is finished

			
		  end
	  end

	// registers
	always @ (posedge clk)
	  begin
	  	if (rst | flush)
		  begin
			valid[1] <= 0;
			valid[2] <= 0;
			valid[3] <= 0;
			valid[4] <= 0;
			valid[5] <= 0;
		  end
/*
		else if (flush)
		  begin
			valid[1] <= (branchDelayPtr == 1) & valid[1];
			valid[2] <= (branchDelayPtr == 2) & valid[2];
			valid[3] <= (branchDelayPtr == 3) & valid[3];
			valid[4] <= (branchDelayPtr == 4) & valid[4];
			valid[5] <= (branchDelayPtr == 5) & valid[5];
		  end
*/
		else
		  begin
			if (issue)
			  begin
				Vj[next_ptr] <= Vj_in;
				Qj[next_ptr] <= Qj_in;
				Vk[next_ptr] <= Vk_in;
				Qk[next_ptr] <= Qk_in;
				alu_type[next_ptr] <= alu_type_in;
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

			if (cdb_in_Qk[1])
			  begin
				Vk[1] <= cdb_in_data;
				Qk[1] <= data_ready;
			  end
			if (cdb_in_Qk[2])
			  begin
				Vk[2] <= cdb_in_data;
				Qk[2] <= data_ready;
			  end
			if (cdb_in_Qk[3])
			  begin
				Vk[3] <= cdb_in_data;
				Qk[3] <= data_ready;
			  end
			if (cdb_in_Qk[4])
			  begin
				Vk[4] <= cdb_in_data;
				Qk[4] <= data_ready;
			  end
			if (cdb_in_Qk[5])
			  begin
				Vk[5] <= cdb_in_data;
				Qk[5] <= data_ready;
			  end

			if (bus_granted)
				valid[curr_ptr] <= 0;
		  end
	  end

	assign full = valid[1] & valid[2] & valid[3] & valid[4] & valid[5];

	assign alu_inA = Vj[curr_ptr];
	assign alu_inB = Vk[curr_ptr];
	assign alu_type_out = alu_type[curr_ptr];
	assign cdb_out = {Vj[curr_ptr], Vk[curr_ptr], issued_to[curr_ptr], alu_result};
	assign req_bus = valid[curr_ptr] & !Qj[curr_ptr] & !Qk[curr_ptr];


endmodule
