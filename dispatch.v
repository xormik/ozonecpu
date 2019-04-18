// Module: Decode/Dispatch Unit
// Author: Richard Lin
// Basic Operation: Update register status file, ROB, and appropriate
// reservation stations upon issue.


// Thomas: problem: currently RSFull is set to x occasionally, which should
//             never happen FIXED

// Thomas: jal needs to dispatched to the alu functinal unit, thanks.
// Thomas: what is RSDest?  Do we need it?
// Thomas: Why is destRegReorder named the way it is?  It's an ROB entry number, right?
			  // destRegReorder SAME as RSDest => combine
/* Thomas: I changed these lines:
   in assign RSVj:
           from
 			 (!rsReorder ? (rsHReady? rsHValue : 32'bx) : rsData
           to
		 	 (rsReorder ? (rsHReady? rsHValue : 32'bx) : rsData
   in assign RSQj;
           same change
*/

// Thomas: Just a reminder that RSVk and RSQk cannot just be tied to imm and 0,
//         for r-type instructions

// Thomas: one more reminder: be sure to tap CDB to forward data in the case
//         of issuing and writebacking at the same cycle IMPORTANT

//Victor: Aite....I'm addding the shit for multiplication, someone plz take a look over

// output 6'd32 for mult/div

module dispatch(stall, rollback, clk, rst,
			 robFull, brnchFull, aluFull, mulDivFull, lwFull, swFull,
			 robIssue, regStatIssue, brnchIssue, aluIssue, mulDivIssue, lwIssue, swIssue, 
			 addr,
			 instr, rs, rt, rd,
			 rsReorder, rtReorder,
			 writeReg, writeRegROBEntry, ROBEntryReady,
		      rsData, rtData,
			 RSVj, RSVk, RSQj, RSQk, RSAddrImm, RSBusy,
			 rsH, rsHReady, rsHValue,
			 rtH, rtHReady, rtHValue,
			 ROBEntryAlloc,
			 aluOp, branchOp, mulDivOp,
			 cdb_in, cdb_en,
			 jrStall
			);
  
  // register stuff for rollback
  input rollback;
  input clk, rst;

  // stall/full signals
  input stall; 
  input robFull, brnchFull, aluFull, mulDivFull, lwFull, swFull;
  wire RSFull;	// signal resulting from multiplexing the reservation station full signals
               // multiplexing controlled by op/funct of current instruction *
  
  // issue signals; including WE signals for register status file, ROB, and RS
  output robIssue;
  output regStatIssue;
  output brnchIssue;
  output aluIssue;
  output mulDivIssue;
  output lwIssue;
  output swIssue;
  output jrStall;
  wire issue;
  
  // PC signal
  input [31:0] addr;

  // instruction groups 
  wire ig1, ig2, ig3, ig4, ig5, ig6, ig7, ig8, ig9, ig10, ig11, ig12, ig13, ig14;

  // Instruction signal and decoding signals 
  input [31:0] instr;
  output [5:0] rs;
  output [4:0] rt, rd;	// indexes register status file and register file
  wire [15:0] imm;
  wire [31:0] immExtended;
  wire [5:0] op, funct;  
  wire [4:0] shamt;  

  assign op = instr[31:26];
  assign funct = instr[5:0];
  assign rs = (ig13) ? 6'd32 : {1'b0, instr[25:21]};  // mfhi/mflo is 32
  assign rt = instr[20:16];
  assign rd = instr[15:11];
  assign imm = instr[15:0];
  assign shamt = instr[10:6];

  // register status file signals
  // rs, rt, and rd are already outputted
  input [4:0] rsReorder, rtReorder;	// rs and rt reorder values

  // destination (write) register
  // stored in register status file and allocated ROB entry
  // 6-bits b/c we send 6'b100000 (6'd32) during a multiply/divide to signify writing to HI/LO registers
  output [5:0] writeReg;  

  // ROB entry containing instruction that writes to the destination (write) register
  // stored in register status file and reservation station
  output [4:0] writeRegROBEntry;

  output ROBEntryReady;  // goes to ROB.readyIN.  If we're not issuing to a res station, ROBEntryReady == 1

  // register file signals
  // rs, rt are already outputted
  input [31:0] rsData, rtData;		// rs and rt values from register file

  // reservation station signals
  output [31:0] RSVj, RSVk; 
  output [4:0] RSQj, RSQk;
  output [15:0] RSAddrImm;
  output RSBusy;
   
  // ROB signals
  output [4:0] rsH;			// index ROB[h] for rs
  input rsHReady;			// read ROB[h].Ready for rs
  input [31:0] rsHValue; 	// read ROB[h].Value fo rs 
  
  output [4:0] rtH;			// rt counterpart
  input rtHReady;
  input [31:0] rtHValue;

  input [4:0] ROBEntryAlloc;	// allocated ROB entry

  // alu operation
  output [5:0] aluOp;
  reg [5:0] aluOp;

  // branch operation	   	00 = not a branch
  //						01 = jal 
  //						10 = jr
  //						11 = j
  output [1:0] branchOp;  
 
  // mul/div operations

  output [2:0] mulDivOp;  // implemented by Victor
  reg [2:0] mulDivOp;

  // forwarding data from CDB 
  input [68:0] cdb_in;
  input cdb_en;

  wire [4:0] cdb_in_tag;
  wire [31:0] cdb_in_value;
  wire [31:0] cdb_in_HI;
  assign cdb_in_tag = cdb_in[36:32];
  assign cdb_in_value = cdb_in[31:0];
  assign cdb_in_HI = cdb_in[68:37];

  wire cdb_in_rs; 
  wire cdb_in_rt;
  assign cdb_in_rs = cdb_en & cdb_in_tag == rsReorder;
  assign cdb_in_rt = cdb_en & cdb_in_tag == rtReorder;

  wire rollback_dout;
  register #(1) rollback_reg(.DIN(rollback), 
   				    .DOUT(rollback_dout),
				    .WE(1'b1),
				    .CLK(clk),
				    .RST(rst));

  // parameter constants
  parameter rtype_opcode = 6'b0,	   	  // rtype (opcode 0)
		  addiu_opcode = 6'b001001,     // addiu (opcode 9)	
		  andi_opcode = 6'b001100,	  // andi (opcode 12)		     	 
		  ori_opcode = 6'b001101,	  // ori (opcode 13)
            xori_opcode = 6'b001110,	  // xori (opcode 14)
		  lui_opcode = 6'b001111,	  // lui (opcode 15)
		  slti_opcode = 6'b001010,	  // slti (opcode 10)
            sltiu_opcode = 6'b001011,	  // sltiu (opcode 11)
		  beq_opcode = 6'b000100,	  // beq (opcode 4)
		  bne_opcode = 6'b000101,	  // bne (opcode 5)
            branch_rt_opcode = 6'b000001, //bgez/bltz (opcode 1) differentiated by rt field
            j_opcode = 6'b000010,         // j  (opcode 2)
		  jal_opcode = 6'b000011,	  // jal (opcode 3)
		  lw_opcode = 6'b100011,		  // lw (opcode 35)
		  sw_opcode = 6'b101011;		  // sw (opcode 43)
		  
  parameter addu_funct = 6'b100001,	  // addu (funct 33)
		  subu_funct = 6'b100011,	  // subu (funct 35)
            and_funct = 6'b100100,		  // and (funct 36)
            or_funct =  6'b100101,		  // or (funct 37)
		  xor_funct = 6'b100110,	       // xor (funct 38)
		  sll_funct = 6'b000000,		  // sll (funct 0)
		  sra_funct = 6'b000011,		  // sra (funct 3)
		  srl_funct = 6'b000010,  	  // srl (funct 2)
		  slt_funct = 6'b101010,		  // slt (funct 42)
		  sltu_funct = 6'b101011,	  // sltu(funct 43)
		  jr_funct = 6'b001000,  	  // jr (funct 8)

		  mult_funct = 6'd24, 		  // mult (funct 24)  added by Victor 11-29 EARLY MORNING
		  div_funct  = 6'd26,           //	div  (funct 26)  // not supported?
		  divu_funct = 6'd27, 		  // divu (funct 27)

		  multu_funct =6'b011001,	  // multu(funct 25)
		  mfhi_funct  =6'b010000,	  // mfhi (funct 16)
		  mflo_funct  =6'b010010,	  // mflo (funct 18)
		  break_funct =6'b001101;	  // break(funct 13)


  parameter bgez_rt = 5'b00001,		  // bgez (rt 1)
  		  bltz_rt = 5'b00000;		  // bltz (rt 0)
		
  // signals that signal which group an instruction belongs to; just another abstraction   
  // igx stands for instruction group x where x = {1... 14}
  
  //------------------------------------//
  //Victor: Added this two signals 11-30//
  wire ig13_hi;
  wire ig13_lo;
  assign ig13_hi = (op == rtype_opcode) && (funct == mfhi_funct);
  assign ig13_lo = (op == rtype_opcode) && (funct == mflo_funct);
  //1g 13 = ig13_hi | ig13_lo ; 
  //------------------------------------// 

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
  
  // extend the immediate
  assign immExtended = ig3 ? {imm, 16'h0} :
  				( ((op == addiu_opcode) || (op == slti_opcode) || (op == sltiu_opcode) ||
                	ig5 || ig6 || ig10 || ig11) && imm[15]) ? {16'hffff, imm} : {16'h0, imm};  

  // *multiplex reservation station signals into one busy signal, depending
  // on op/funct of instruction
  // if a break instruction is issued, we just set RSFull to 0
  assign RSFull = (ig1 || ig2 || ig3 || ig4) ? aluFull :			// alu
                  (ig5 || ig6 || ig7 || ig8 || ig9) ? brnchFull :	// branch
			   ig10 ? lwFull :	// lw
			   ig11 ? swFull :	// sw
			   (ig12 || ig13) ? mulDivFull :	// multiply/divide
			   ig14 ? 1'b0 : 1'bx;	// break; 1'bx should never be reached

  assign RSBusy = RSFull | robFull;

  // issue signals
  assign issue = !stall && !robFull && !RSFull && !rollback && !rollback_dout && !jrStall;  
  assign robIssue = issue;	// always write to ROB if we issue
  assign aluIssue = issue && (ig1 || ig2 || ig3 || ig4 || ig9) && writeReg;  // writeReg added by Thomas; don't issue if writing to R0
  assign brnchIssue = issue && (ig5 || ig6); // took out ig7 || ig8
//  assign brnchIssue = issue && (ig5 || ig6) && ~jrStall; // took out ig7 || ig8
  assign mulDivIssue = issue && (ig12 || ig13) && writeReg;	// assign mulDivIssue; multiply/division not supported yet
  						// Thomas: for mfhi and mflo, don't issue if !writeReg
  assign lwIssue = issue && ig10 && writeReg;  // writeReg added by Thomas; don't issue if writing to R0
  assign swIssue = issue && ig11;
  // regStatIssue asserted only for instructions that write to a destination register
  assign regStatIssue = issue && (ig1 || ig2 || ig3 || ig4 || ig9 || ig10 || ig13
  					|| ig12); //Victor: we're writing to the Hi/Lo registers as well

  // rsReorder and rtReorder may contain entries that point to an entry in ROB
  // rsH and rtH gets rsReorder and rtReorder to index the ROB to check source operand status
  assign rtH = rtReorder;
  assign rsH = rsReorder;

  /*
     From alu_reservation..
   	input [31:0] Vj_in;		// shamt for shift instructions, PC+4 for jal, rs for the rest
	input [31:0] Vk_in;		// rt for r-type instructions, extended immed for i-type, 4 for jal
  */
  
  assign jrStall = (ig8 && RSQj);
//	assign jrStall = (ig8 & RSQj) || ((ig5 || ig6) && (RSQj || RSQk));

  // Thomas: one more reminder: be sure to tap CDB to forward data in the case
  //         of issuing and writebacking at the same cycle IMPORTANT
  //    11/26: implemented
  /*
  if in reorder buffer? 
     read order value ready? 
	       return
     else  in CDB
  else
     look in the regFile

  */
  assign RSVj = (ig13_hi)? (rsReorder ? (rsHReady ? rsHValue : (cdb_in_rs ? cdb_in_HI : 32'bx)) : rsData) :
  			 (ig1 || ig2 || ig5 || ig6 || ig8 || ig10 || ig11 || ig12 ) ?  //added 1g13 for mfhi/lo
                (rsReorder ? (rsHReady ? rsHValue : (cdb_in_rs ? cdb_in_value : 32'bx)) : rsData) :
  			 (ig4) ? shamt :
			 (ig9) ? addr :
		      32'b0;			// default takes care of lui case
  
  assign RSQj =  (ig13_lo) ? 5'b0 : //Oj = 0 for all mflo    
  			 (ig7 || ig9) ? 5'b0 :		// set Qj to 0 if j/jal
                (ig1 || ig2 || ig5 || ig6 || ig8 || ig10 || ig11 || ig12 ||ig13_hi) ? // covers jr too //added for mfhi(Vic)
			 (rsReorder ? (rsHReady ? 5'b0 : (cdb_in_rs ? 0 : rsH)) : 5'b0) :
  			 (ig4 || ig3) ? 5'b0 :
			 5'bx;
  
  assign RSVk = (ig13_lo)?   (rsReorder ? (rsHReady ? rsHValue : (cdb_in_rs ? cdb_in_value : 32'bx)) : rsData) :
  			 (ig1 || ig5 || ig11 || ig4 || ig12 ) ?  // ig4 added by Thomas ig 13 by Victor
  			 (rtReorder ? (rtHReady ? rtHValue : (cdb_in_rt ? cdb_in_value : 32'bx)) : rtData) :
			 (ig2 || ig3) ? immExtended :
			 (ig9) ? 8 :
			 32'bx ;
  
  assign RSQk = (ig13_hi )? 5'b0 : //Qk = 0 for all mfhi
  			 (ig13_lo )?  (rsReorder ? (rsHReady ? 5'b0 : (cdb_in_rs ? 0 : rsH)) : 5'b0) :  			
  			 (ig6 || ig7 || ig8 ||ig9) ? 5'b0 :	// set Qk to 0 if j/jal, jr, bgez,bltz
                (ig1 || ig5 || ig11 || ig4 || ig12 ) ?  // ig4 added by Thomas
  			 (rtReorder ? (rtHReady ? 5'b0 : (cdb_in_rt ? 0 : rtH)) : 5'b0) :
			 (ig2 || ig3) ? 5'b0 :
			 5'bx;

  // Added by Thomas 11/27, re-added by Thomas 11/29
  // lw: Vj = base address, Vk = nothing, AddrImm = address offset
  // sw: Vj = base address, Vk = stored value, AddrImm = address offset
  assign RSAddrImm = (ig10 || ig11) ? imm : 16'bx;

  // write register is equal to rd, rt or 31 or 32 depending on the decoded instruction 
  assign writeReg = (ig1 || ig4 || ig13) ? {1'b0, rd} :	// writes to rt
                    (ig2 || ig3 || ig10) ? {1'b0, rt} :	// writes to rd
				ig9 ? {1'b0, 5'd31} :	// jal
				ig12 ? 6'b100000 :	// mult/div
				ig13 ? {1'b0, rd} :
				6'b0;	// don't-care if we do not write to a register   

  // for the specified write register above, set the ROB entry (that contains the instruction that
  // will write to the write register) to the current allocated ROB entry
  assign writeRegROBEntry = ROBEntryAlloc; 

  // Goes to ROB.readyIN.  If we're not issuing to a res station, we want to set this bit to 1 so that
  // the rob will not be expecting a value from CDB
  assign ROBEntryReady = ~(aluIssue | mulDivIssue | lwIssue | brnchIssue | swIssue);

  // branch op

  assign branchOp = {(ig7 | ig8) , (ig7 | ig9)};
  
  // per Thomas' request, dispatch unit will specify the ALU operation
  // in 6-bits.
  // instruction: code 
  // addu/addiu: 000000 
  // and/andi: 000001 
  // or/ori: 000010 
  // xor/xori: 000011 
  // subu: 000100 
  // slt/slti: 010100 
  // sltu/sltiu: 011100 
  // sll: 100000 
  // srl: 100010 
  // sra: 100011

  always @ (op or funct)
  begin
	if (op == 0 )
	  begin
		case(funct)
		mult_funct:	mulDivOp <= 3'b011;	  // mult (funct 24)  added by Victor 11-29 EARLY MORNING
		div_funct:	mulDivOp <= 3'bxxx;  //	div  (funct 26)
		divu_funct:	mulDivOp <= 3'b000;   // divu (funct 27)
		multu_funct: 	mulDivOp <= 3'b010;	 // multu(funct 25)
		mfhi_funct: 	mulDivOp <= 3'b100;  // mfhi 
		mflo_funct: 	mulDivOp <= 3'b110;  //mflo
	    	default:
		mulDivOp <= 3'bxxx; // added by Victor
		endcase
	  end
	else
		mulDivOp <= 3'bxxx; //YEA X U FOR FUN
end


  always @ (op or funct)
  begin
    case(op)
    6'd0:
      case(funct)
	 6'd0: aluOp <= 6'b100000;	// sll
	 6'd2: aluOp <= 6'b100010;	// srl
	 6'd3: aluOp <= 6'b100011;	// sra
	 6'd33: aluOp <= 6'b000000;	// addu
	 6'd35: aluOp <= 6'b000100;	// subu
	 6'd36: aluOp <= 6'b000001;	// and
	 6'd37: aluOp <= 6'b000010;	// or
	 6'd38: aluOp <= 6'b000011;	// xor
	 6'd42: aluOp <= 6'b010100;	// slt
	 6'd43: aluOp <= 6'b011100;	// sltu 
	 default: 
	 aluOp <= 6'b000000; // added by Thomas
	 endcase
    6'd9: aluOp <= 6'b000000;		// addiu
    6'd12: aluOp <= 6'b000001;	// andi
    6'd13: aluOp <= 6'b000010;	// ori
    6'd14: aluOp <= 6'b000011;	// xori
    6'd10: aluOp <= 6'b010100;	// slti
    6'd11: aluOp <= 6'b011100;	// sltiu
    jal_opcode: aluOp <= 6'b000000;  // jal same as add just pc+8
    default: aluOp <= 6'b000000;   // added by Thomas
    endcase
  end


endmodule