// Multiply / Divide Reservation Stations
// Author: Thomas Yiu /Victor

// INCOMPLETE
//   - entry replacement logic
//   - mult_reset, when to assert?

module mult_res_stations(Vj_in, Vk_in, Qj_in, Qk_in, mult_type_in, issue, issued_to_in, cdb_in, cdb_en, 
					mult_busy, HI, LO, clk, rst, flush, full, 
					mult_inA, mult_inB, mult_op, mult_signed_op, mult_reset,
					cdb_out, req_bus, bus_granted,
					rob_commitPtr, kickout);

	input [31:0] Vj_in;			// rs  |  Multiplication: rs * rt = {HI, LO}
	input [31:0] Vk_in;			// rt  |  Division: rs / rt = LO remainder HI
	input [4:0] Qj_in;			// register status for j
	input [4:0] Qk_in;			// register status for j
	input [2:0] mult_type_in;	// 000: divu
							// 010: multu
							// 011: mult
							// 100: mfhi
							// 110: mflo
	input issue;
	input [4:0] issued_to_in;	// the ROB slot being issued to
	//input [36:0] cdb_in;
	input [68:0] cdb_in;
	input cdb_en;

	input mult_busy;			// asserted when multiplier is busy
	input [31:0] HI;			// output of HI register
	input [31:0] LO;			// output of LO register

	input clk;
	input rst;
	input flush;
	input [4:0] rob_commitPtr; // we'll check the rob_commitPtr against the issued_to number of our entries
		 			       // to see if it's the branch delay slot; if it is, we cannot flush it

	input bus_granted;			// cdb granted
	

	output [5:0] kickout; 
	output full;
	output [31:0] mult_inA;
	output [31:0] mult_inB;
	output mult_op;			// note: mfhi and mflo don't go into multiplier
	output mult_signed_op;
	output mult_reset;	
	
	output [132:0] cdb_out;
	output req_bus;
	
	parameter data_ready = 5'h0;

	wire [4:0] cdb_in_tag;
	wire [31:0] cdb_in_data;
	assign cdb_in_tag = cdb_in[36:32];
	assign cdb_in_data = cdb_in[31:0];



	reg [31:0] Vj[0:4];
	reg [4:0] Qj[0:4];
	reg [31:0] Vk[0:4];
	reg [4:0] Qk[0:4];
	
	reg [2:0] mult_type[0:4];
	//reg [1:4] mult_type[2:0];
	reg [4:0] issued_to[0:4];
	reg [0:4] valid;
	reg [0:4] ready_to_exe;

 	reg cdb_in_Qj[0:4];
	reg cdb_in_Qk[0:4];


	reg [2:0] curr_ptr; // points at current entry.  Current entry goes around modulo looking for next entry whose valid bit is 1 and Qj and Qk are zero
	reg [2:0] next_ptr; // points at the next empty entry that we can write to (whose valid bit is 0)


	//New 
