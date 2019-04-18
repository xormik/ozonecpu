// branch Reservation Stations
// Author: Mike and Chak Lee

module branch_res_station(Vj_in, Vk_in, Qj_in, Qk_in, alu_type_in, issue, issued_to_in, addr_in,
					cdb_in, cdb_en, branch_result, bus_granted, clk, rst, flush, full, 
					rs, rt, cdb_out, req_bus, can_opener, orangina, inst_in, addr_out, airplane, inst_out); // branch_update, branch_addr);

	
	input [1:0] alu_type_in;
	input [31:0] Vj_in;		// shamt for shift instructions, PC+4 for jal, rs for the rest
	input [31:0] Vk_in;		// rt for r-type instructions, extended immed for i-type, 4 for jal
	input [4:0] Qj_in;		// register status for j
	input [4:0] Qk_in;		// register status for k
	input [31:0] inst_in;		// branch instruction
						// inst[31:26]
						// beq = 000100
						// bne = 000101
						// bgez/bltz = 000001
						// j = 000010
						// jal = 000011
						// jr = 001000
	input issue;			// asserted for one cycle when branch instruction is issued
	input [4:0] issued_to_in; // the ROB slot being issued to
	input [36:0] cdb_in;	
	input cdb_en;			// cdb enable

	input [31:0] branch_result;
	input [31:0] addr_in;

	input bus_granted; 
	input clk;
	input rst;
	input flush;

	output can_opener;		// update signal for the predictor (asserted for 1 cycle)
	output [31:0] orangina;	// addr of branch being updated
	output airplane;		// airplane = 1 if branch is taken
						// airplane = 0 if branch is not taken	
	output full;
	output [31:0] rs; 
	output [31:0] rt;
	output [31:0] inst_out;
	output [100:0] cdb_out;
	output [31:0] addr_out; 
	output req_bus; // requests common data bus access  

	parameter data_ready = 5'h0;
	
	wire [4:0] cdb_in_tag;
	wire [31:0] cdb_in_data;
	assign cdb_in_tag = cdb_in[36:32];
	assign cdb_in_data = cdb_in[31:0];

	reg [1:0] curr_ptr; // points at current entry.  Current entry goes around modulo looking for next entry whose valid bit is 1 and Qj and Qk are zero
	reg [1:0] next_ptr; // points at the next empty entry that we can write to (whose valid bit is 0)
	reg can_opener, airplane;
	reg [31:0] orangina;

	// ALU RS entry:
	// | Vj (23) | Qj (5) | Vk (32) | Qk (5) | alu_type (6) | issued_to (5) | valid (1) |

	reg [31:0] Vj[0:3];
	reg [4:0] Qj[0:3];
	reg [31:0] Vk[0:3];
	reg [4:0] Qk[0:3];
	reg [31:0] inst[0:3];
	reg [4:0] issued_to[0:3];
	reg [31:0] addr[0:3];
	reg valid[0:3];

 	reg cdb_in_Qj[0:3];
	reg cdb_in_Qk[0:3];
	always @ (cdb_in_tag or Qj[1] or Qj[2] or Qj[3] or 
			Qk[1] or Qk[2] or Qk[3] or cdb_en)
	  begin
	  	cdb_in_Qj[1] <= cdb_en & cdb_in_tag == Qj[1];
	  	cdb_in_Qj[2] <= cdb_en & cdb_in_tag == Qj[2];
	  	cdb_in_Qj[3] <= cdb_en & cdb_in_tag == Qj[3];
	  	cdb_in_Qk[1] <= cdb_en & cdb_in_tag == Qk[1];
	  	cdb_in_Qk[2] <= cdb_en & cdb_in_tag == Qk[2];
	  	cdb_in_Qk[3] <= cdb_en & cdb_in_tag == Qk[3];
	  	
	  end

	reg ready_to_exe[0:3];
	always @ (Qj[1] or Qj[2] or Qj[3] or 
			Qk[1] or Qk[2] or Qk[3] or
			cdb_in_Qj[1] or cdb_in_Qj[2] or cdb_in_Qj[3] or 
			cdb_in_Qk[1] or cdb_in_Qk[2] or cdb_in_Qk[3] or 
			valid[1] or valid[2] or valid[3])
	begin
		ready_to_exe[1] <= valid[1] & (!Qj[1] | cdb_in_Qj[1]) & (!Qk[1] | cdb_in_Qk[1]);
		ready_to_exe[2] <= valid[2] & (!Qj[2] | cdb_in_Qj[2]) & (!Qk[2] | cdb_in_Qk[2]);
		ready_to_exe[3] <= valid[3] & (!Qj[3] | cdb_in_Qj[3]) & (!Qk[3] | cdb_in_Qk[3]);
	end
	

	// next/curr pointer logic
	  // If buffer is full, next_ptr stays at previous slot but valid[next_ptr] == 1
	  // If no slot is ready, curr_ptr stays at previous slot but valid[next_ptr] == 0

	wire [1:0] curr_plus1, curr_plus2, 
			 next_plus1, next_plus2;

	assign curr_plus1 = (curr_ptr == 3) ? 1 : (curr_ptr + 1);
	assign curr_plus2 = (curr_ptr == 3) ? 2 :
						     (curr_ptr == 2) ? 1 : (curr_ptr + 2);

	assign next_plus1 = (next_ptr == 3) ? 1 : (next_ptr + 1);
	assign next_plus2 = (next_ptr == 3) ? 2 :
						     (next_ptr == 2) ? 1 : (next_ptr + 2);

	always @ (posedge clk)
	  begin
		if (rst | flush)
		  begin
			curr_ptr <= 1;
			next_ptr <= 1;
		  end
		else 
		  begin
		  	// curr_ptr;
			if (bus_granted | ~ready_to_exe[curr_ptr])
			  begin
				if (ready_to_exe[curr_plus1])
			  		curr_ptr <= curr_plus1;
				else if (ready_to_exe[curr_plus2])
			  		curr_ptr <= curr_plus2;
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
		  end
		else
		  begin
			if (issue)
			  begin
				Vj[next_ptr] <= Vj_in;
				Qj[next_ptr] <= Qj_in;
				Vk[next_ptr] <= Vk_in;
				Qk[next_ptr] <= Qk_in;
				addr[next_ptr] <= addr_in;
				inst[next_ptr] <= inst_in;
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
			if (bus_granted)
				valid[curr_ptr] <= 0;
		  end
	  end

	always @ (posedge clk) begin
		if (req_bus) begin
			orangina <= addr[curr_ptr];
			can_opener <= 1;
			airplane <= (addr[curr_ptr] + 8) != branch_result;
		end
		else can_opener <= 0;
	end

	assign full = valid[1] & valid[2] & valid[3];



	assign rs = Vj[curr_ptr];
	assign rt = Vk[curr_ptr];
	assign addr_out = addr[curr_ptr];
	assign inst_out = inst[curr_ptr];
	assign cdb_out = {rs, rt, issued_to[curr_ptr], branch_result};
	assign req_bus = valid[curr_ptr] & !Qj[curr_ptr] & !Qk[curr_ptr];


endmodule


