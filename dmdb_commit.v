/*
    Final Project dmdb update

    Make sure to update your instruction tracer unit from previous labs to give useful 
    information about the instruction stream.  Among other things, make sure to include 
    the current cycle count in your trace. The trace should show committed instructions.
    One useful debugging option would be to make another tracer which shows dispatched
    instructions (as they enter the reorder buffer). 

    Make sure to update your instruction tracer unit from previous labs to give useful information
    about the instruction stream.  Among other things, make sure to include the current cycle count
    in your trace.  Suggestion: you might consider outputing two separate traces (to files): (1) a
    trace of dispatched instructions and (2) a trace of committed instructions/possibly triggered
    from the broadcast results bus.  Only (2) is required, however. 
*/

/*
    Trace outputted to trace_commit.txt.
    Dispatch trace is not outputted to  ModelSim output.
    However, the commit trace is ouputted to ModelSim output.
*/

module dmdb_commit(clk, addr, value, commit, cycle_count,
				cdb_in_VjVk, cdb_in_tag, cdb_en, commit_ptr, 
				issue, issue_ptr, rsValIN, rtValIN, instrIN,
				commit_instr, commit_addr,
				rst, rollback);

	input clk;
	input rst, rollback;
	input [31:0] addr;
	input [31:0] value;

	// input signals to keep track of rs and rt values
	input [63:0] cdb_in_VjVk;
	input [4:0] cdb_in_tag;			
	input cdb_en;
	input [4:0] commit_ptr;
	input issue;		// same signal has ROB.issue
	input [4:0] issue_ptr;
	input [31:0] rsValIN;
	input [31:0] rtValIN;
	input [31:0] instrIN;
	
	// asserted upon commit of instruction
	// so, we only print when we commit
	input commit;
	
	// cycle count
	input [63:0] cycle_count;

	output [31:0] commit_instr;
	output [31:0] commit_addr;

	// storing rsVal, rtVal, and instr in mini rob
	reg [31:0] rsVals[0:31];
	reg [31:0] rtVals[0:31];
	reg [31:0] instrs[0:31];
	wire [31:0] rsVal;
	wire [31:0] rtVal;
	wire [31:0] instr;
	assign rsVal = rsVals[commit_ptr];
	assign rtVal = rtVals[commit_ptr];
	assign instr = instrs[commit_ptr];

	// 32-bit instruction format deconstruction
  	wire [5:0] op, funct;
  	wire [4:0] rs, rt, rd, shamt;
  	wire [15:0] addr_imm;
  	wire [25:0] target_addr;
  	wire [19:0] break_code;

  	assign op = instr[31:26];
  	assign rs = instr[25:21];
  	assign rt = instr[20:16];
  	assign rd = instr[15:11];
  	assign shamt = instr[10:6];
  	assign funct = instr[5:0];
  	assign addr_imm = instr[15:0];
  	assign target_addr = instr[25:0];
  	assign break_code = instr[25:6];

	// parameter constants
	parameter rtype_opcode = 6'b0,	   	  	// rtype (opcode 0)
			addiu_opcode = 6'b001001,     	// addiu (opcode 9)	
		  	andi_opcode = 6'b001100,	  		// andi (opcode 12)		     	 
		  	ori_opcode = 6'b001101,	  		// ori (opcode 13)
            	xori_opcode = 6'b001110,	  		// xori (opcode 14)
		  	lui_opcode = 6'b001111,	  		// lui (opcode 15)
		  	slti_opcode = 6'b001010,	  		// slti (opcode 10)
            	sltiu_opcode = 6'b001011,		// sltiu (opcode 11)
		  	beq_opcode = 6'b000100,	  		// beq (opcode 4)
		  	bne_opcode = 6'b000101,	  		// bne (opcode 5)
            	branch_rt_opcode = 6'b000001, 	// bgez/bltz (opcode 1) differentiated by rt field
            	j_opcode = 6'b000010,         	// j  (opcode 2)
		  	jal_opcode = 6'b000011,	 		// jal (opcode 3)
		  	lw_opcode = 6'b100011,		 	// lw (opcode 35)
		  	sw_opcode = 6'b101011;		  	// sw (opcode 43)
		  
	parameter addu_funct = 6'b100001,	  		// addu (funct 33)
		  	subu_funct = 6'b100011,	  		// subu (funct 35)
            	and_funct = 6'b100100,		  	// and (funct 36)
            	or_funct =  6'b100101,		  	// or (funct 37)
		  	xor_funct = 6'b100110,	       	// xor (funct 38)
		  	sll_funct = 6'b000000,		  	// sll (funct 0)
		  	sra_funct = 6'b000011,		  	// sra (funct 3)
		  	srl_funct = 6'b000010,  	  		// srl (funct 2)
		  	slt_funct = 6'b101010,		  	// slt (funct 42)
		  	sltu_funct = 6'b101011,	  		// sltu(funct 43)
		  	jr_funct = 6'b001000,  	  		// jr (funct 8)
		  	mult_funct = 6'h18,
			multu_funct =6'b011001,	  		// multu(funct 25)
		  	div_funct = 6'h1a,
			divu_funct = 6'h1b,			
			mfhi_funct  =6'b010000,	  		// mfhi (funct 16)
		  	mflo_funct  =6'b010010,	  		// mflo (funct 18)
		  	break_funct =6'b001101;	  		// break(funct 13)

	parameter bgez_rt = 5'b00001,		  		// bgez (rt 1)
  		  	bltz_rt = 5'b00000;		  		// bltz (rt 0)