//	reg [31:0] mult_inA;
//	reg [31:0] mult_inB;
	wire [31:0] cdb_in_HI;
	reg  [2:0] victim_ptr; 
	wire exec_curr_mult_div;
	wire RegNeg_exec_curr_mult_div;

	wire [31:0] last_mult_inA;
	wire [31:0] last_mult_inB;

	register#(1) reged_curptr_rdyexec (.CLK(clk), .RST(rst), .WE(1'b1), .DIN(~exec_curr_mult_div), .DOUT(RegNeg_exec_curr_mult_div));
	register#(32) Mult_in_A(.CLK(clk), .RST(rst), .WE(1'b1), .DIN(mult_inA), .DOUT(last_mult_inA));
	register#(32) Mult_in_B(.CLK(clk), .RST(rst), .WE(1'b1), .DIN(mult_inB), .DOUT(last_mult_inB));
	
	parameter divu = 3'b000, multu = 3'b010, mult = 3'b011, mfhi = 3'b100, mflo = 3'b110;
	

	assign kickout = {(issue && (0 != victim_ptr) && ~mult_type_in[2] ), issued_to[victim_ptr]};

	assign cdb_in_HI = cdb_in[68:37];
	
	//Thanks to the funnny array reference indices by whoever, this is fucked
	//assign exec_curr_mult_div = ready_to_exe[curr_ptr] & ~mult_type[curr_ptr][2];
	assign exec_curr_mult_div = ready_to_exe[curr_ptr] & (mult_type[curr_ptr] == divu || mult_type[curr_ptr] == multu || mult_type[curr_ptr] == mult) 
							& ((last_mult_inA != mult_inA) || (last_mult_inB != mult_inB));


	assign mult_inA = (Qj[curr_ptr] == 0)? Vj[curr_ptr] : 32'b0 ;
	assign mult_inB = (Qk[curr_ptr] == 0)? Vk[curr_ptr] : 32'b0 ;


	// Mult RS entry:
	// | Vj (32) | Qj (5) | Vk (32) | Qk (5) | mult_type (3) | issued_to (5) | valid (1) |


	always @ (cdb_in_tag or Qj[1] or Qj[2] or Qj[3] or Qj[4] or
			Qk[1] or Qk[2] or Qk[3] or Qk[4] or cdb_en)
	  begin
	  	cdb_in_Qj[1] <= cdb_en & cdb_in_tag == Qj[1];
	  	cdb_in_Qj[2] <= cdb_en & cdb_in_tag == Qj[2];
	  	cdb_in_Qj[3] <= cdb_en & cdb_in_tag == Qj[3];
	  	cdb_in_Qj[4] <= cdb_en & cdb_in_tag == Qj[4];
	  	cdb_in_Qk[1] <= cdb_en & cdb_in_tag == Qk[1];
	  	cdb_in_Qk[2] <= cdb_en & cdb_in_tag == Qk[2];
	  	cdb_in_Qk[3] <= cdb_en & cdb_in_tag == Qk[3];
	  	cdb_in_Qk[4] <= cdb_en & cdb_in_tag == Qk[4];
	  end

	
	always @ (Qj[1] or Qj[2] or Qj[3] or Qj[4] or
			Qk[1] or Qk[2] or Qk[3] or Qk[4] or
			cdb_in_Qj[1] or cdb_in_Qj[2] or cdb_in_Qj[3] or cdb_in_Qj[4] or 
			cdb_in_Qk[1] or cdb_in_Qk[2] or cdb_in_Qk[3] or cdb_in_Qk[4] or 
			valid[1] or valid[2] or valid[3] or valid[4])
	  begin
		ready_to_exe[1] <= valid[1] & (!Qj[1] | cdb_in_Qj[1]) & (!Qk[1] | cdb_in_Qk[1]);
		ready_to_exe[2] <= valid[2] & (!Qj[2] | cdb_in_Qj[2]) & (!Qk[2] | cdb_in_Qk[2]);
		ready_to_exe[3] <= valid[3] & (!Qj[3] | cdb_in_Qj[3]) & (!Qk[3] | cdb_in_Qk[3]);
		ready_to_exe[4] <= valid[4] & (!Qj[4] | cdb_in_Qj[4]) & (!Qk[4] | cdb_in_Qk[4]);
	  end
	

