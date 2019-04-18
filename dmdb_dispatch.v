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
    Trace outputted to trace_dispatch.txt.
    Dispatch trace is not outputted to  ModelSim output.
    However, the commit trace is ouputted to ModelSim output.
*/

module dmdb_dispatch(clk, instr, addr, issue, cycle_count);

	input clk;
	input [31:0] instr;
	input [31:0] addr;
	
	// asserted upon issue of instruction
	// so, we only print when we issue to ROB
	input issue;	

	// cycle count
	input [63:0] cycle_count;

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



	// open file for writing
  	`ifdef synthesis
		wire dummy;
  	`else
    		integer fd = 0;
    		initial begin
    		fd = $fopen("trace_dispatch.txt", "w");
    		end


	always @ (negedge clk)
	begin

	if (!issue)
	begin
		$fwrite(fd, "CC: 0x%16h No Issue\n",
			   cycle_count);
	end
	else
	begin
		case(op)
      	rtype_opcode:
	   		case(funct)
	   		addu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  addu    r%0d,  r%0d, r%0d\n",
					   cycle_count, addr, rd, rs, rt); 
//	     		`endif
	   		subu_funct:
//	     		`ifdef synthesis
//	     		`else
				$fwrite(fd, "CC: 0x%16h 0x%h:  subu    r%0d,  r%0d, r%0d\n",
					   cycle_count, addr, rd, rs, rt); 	     
//				`endif
	   		and_funct:
//	     		`ifdef synthesis
//	     		`else
		 		$fwrite(fd, "CC: 0x%16h 0x%h:  and     r%0d,  r%0d,  r%0d\n",
		          	   cycle_count, addr, rd, rs, rt);
//	     		`endif
	   		or_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  or      r%0d,  r%0d,  r%0d\n",
		 			   cycle_count, addr, rd, rs, rt);
//	     		`endif
	   		xor_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  xor     r%0d,  r%0d,  r%0d\n",
					   cycle_count, addr, rd, rs, rt);
//			     `endif
	   		sll_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sll     r%0d,  r%0d,  %0d\n",
		                  cycle_count, addr, rd, rt, shamt);
//		 		`endif
	   		sra_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sra     r%0d,  r%0d,  %0d\n",
		          	   cycle_count, addr, rd, rt, shamt);
//	     		`endif
	   		srl_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  srl     r%0d,  r%0d,  %0d\n",
		          	   cycle_count, addr, rd, rt, shamt);
//	     		`endif
	   		slt_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  slt     r%0d,  r%0d,  r%0d\n",
					   cycle_count, addr, rd, rs, rt);
//	     		`endif
	   		sltu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  sltu    r%0d,  r%0d,  r%0d\n",
					   cycle_count, addr, rd, rs, rt);
//	     		`endif
	   		jr_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  jr      r%0d\n",
		          	   cycle_count, addr, rs);
//	     		`endif
	   		multu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  multu   r%0d,  r%0d\n",
		          	   cycle_count, addr, rs, rt);
//	     		`endif
	   		mult_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mult    r%0d,  r%0d\n",
		          	   cycle_count, addr, rs, rt);
//	     		`endif
	   		divu_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  divu    r%0d,  r%0d\n",
		          	   cycle_count, addr, rs, rt);
//	     		`endif
	   		div_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  div     r%0d,  r%0d\n",
		          	   cycle_count, addr, rs, rt);
//	     		`endif				
	   		mfhi_funct:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mfhi    r%0d\n",
		          	   cycle_count, addr, rd);
//	     		`endif
	   		mflo_funct:
//	     		`ifdef synthesis
//	     	 	`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  mflo    r%0d\n",
		          	   cycle_count, addr, rd);
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
		  		$fwrite(fd, "No such r-type instruction exists!\n");
//	     		`endif
		endcase  // case(funct)
	 	addiu_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  addiu   r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	andi_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  andi    r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	ori_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  ori     r%0d,  r%0d,  0x%8h\n",
		       	   cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	xori_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  xori    r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	lui_opcode:  // prints lui   dest reg (rt)   addr_imm (decoded from instr)
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  lui     r%0d,  0x%8h\n",
		             cycle_count, addr, rt, addr_imm);
//	   		`endif
	 	slti_opcode:
//	   		`ifdef synthesis
//	   		`else
		 	$fwrite(fd, "CC: 0x%16h 0x%h:  slti    r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	sltiu_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  sltiu   r%0d,  r%0d,  0x%8h\n",
		        	   cycle_count, addr, rt, rs, addr_imm);
//	   		`endif
	 	beq_opcode:
//	   		`ifdef synthesis
//	   		`else    
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  beq     r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rs, rt, addr_imm);
//	   		`endif
	 	bne_opcode:
//	   		`ifdef synthesis
//	   		`else
            	$fwrite(fd, "CC: 0x%16h 0x%h:  bne     r%0d,  r%0d,  0x%8h\n",
		             cycle_count, addr, rs, rt, addr_imm);
//	   		`endif
	 	branch_rt_opcode:
        		case(rt)
	   		bgez_rt:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  bgez    r%0d,  0x%8h\n",
		          	   cycle_count, addr, rs, addr_imm);
//	     		`endif
	   		bltz_rt:
//	     		`ifdef synthesis
//	     		`else
		  		$fwrite(fd, "CC: 0x%16h 0x%h:  bltz    r%0d,  0x%8h\n",
		          	   cycle_count, addr, rs, addr_imm);
//	     		`endif
	   		default:
	     	begin
				$fwrite("No such branch type exists!\n");
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
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  jal                         target=0x%8h\n",
		             cycle_count, addr, {addr[31:28], target_addr, 2'b0});
//	   		`endif
	 	lw_opcode:
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  lw      r%0d,  0x%8h(r%0d)\n",
		             cycle_count, addr, rt, addr_imm, rs);
//	   		`endif
	 	sw_opcode:	  
//	   		`ifdef synthesis
//	   		`else
		  	$fwrite(fd, "CC: 0x%16h 0x%h:  sw      r%0d,  0x%8h(r%0d)\n",
		             cycle_count, addr, rt, addr_imm, rs);
//	   		`endif
	 	default: // output error msg even if instr=32'hx (want to know where instruction don't cares appear)
//	   		`ifdef synthesis
//        		`else
			$fwrite(fd, "No instruction exists for op code %d\n", op);
//        		`endif
	 	endcase // case(op)

	end // if (!issue)
     
	end // always@

`endif

endmodule
