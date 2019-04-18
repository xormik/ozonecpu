// Module: Commit control logic
// Author: Richard Lin

// Basic operation: At each positive edge of the clock, the commit unit will check
// the ready bit of the current ROB entry referenced by ROB's commitPtr.  Make sure
// the ROB sets the ready bit to 0 otherwise (at reset, at rollback, and at completion
// of commit)

/*
   multdiv hi, lo
   
*/



module commit(robHeadEntry,
			robHeadEntryDest,
			robHeadEntryReady,
			robHeadEntryInstr,
			robHeadEntryValue,
			robPostBranchDelayEntryValid,
			robCommit,
			//writeReg, sent to reg file and hi/lo from rob
			writeRegROBEntry,
			//writeRegBusy,
			predictedAddr,
			//regFileOut,  sent to reg file from rob
			regFileCommit,
			rls,
			regStatCommit,
			stat_output,
			rollBack,
			write_cache,
			write_mem_req,
			write_mem_req_granted,
			clk,
			rst,
			memio_we,
			memio_bit,
			stall,  // don't commit if stalled
			stall_rollback
		    );

  input clk, rst;

  // ROB head entry fields
  input [4:0] robHeadEntry, robHeadEntryDest;
  input robHeadEntryReady;
  input [31:0] robHeadEntryInstr, robHeadEntryValue;
  input robPostBranchDelayEntryValid;

  // register file
  //output [31:0] regFileOut;
  
  // register status file
  //output [5:0] writeReg;
  input [4:0] writeRegROBEntry;   
  //output writeRegBusy;

  // commit signals
  // there are two separate commit signals because we do not always 
  // update register stat file 
  output regFileCommit;
  output regStatCommit;
  output robCommit;
  
  // Branch rollback
  input [31:0] predictedAddr;
  output rollBack;
 
  // decoding instruction
  wire [5:0] op, funct;
  wire [19:0] break_code;
  
  // store word signals
  output write_cache, write_mem_req;
  input write_mem_req_granted;
  output memio_we;
  input memio_bit;


  input stall;
  output stall_rollback; // asserted if we're stalling while commit_ptr is
  					// pointing to a branch instruction that needs to
					// be rolled back
  

  // instruction groups 
  wire ig1, ig2, ig3, ig4, ig5, ig6, ig7, ig8, ig9, ig10, ig11, ig12, ig13, ig14;
 
  assign op = robHeadEntryInstr[31:26];
  assign funct = robHeadEntryInstr[5:0];
  assign break_code = robHeadEntryInstr[25:6];
  
  parameter rtype_opcode = 6'b0,	   	  	// rtype (opcode 0)
		  addiu_opcode = 6'b001001,     	// addiu (opcode 9)	
		  andi_opcode = 6'b001100,	  	// andi (opcode 12)		     	 
		  ori_opcode = 6'b001101,	  	// ori (opcode 13)
            xori_opcode = 6'b001110,	  	// xori (opcode 14)
		  lui_opcode = 6'b001111,	  	// lui (opcode 15)
		  slti_opcode = 6'b001010,	  	// slti (opcode 10)
            sltiu_opcode = 6'b001011,		// sltiu (opcode 11)
		  beq_opcode = 6'b000100,	  	// beq (opcode 4)
		  bne_opcode = 6'b000101,	  	// bne (opcode 5)
            branch_rt_opcode = 6'b000001, 	// bgez/bltz (opcode 1) differentiated by rt field
            j_opcode = 6'b000010,         	// j  (opcode 2)
		  jal_opcode = 6'b000011,	 	// jal (opcode 3)
		  lw_opcode = 6'b100011,		 	// lw (opcode 35)
		  sw_opcode = 6'b101011;		  	// sw (opcode 43)
		  
  parameter addu_funct = 6'b100001,	  	// addu (funct 33)
		  subu_funct = 6'b100011,	  	// subu (funct 35)
            and_funct = 6'b100100,		  	// and (funct 36)
            or_funct =  6'b100101,		  	// or (funct 37)
		  xor_funct = 6'b100110,	       	// xor (funct 38)
		  sll_funct = 6'b000000,		  	// sll (funct 0)
		  sra_funct = 6'b000011,		  	// sra (funct 3)
		  srl_funct = 6'b000010,  	  	// srl (funct 2)
		  slt_funct = 6'b101010,		  	// slt (funct 42)
		  sltu_funct = 6'b101011,	  	// sltu(funct 43)
		  jr_funct = 6'b001000,  	  	// jr (funct 8)
		  
		  mult_funct = 6'd24, 		  // mult (funct 24)  added by Victor 11-29 EARLY MORNING
		  div_funct  = 6'd26,           //	div  (funct 26)  // not supported?
		  divu_funct = 6'd27, 		  // divu (funct 27)
		  
		  multu_funct =6'b011001,	  	// multu(funct 25)
		  mfhi_funct  =6'b010000,	  	// mfhi (funct 16)
		  mflo_funct  =6'b010010,	  	// mflo (funct 18)
		  break_funct =6'b001101;	  	// break(funct 13)

  parameter bgez_rt = 5'b00001,		  	// bgez (rt 1)
  		  bltz_rt = 5'b00000;		  	// bltz (rt 0)

  // instruction group abstractions
  assign ig1 = (op == rtype_opcode) && ((funct == addu_funct) || (funct == subu_funct) ||
  								(funct == and_funct) || (funct == or_funct) ||
								(funct ==  xor_funct) || (funct == slt_funct) ||
								(funct == sltu_funct));
  assign ig2 = (op == addiu_opcode) || (op == andi_opcode) || (op == ori_opcode) ||
  			(op == xori_opcode) || (op == slti_opcode) || (op == sltiu_opcode);
  assign ig3 = op == lui_opcode;
  assign ig4 = (op == rtype_opcode) && ((funct == sll_funct) || (funct == sra_funct) ||
  								(funct == srl_funct));
  assign ig5 = (op == beq_opcode) || (op == bne_opcode);
  assign ig6 = (op == branch_rt_opcode);
  assign ig7 = (op == j_opcode);
  assign ig8 = (op == rtype_opcode) && (funct == jr_funct);
  assign ig9 = (op == jal_opcode);
  assign ig10 = (op == lw_opcode);
  assign ig11 = (op == sw_opcode);
  assign ig12 = (op == rtype_opcode) && ((funct == mult_funct) ||
  								 (funct == multu_funct) ||
								 (funct == div_funct) ||
								 (funct == divu_funct));
  assign ig13 = (op == rtype_opcode) && ((funct == mfhi_funct) || (funct == mflo_funct));
  assign ig14 = (op == rtype_opcode) && (funct == break_funct);

  // branch rollback
  assign rollBack = (robHeadEntryReady & (ig5 | ig6) & robPostBranchDelayEntryValid & (predictedAddr != robHeadEntryValue) &
  				robCommit);	    // added by Thomas 

  // break & release
  input rls;
  output [7:0] stat_output;
  
  //assign writeReg = robHeadEntryDest;	// d = ROB[h].Dest
  
  // branch instructions
  // 1) how to check if branch is mispredicted?
  // 2) what to do if a branch is mispredicted?
  
  // store word instructions
  // 1) what to do when we encounter a store word instruction?
  // 2) only send robCommit when we actually successfully store the value
  //    into both cache and memory?
  // assign writeMem
  // assign writeCache

  // store word signals
  // write_cache, write_mem_req;
  // input write_mem_req_granted;

  // store word if instruction is sw && addr[31]=0 && 
  //assign write_cache = !robHeadEntryReady ? 1'b0:
  //		             ig11
  
  