// register the rollback signal to output the branch delay slot after rollback
	wire rollback_dout;
	wire [4:0] commit_ptr_dout_tmp;
	wire [4:0] commit_ptr_dout;
	wire [31:0] addr_dout_tmp;
	wire [31:0] addr_dout;
	register #(1) rollback_reg(.DIN(rollback), 
   				    .DOUT(rollback_dout),
				    .WE(1'b1),
				    .CLK(clk),
				    .RST(rst));
	register #(5) commit_ptr_reg(.DIN(commit_ptr), 
   				    .DOUT(commit_ptr_dout_tmp),
				    .WE(1'b1),
				    .CLK(clk),
				    .RST(rst));
	register #(32) addr_reg(.DIN(addr), 
   				    .DOUT(addr_dout_tmp),
				    .WE(1'b1),
				    .CLK(clk),
				    .RST(rst));
	// hopefully this will be the branch delay slot
	assign commit_ptr_dout = (commit_ptr_dout_tmp == 8'd31) ? 5'd1 : (commit_ptr_dout_tmp + 1);
	assign addr_dout = (addr_dout_tmp == 32'hffffffff) ? 32'h00000000 : (addr_dout_tmp + 4);

	// open file for writing
  	`ifdef synthesis
  	`else
    		integer fd = 0;
    		initial begin
    		fd = $fopen("trace_commit.txt", "w");
    		end
  	`endif


`ifdef synthesis
	wire dummy;
`else

	always @ (posedge clk) begin

	if (!commit) begin
		$fwrite(fd, "CC: 0x%16h No Commit\n", cycle_count);
		//$display("CC: 0x%16h No Commit\n", cycle_count); // I doubt anyone would want this.
	end
	else	begin
		case(op)
      	rtype_opcode:
	   		case(funct)
	   		addu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  addu    r%0d,  r%0d, r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
					   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value); 
//	     		`endif
	   		subu_funct:
//	     		`ifdef synthesis
//	     		`else
				$fwrite(fd, "CC: 0x%16h 0x%h:  subu    r%0d,  r%0d, r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
					   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value); 	     
//				`endif
	   		and_funct:
//	     		`ifdef synthesis
//	     		`else
		 		$fwrite(fd, "CC: 0x%16h 0x%h:  and     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value);
//	     		`endif
	   		or_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  or      r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		 			   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value);
//	     		`endif
	   		xor_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  xor     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
					   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value);
//			     `endif
	   		sll_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sll     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		                  cycle_count, addr, rd, rt, shamt, rt, rtVal, shamt, rd, value);
//		 		`endif
	   		sra_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sra     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rd, rt, shamt, rt, rtVal, shamt, rd, value);
//	     		`endif
	   		srl_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  srl     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rd, rt, shamt, rt, rtVal, shamt, rd, value);
//	     		`endif
	   		slt_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  slt     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
					   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value);
//	     		`endif
	   		sltu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sltu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
					   cycle_count, addr, rd, rs, rt, rs, rsVal, rt, rtVal, rd, value);
//	     		`endif
	   		jr_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  jr      r%0d                  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, rs, rsVal);
//	     		`endif
	   		multu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  multu   r%0d,  r%0d             R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, rt, rs, rsVal, rt, rtVal);
//	     		`endif
	   		mult_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mult    r%0d,  r%0d             R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, rt, rs, rsVal, rt, rtVal);
//	     		`endif
	   		divu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  divu    r%0d,  r%0d             R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, rt, rs, rsVal, rt, rtVal);