/*
	// determining possible branch delay slot.  when flush signal comes in, we flush all
	// slots except the possible branch delay instruction
	wire [4:0] branchDelayRobEntry; // this is rob_commitPtr + 1;
	wire [2:0] branchDelayPtr;
	wire [2:0] branchDelayPtr_plus1;
	assign branchDelayRobEntry = (rob_commitPtr % 31) + 1;
	assign branchDelayPtr = (branchDelayRobEntry == issued_to[4]) ? 4 :
					    (branchDelayRobEntry == issued_to[3]) ? 3 :
					    (branchDelayRobEntry == issued_to[2]) ? 2 :
					    (branchDelayRobEntry == issued_to[1]) ? 1 : 0;
	assign branchDelayPtr_plus1 = (branchDelayPtr % 4) + 1;
*/

	// next/curr pointer logic
	  // If buffer is full, next_ptr stays at previous slot but valid[next_ptr] == 1
	  // If no slot is ready, curr_ptr stays at previous slot but valid[next_ptr] == 0

	wire [2:0] curr_plus1, curr_plus2, curr_plus3,
			 next_plus1, next_plus2, next_plus3;

 	assign curr_plus1 = (curr_ptr == 4) ? 1 : (curr_ptr + 1);
	assign curr_plus2 = (curr_ptr == 4) ? 2 :
						     (curr_ptr == 3) ? 1 : (curr_ptr + 2);
	assign curr_plus3 = (curr_ptr == 4) ? 3 :
						     (curr_ptr == 3) ? 2 : 
							  (curr_ptr == 2) ? 1 : (curr_ptr + 3);

  	assign next_plus1 = (next_ptr == 4) ? 1 : (next_ptr + 1);
	assign next_plus2 = (next_ptr == 4) ? 2 :
						     (next_ptr == 3) ? 1 : (next_ptr + 2);
	assign next_plus3 = (next_ptr == 4) ? 3 :
						     (next_ptr == 3) ? 2 : 
							  (next_ptr == 2) ? 1 : (next_ptr + 3);

	always @ (posedge clk)
	  begin
		if (rst | flush)
		  begin
		  	curr_ptr <= 1;
			next_ptr <= 1;

			//Victor's update on 11-25:
			victim_ptr<= 0;
		  end
/*
		else if (flush)
		  begin
			curr_ptr <= (branchDelayPtr) ? branchDelayPtr : 1;
			next_ptr <= (branchDelayPtr) ? branchDelayPtr_plus1 : 1;
			victim_ptr <= (branchDelayPtr == victim_ptr) ? victim_ptr : 0;
		  end
*/
		else 
		  begin
		  	// curr_ptr;
			if (bus_granted | ~valid[curr_ptr] | ~ready_to_exe[curr_ptr])
			  begin
			  	if (valid[curr_plus1] && 			//predicting the incoming CDB value
				((Qj[curr_plus1] == 0) || (Qj[curr_plus1] == issued_to[curr_ptr])) && 
				((Qk[curr_plus1] == 0) || (Qk[curr_plus1] == issued_to[curr_ptr])))
			  		curr_ptr <= curr_plus1;
				else if (valid[curr_plus2] && 		//predicting the incoming CDB value
				((Qj[curr_plus2] == 0) || (Qj[curr_plus2] == issued_to[curr_ptr])) && 
				((Qk[curr_plus2] == 0) || (Qk[curr_plus2] == issued_to[curr_ptr])))
			  		curr_ptr <= curr_plus2;
				else if (valid[curr_plus3] && 
				((Qj[curr_plus3] == 0) || (Qj[curr_plus3] == issued_to[curr_ptr])) && 
				((Qk[curr_plus3] == 0) || (Qk[curr_plus3] == issued_to[curr_ptr])))
			  		curr_ptr <= curr_plus3;
				else	if (ready_to_exe[curr_plus1])
			  		curr_ptr <= curr_plus1;
				else if (ready_to_exe[curr_plus2])
			  		curr_ptr <= curr_plus2;
				else if (ready_to_exe[curr_plus3])
			  		curr_ptr <= curr_plus3;
				else if (issue & !Qj_in & !Qk_in) // only want to execute if no dependencies
					curr_ptr <= next_ptr;
			  end

	// NEED LOGIC that kicks entries out when things like this happen:
	// mult $1, $1
	// mflo $3
	// divu $2, $2
	// mult $4, $4

			if (issue)
			  begin
			  	if (~mult_type_in[2] ) //some sorta mult/div instruction?
				begin
					if (victim_ptr == 0)
					begin
						victim_ptr <= next_ptr ; //updates to victim to this instruction
				    		if (~valid[next_plus1])  //updates the next_ptr for the next instruciton
							next_ptr <= next_plus1;
						else if (~valid[next_plus2])
							next_ptr <= next_plus2;
						else if (~valid[next_plus3])
							next_ptr <= next_plus3;
					end
					else	//victim_ptr != 0
					begin
					   	victim_ptr <= victim_ptr; //just kicked out someone else, keep it here
						next_ptr <= next_ptr; //KEEPING THE NEXT PTR THERE???
					end
				end

				else //everything else: mfhi, mflo
				begin
					victim_ptr <= 0;
					if (~valid[next_plus1])
						next_ptr <= next_plus1;
					else if (~valid[next_plus2])
						next_ptr <= next_plus2;
					else if (~valid[next_plus3])
						next_ptr <= next_plus3;
					else if (bus_granted)  // curr_ptr's entry will be free next cycle
						next_ptr <= curr_ptr;
				end
			 $display(" ");
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
			{valid[1], issued_to[1]} <= 0;
			{valid[2], issued_to[2]} <= 0;
			{valid[3], issued_to[3]} <= 0;
			{valid[4], issued_to[4]} <= 0;
			//just a cheap hack
			//mult_inA <= 0;
			//mult_inB <= 0;
			$display("resetting in mult reserv station");
			Vj[1]<= 0;
			Vk[1]<= 0;
			//end of cheap hack
		  end