/*  
  reg [1:0] CS, NS;	// current state, next state  
  parameter idle=2'b0, wr_cache=2'b1, requesting=2'b10;

  always @ (posedge clk) begin
    if (rst)
      CS <= idle;
    else
      CS <= NS;
  end

  // next state logic  // function of CS and input
  always @ (CS or robHeadEntryReady or ig11 or write_mem_req_granted) begin
    case(CS)
    idle: begin
      if (robHeadEntryReady && ig11 && !write_mem_req_granted)
	   NS <= wr_cache;
      else
	   NS <= idle;
    end
    wr_cache: begin
      if (write_mem_req_granted)
	   NS <= idle;
      else
        NS <= requesting;
    end
    requesting: begin
      if (write_mem_req_granted)
	   NS <= idle;
	 else
	   NS <= requesting;
    end
    default: NS <= idle;  
    endcase

  end

  reg write_cache;
  reg write_mem_req;

  // output logic
  always @ (CS) begin
    case(CS)
    idle: begin
      write_cache = 1'b0;
	 write_mem_req = 1'b0;
    end
    wr_cache: begin
      write_cache = 1'b1;
	 write_mem_req = 1'b1;
    end
    requesting: begin
      write_cache = 1'b0;
	 write_mem_req = 1'b1;
    end

    endcase

  end

*/

  //assign write_cache = write_mem_req;  
  assign write_cache = ig11 & ~memio_bit & write_mem_req_granted;
  assign write_mem_req = !robHeadEntryReady ? 1'b0 :
                       ig11 ? !write_mem_req_granted : 1'b0;

  // break instructions
  assign stat_output = ig14 ? break_code[7:0] : 8'h00;

  // regular reg file writing instructions
  // commit to register file only if ROB[h].ready=yes
  // and instructions are not branch, store or break
  //assign regFileOut = robHeadEntryValue; // IS THIS NECESSARY?

  // regFileCommit when inst writes to reg.
  assign regFileCommit = (!robHeadEntryReady ? 1'b0 :				// robHeadEntry not ready, don't commit.
  			      	 (ig1 | ig2 | ig3 | ig4 | ig9 | ig10 | ig12 | ig13)) &&
						// inst writes to regFile, assert regFileCommit
				 	robCommit;
  // rob commit signal
  // - should not check other values if robHeadEntry is not ready b/c robHeadEntryValue may be 32'hx;
  assign robCommit =  !robHeadEntryReady ? 1'b0 :								// robHeadEntry not ready, don't commit.
  				 !(ig11 | ig14) ? /*1'b1*/ ~stall :									// if not branch, sw or break, commit.
				 (ig5 | ig6) ? 1'b1:/*robPostBranchDelayEntryValid, richard: we actually want to affect rollback*/			// branch, always commit upon resolving.
				 (ig11 & memio_bit) ? 1'b1 : 
				 (ig11 & !memio_bit) ? write_mem_req_granted : // store word, don't commit until done storing 										// FIX THIS (currently commit unconditionally).
				 (ig14 & rls);											// break, do not commit until release.

	
  assign stall_rollback = stall & (ig5 | ig6) & rollBack;


 // predictedAddr: one that we actually took.
 // robHeadEntryValue: addr that we should have taken.

  /*
  // regFileCommit when inst writes to reg.
  assign regFileCommit = (robHeadEntryReady & ~(ig5 | ig6 | ig7 | ig8 | ig9 | ig11 | ig14));

  // rob commit signal
  // -need robCommit to be asserted for jumps?
  // - should not check other values if robHeadEntry is not ready b/c robHeadEntryValue may be 32'hx;
  assign robCommit = !robHeadEntryReady ? 1'b0 :	  // need to check if RSFull
  			      ((ig1 | ig2 | ig3 | ig4 | ig9 | ig10 | ig14) && !(ig5 | ig6 | ig7 | ig8 | ig11 | ig12 | ig13)) ||
				 ((ig5 | ig6) && (robHeadEntryValue == predictedAddr)) ? 1'b1 :
				 1'b0;
 */
 
  // need to extend to handle other instructions
  
  // free up destination register if no one else writing to it
  //assign writeRegBusy = 1'b0;
  assign regStatCommit = (!robHeadEntryReady ? 1'b0:
                          (writeRegROBEntry == robHeadEntry)) &&
					robCommit;

  // store-word memio commit (applies to only store words in memio)
  assign memio_we = !robHeadEntryReady ? 1'b0 :
  		   (ig11 & memio_bit) ? 1'b1 :
		   1'b0;
 
endmodule