//	     		`endif
	   		div_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  div     r%0d,  r%0d             R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, rt, rs, rsVal, rt, rtVal);
//	     		`endif
			mfhi_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mfhi    r%0d                  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rd, rd, value);
//	     		`endif
	   		mflo_funct:
//	     		`ifdef synthesis
//	     	 	`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mflo    r%0d                  R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rd, rd, value);
//	     		`endif
	   		break_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  break   0x%h\n",
		  			   cycle_count, addr, break_code);
//	     		`endif
	   		default:
//				`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "ERROR: No such r-type instruction exists!\n");
//	     		`endif
		endcase  // case(funct)

	 
	 	// immediate instructions: print immediate in decimal
	 	//
	 	// Notes:
	 	//   - lui: decoded addr_imm is used for output.  IMP: probe immediate signal?
	 
	 	addiu_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  addiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	andi_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  andi    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	ori_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  ori     r%0d,  r%0d,  0x%h         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		       	   cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	xori_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  xori    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	lui_opcode:  // prints lui   dest reg (rt)   addr_imm (decoded from instr)
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  lui     r%0d,  0x%8h              Imm=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, addr_imm, addr_imm, rt, rtVal);
//	   		`endif
	 	slti_opcode:
//	   		`ifdef synthesis
//	   		`else
		 	$fwrite(fd, "CC: 0x%16h 0x%h:  slti    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	sltiu_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  sltiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=0x%8h,  R[r%0d]=0x%8h\n",
		        	   cycle_count, addr, rt, rs, addr_imm, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	beq_opcode:
//	   		`ifdef synthesis
//	   		`else // branch immediates displayed in decimal       
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  beq     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rs, rt, addr_imm, rs, rsVal, rt, rtVal);
//	   		`endif
	 	bne_opcode:
//	   		`ifdef synthesis
//	   		`else
            	$fwrite(fd, "CC: 0x%16h 0x%h:  bne     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		             cycle_count, addr, rs, rt, addr_imm, rs, rsVal, rt, rtVal);
//	   		`endif
	 	branch_rt_opcode:
        		case(rt)
	   		bgez_rt:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  bgez    r%0d,  %0d              R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, addr_imm, rs, rsVal);
//	     		`endif
	   		bltz_rt:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  bltz    r%0d,  %0d              R[r%0d]=0x%8h\n",
		          	   cycle_count, addr, rs, addr_imm, rs, rsVal);
//	     		`endif
	   		default: begin
				$fwrite("ERROR: No such branch type exists!\n");
			end
	   		endcase // case(rt)	   
	 	j_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  j                           target=0x%8h\n",
		             cycle_count, addr, {addr[31:28], target_addr, 2'b0});
//	   		`endif
	 	jal_opcode:  // print jal    target, write_data signal to see what's stored in r31
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  jal                         target=0x%8h   R[r%0d]=0x%8h\n",
		             cycle_count, addr, {addr[31:28], target_addr, 2'b0}, 31, value); // addr+4???
//	   		`endif
	 	lw_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  lw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d, R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, addr_imm, rs, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	sw_opcode:	  
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  sw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d, R[r%0d]=0x%8h\n",
		             cycle_count, addr, rt, addr_imm, rs, rs, rsVal, addr_imm, rt, value);
//	   		`endif
	 	default: // output error msg even if instr=32'hx (want to know where instruction don't cares appear)
//	   		`ifdef synthesis
//        		`else
			$fwrite(fd, "ERROR: No instruction exists for op code %d\n", op);
//        		`endif
	 	endcase // case(op)

	end // if (!issue)
     
	end // always@

`endif

     // output instruction/address at head of ROB
	assign commit_instr = (rollback_dout) ? instrs[commit_ptr_dout] : instrs[commit_ptr];
	assign commit_addr = (rollback_dout) ? addr_dout : addr;
	//assign commit_instr = instrs[commit_ptr];
	//assign commit_addr = addr;	

	


	// tapping CDB to get rs and rt values
	always @ (posedge clk)
	  begin
	  	if (issue)
		  begin
			instrs[issue_ptr] <= instrIN;
			rsVals[issue_ptr] <= rsValIN;
			rtVals[issue_ptr] <= rtValIN;
		  end
	  	if (cdb_en)
		  begin
			rsVals[cdb_in_tag] <= cdb_in_VjVk[63:32];
			rtVals[cdb_in_tag] <= cdb_in_VjVk[31:0];
		  end
	  end

endmodule