/*
		else if (flush)
		  begin
			valid[1] <= (branchDelayPtr == 1) & valid[1];
			valid[2] <= (branchDelayPtr == 2) & valid[2];
			valid[3] <= (branchDelayPtr == 3) & valid[3];
			valid[4] <= (branchDelayPtr == 4) & valid[4];			
		  end
*/
		else
		  begin
		  	
		  	//mult_inA <= Vj[curr_ptr] ;
			//mult_inB <= Vk[curr_ptr] ;
			//mult_inA <= 1 ;
			//mult_inB <= 1 ;
			if (issue)
			    begin		 //Mult/div might be using the victim pointer?
				$display("what is ~mult_type_[2]: %d mlt_type is : %b", ~mult_type_in[2], mult_type_in
				);
				$display("Operansd; Vj = %d, Vk = %d", Vj_in, Vk_in);
				if (~mult_type_in[2]) //some sorta mult/div instruction?
				begin
				$display("some sort mult/div instruction");
				if (victim_ptr == 0) //this CANNOT kick any prev mult/div instr
					begin	    //i add this logic so that my stupid reset works whenever a new issued
							    // multiplying instruciton is issued regardless of pointer value
					$display("victim pointer == 0: next_ptr = %d", next_ptr);
					Vj[next_ptr] <= Vj_in;
					Qj[next_ptr] <= Qj_in;
					Vk[next_ptr] <= Vk_in;
					Qk[next_ptr] <= Qk_in;
					mult_type[next_ptr] <= mult_type_in;
					issued_to[next_ptr] <= issued_to_in;
					valid[next_ptr] <= 1;					
					end
				else	//the current instruction is kicking out an exisiting instr
					begin
					$display("kicking out an existing mult instr victim_ptr = %d, next_ptr = %d", 
					victim_ptr, next_ptr);
					Vj[victim_ptr] <= Vj_in;
					Qj[victim_ptr] <= Qj_in;
					Vk[victim_ptr] <= Vk_in;
					Qk[victim_ptr] <= Qk_in;
					mult_type[victim_ptr] <= mult_type_in;
					issued_to[victim_ptr] <= issued_to_in;
					valid[victim_ptr] <= 1;
					end
				end

			  else  //mfhi/lo case
			  	begin
				$display("some sort mfhi/lo case");
				Vj[next_ptr] <= Vj_in;
				Qj[next_ptr] <= Qj_in;
				Vk[next_ptr] <= Vk_in;
				Qk[next_ptr] <= Qk_in;
				mult_type[next_ptr] <= mult_type_in;
				issued_to[next_ptr] <= issued_to_in;
				valid[next_ptr] <= 1;
				end
			  end

			if (cdb_in_Qj[1])
			  begin
			  	$display("cdb_inQj1");
				Vj[1] <= (mult_type[1]== mfhi)? cdb_in_HI : cdb_in_data;
				Qj[1] <= data_ready;
			  end
			if (cdb_in_Qj[2])
			  begin
			  	$display("cdb_inQj2");
				Vj[2] <= (mult_type[2]== mfhi)? cdb_in_HI : cdb_in_data;
				Qj[2] <= data_ready;
			  end
			if (cdb_in_Qj[3])
			  begin
			  	$display("cdb_inQj3");
				Vj[3] <= (mult_type[3]== mfhi)? cdb_in_HI : cdb_in_data;
				Qj[3] <= data_ready;
			  end
			if (cdb_in_Qj[4])
			  begin
			  	$display("cdb_inQj4");
				Vj[4] <= (mult_type[4]== mfhi)? cdb_in_HI : cdb_in_data;
				Qj[4] <= data_ready;
			  end

			if (cdb_in_Qk[1])
			  begin
			  	$display("cdb_inQK1");
				Vk[1] <= cdb_in_data;
				Qk[1] <= data_ready;
			  end
			if (cdb_in_Qk[2])
			  begin
			  	$display("cdb_inQK2");
				Vk[2] <= cdb_in_data;
				Qk[2] <= data_ready;
			  end
			if (cdb_in_Qk[3])
			  begin
			  	$display("cdb_inQK3");
				Vk[3] <= cdb_in_data;
				Qk[3] <= data_ready;
			  end
			if (cdb_in_Qk[4])
			  begin
			  $display("cdb_inQK4");
				Vk[4] <= cdb_in_data;
				Qk[4] <= data_ready;
			  end

			if (bus_granted) begin
				//$display("Bus granted: invaldating current pointer: %d, multbusy? %b (instr type: %b) and my req_bus: ", 
				//curr_ptr, mult_busy, mult_type[curr_ptr], req_bus);
				valid[curr_ptr] <= 0;
				end
		  end
	  end

	assign full = valid[1] & valid[2] & valid[3] & valid[4];


	
	//assign mult_op = mult_type[curr_ptr][1];
	assign mult_op = (mult_type[curr_ptr]& {3'b010}) == 3'b010; 

	
  	assign mult_signed_op = (mult_type[curr_ptr] & {3'b001} ) == 3'b001;
	//assign mult_reset = RegNeg_exec_curr_mult_div & exec_curr_mult_div;
	assign mult_reset = exec_curr_mult_div;
	
     // cdb_out: rs | rt | HI | cdb_tag | 

	assign cdb_out[132:37] = {Vj[curr_ptr], Vk[curr_ptr], HI};
	assign cdb_out[36:32] = issued_to[curr_ptr];
	assign cdb_out[31:0] = (mult_type[curr_ptr] == mfhi || mult_type[curr_ptr] == mflo)? 
					   ((mult_type[curr_ptr] == mfhi)? Vj[curr_ptr]: Vk[curr_ptr]): LO; // by Vic 11-29
	
	assign req_bus = valid[curr_ptr] && 
	(mult_type[curr_ptr] == mfhi || mult_type[curr_ptr]  == mflo ||(~mult_busy && ~(kickout[5] && (victim_ptr == curr_ptr))&& (mult_type[curr_ptr] == divu || mult_type[curr_ptr] == multu || mult_type[curr_ptr] == mult)) )
	&& (0 == Qj[curr_ptr]) 
	&& (0 == Qk[curr_ptr])
	&& ~mult_reset; //updated by Vic 11-28 
	//ok.........multiply would request to write to some random ROB entry....i guess its okay cuz as long as
	//its writing to 0?
	
endmodule
