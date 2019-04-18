/*
 *  Author: Richard Lin
 *  Module: Disassembly Monitor / Debugger
 *  Date: 10/24/03
 *
 *  Note:
 *  - rs_data and rt_data are used for the control instructions (ID stage)
 *    alu_in1 and alu_in2 are used for all other instructions that are in EX stage
 *  - IMP:  use "IMP:" to search for notes of concern in file.
 */

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


`timescale 1ns/1ps

module dmdb(clk,
            instr_addr,
		  instr,

            // IF signals

		  // ID signals
		  rs_data,
		  rt_data,
		  // EX signals
            alu_in1,
		  alu_in2,

		  // MEM signals
            mem_data_in,

		  // WB signals
		  write_data,

            // stall signals
  		  hazard_stall,   // from ID stage
		  wb_stall,	   // from MEM stage
		  break_stall,	   // from ID stage
		  instmiss_stall, // from MEM stage
		  datamiss_stall  // from MEM stage
		  /*synthesis black_box*/);

// general signals
  input clk;
  input [31:0] instr_addr;  // address of instruction
  input [31:0] instr;      // instruction from memory

// IF signals

// ID signals
  input [31:0] rs_data, rt_data;

// EX signals
  input [31:0] alu_in1, alu_in2;

// MEM signals
  input [31:0] mem_data_in;               // used for store word (mem_data_in is what we're trying to store)

// WB signals
  input [31:0] write_data;

// Stall signals
// Types of stalls: lw, break, multiply, instr cache?, data cache?, writebuffer?
  input wb_stall;
  input hazard_stall;                     // stall resulting from pipeline interlock (where lw follows by
                                          // a subset of the control instructions that depend on rd of lw;
                                          // and multiply wait
  input break_stall;
  input instmiss_stall;
  input datamiss_stall;


// Memory signals 
  
// dmdb() options
  parameter debug = 1'b1;  // if 1, output all information, else output just instruction

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
		  multu_funct =6'b011001,	  // multu(funct 25)
		  mfhi_funct  =6'b010000,	  // mfhi (funct 16)
		  mflo_funct  =6'b010010,	  // mflo (funct 18)
		  break_funct =6'b001101;	  // break(funct 13)

  parameter bgez_rt = 5'b00001,		  // bgez (rt 1)
  		  bltz_rt = 5'b00000;		  // bltz (rt 0)

  // open file for writing
  `ifdef synthesis
  `else
    integer fd = 0;
    initial begin
    fd = $fopen("trace.txt", "w");
    end
  `endif

  // mini-pipeline

  reg [31:0] IFIDinstr, IDEXinstr, EXMEMinstr, MEMWBinstr;
  reg [31:0] IFIDinstr_addr, IDEXinstr_addr, EXMEMinstr_addr, MEMWBinstr_addr;
  reg [31:0] EXMEMalu_in1, MEMWBalu_in1, EXMEMalu_in2, MEMWBalu_in2;	// inputs to ALU (from EX stage) 
  reg [31:0] IDEXrs, EXMEMrs, MEMWBrs, IDEXrt, EXMEMrt, MEMWBrt;      // inputs to branches (from ID stage)
  reg [31:0] EXMEMmem_data_in;
  reg [31:0] MEMWBmem_data_in;

 
  // input stall signals
  wire stall_partial;	// state where IF/ID register's WE is disabled
  wire stall_all;        // state where all pipelined registers' WE are disabled

  assign stall_partial = hazard_stall | break_stall | instmiss_stall; 
  assign stall_all = wb_stall | datamiss_stall;
  
  // pipeline stall signals
  wire IFstall, IDstall, MEMstall;
  reg IDEX_IDstall, EXMEM_IDstall, MEMWB_IDstall, MEMWB_MEMstall;
  reg IFID_IFstall, IDEX_IFstall, EXMEM_IFstall, MEMWB_IFstall;

  assign IFstall = instmiss_stall;
  assign IDstall =	hazard_stall | break_stall;
  assign MEMstall = wb_stall | datamiss_stall;

  always @ (posedge clk)
  begin

  // partial stall
  if (stall_partial == 1'b1) 
  begin
  
    // IFID WE disabled
    IDEXinstr <= IFIDinstr;
    EXMEMinstr <= IDEXinstr;
    MEMWBinstr <= EXMEMinstr;
    
    // PC WE disabled
    IDEXinstr_addr <= IFIDinstr_addr;
    EXMEMinstr_addr <= IDEXinstr_addr;
    MEMWBinstr_addr <= EXMEMinstr_addr;
     
    // All other registers continue to be enabled  
    EXMEMalu_in1 <= alu_in1; 
    MEMWBalu_in1	<= EXMEMalu_in1;

    EXMEMalu_in2	<= alu_in2;
    MEMWBalu_in2	<= EXMEMalu_in2;

    IDEXrs <= rs_data;
    EXMEMrs	<= IDEXrs;
    MEMWBrs	<= EXMEMrs;

    IDEXrt <= rt_data;
    EXMEMrt	<= IDEXrt;
    MEMWBrt	<= EXMEMrt;

    // for sw
    EXMEMmem_data_in <= mem_data_in;
    MEMWBmem_data_in <= EXMEMmem_data_in;

    IDEX_IDstall  <= IDstall;
    EXMEM_IDstall <= IDEX_IDstall;
    MEMWB_IDstall <= EXMEM_IDstall;

    MEMWB_MEMstall <= MEMstall;
    
     // IFID WE disabled?
    IDEX_IFstall <= IFID_IFstall;
    EXMEM_IFstall <= IDEX_IFstall;
    MEMWB_IFstall <= EXMEM_IFstall;


  end
  else if (stall_all == 1'b1)
  begin
    // all pipeline registers disabled, do nothing
    MEMWB_MEMstall <= MEMstall;  

  end
  else
  begin // no stall
    IFIDinstr <= instr;
    IDEXinstr <= IFIDinstr;
    EXMEMinstr <= IDEXinstr;
    MEMWBinstr <= EXMEMinstr;

    IFIDinstr_addr <= instr_addr; 
    IDEXinstr_addr <= IFIDinstr_addr;
    EXMEMinstr_addr <= IDEXinstr_addr;
    MEMWBinstr_addr <= EXMEMinstr_addr;
 
    EXMEMalu_in1 <= alu_in1; 
    MEMWBalu_in1	<= EXMEMalu_in1;

    EXMEMalu_in2	<= alu_in2;
    MEMWBalu_in2	<= EXMEMalu_in2;

    IDEXrs <= rs_data;
    EXMEMrs	<= IDEXrs;
    MEMWBrs	<= EXMEMrs;

    IDEXrt <= rt_data;
    EXMEMrt <= IDEXrt;
    MEMWBrt <= EXMEMrt;

    // for sw
    EXMEMmem_data_in <= mem_data_in;
    MEMWBmem_data_in <= EXMEMmem_data_in;
  
    IDEX_IDstall  <= IDstall;
    EXMEM_IDstall <= IDEX_IDstall;
    MEMWB_IDstall <= EXMEM_IDstall;

    MEMWB_MEMstall <= MEMstall;
    
    IFID_IFstall <= IFstall;
    IDEX_IFstall <= IFID_IFstall;
    EXMEM_IFstall <= IDEX_IFstall;
    MEMWB_IFstall <= EXMEM_IFstall;
  
  end

    // Need to pipeline a stall b/c we want to print stall in WB stage
    // stall signals
    //hazard_stall,   // from ID stage
    //wb_stall,	   // from MEM stage
    //break_stall,	   // from ID stage
    //instmiss_stall, // from MEM stage
    //datamiss_stall  // from MEM stage
 
    //IDEX_IDstall  <= IDstall;
    //EXMEM_IDstall <= IDEX_IDstall;
    //MEMWB_IDstall <= EXMEM_IDstall;

    //MEMWB_MEMstall <= MEMstall;
    // MEMWB_MEMstall <= MEMstall;
  end

  
// 32-bit instruction format deconstruction (FOR USE IN WB STAGE WHEN PRINTING INSTRUCTIONS)
  wire [5:0] op, funct;
  wire [4:0] rs, rt, rd, shamt;
  wire [15:0] addr_imm;
  wire [25:0] target_addr;
  wire [19:0] break_code;

  assign op = MEMWBinstr[31:26];
  assign rs = MEMWBinstr[25:21];
  assign rt = MEMWBinstr[20:16];
  assign rd = MEMWBinstr[15:11];
  assign shamt = MEMWBinstr[10:6];
  assign funct = MEMWBinstr[5:0];
  assign addr_imm = MEMWBinstr[15:0];
  assign target_addr = MEMWBinstr[25:0];
  assign break_code = MEMWBinstr[25:6];

  // output instructions

  // Note: $fwrite needs \n, whereas $display already adds a \n.  So leave out \n in $display

  always @ (negedge clk)
  begin

   

    if (MEMWB_IFstall == 1'b1 || MEMWB_IDstall == 1'b1 || MEMWB_MEMstall == 1'b1)  // if stall, print stall on ?
                              // we don't want to print out garbage so print stall
      begin
	   `ifdef synthesis
	   `else
        $fwrite(fd, "Stall!\n");
        $display("Stall!!");
	   `endif
	 end

    else
    begin
      case(op)
      rtype_opcode:
        
	   // Make sure rtypes have proper format!!!
	   // rs and rt values comes from alu_in1 and alu_in2 (account for forwarding)
	   // rd values come from write_data
	   // Exceptions:
	   //   sll, sra, srl: shamt is decoded from instr.  IMP: USE WIRE TO PROBE INSTEAD?
	   //   jr: rs values comes from MEMWBrs since jr needs value in ID stage
	   //   break: break code is decoded from instr.

	   case(funct)
	   addu_funct:
	     `ifdef synthesis
	     `else
		begin
		  $fwrite(fd, "0x%h:  addu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  addu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   subu_funct:
	     `ifdef synthesis
	     `else
	     begin	
		  $fwrite(fd, "0x%h:  subu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  subu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
		`endif
	   and_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  and     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  and     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   or_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  or      r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  or      r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   xor_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  xor     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  xor     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   sll_funct:
	     `ifdef synthesis

	     `else
	     begin
		  $fwrite(fd, "0x%h:  sll     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);  
		  $display("0x%h:  sll     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);
		end
	     `endif
	   sra_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  sra     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);  
		  $display("0x%h:  sra     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);
		end
	     `endif
	   srl_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  srl     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);  
		  $display("0x%h:  srl     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  shamt=%0d,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rd, rt, shamt, rt, MEMWBalu_in2, shamt, rd, write_data);
		end
	     `endif
	   slt_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  slt     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  slt     r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   sltu_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  sltu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
				MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		  $display("0x%h:  sltu    r%0d,  r%0d,  r%0d        R[r%0d]=0x%8h,  R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
				 MEMWBinstr_addr, rd, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2, rd, write_data);
		end
	     `endif
	   jr_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  jr      r%0d                  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, rs, MEMWBrs);       
		  $display("0x%h:  jr      r%0d                  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rs, rs, MEMWBrs);

		end
	     `endif
	   multu_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  multu   r%0d,  r%0d,            R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2);
            $display("0x%h:  multu   r%0d,  r%0d,            R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rs, rt, rs, MEMWBalu_in1, rt, MEMWBalu_in2);
		end
	     `endif
	   mfhi_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  mfhi    r%0d                  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rd, rd, write_data);
            $display("0x%h:  mfhi    r%0d                  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rd, rd, write_data);
		end
	     `endif
	   mflo_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  mflo    r%0d                  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rd, rd, write_data);
		  $display("0x%h:  mflo    r%0d                  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rd, rd, write_data);
		end
	     `endif
	   break_funct:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  break   0x%h\n",
		  		MEMWBinstr_addr, break_code); 
		  $display("0x%h:  break   0x%h",
		  		 MEMWBinstr_addr, break_code);
		end
	     `endif
	   default:
	     begin
		end
	   endcase  // case(funct)
	 
	 // immediate instructions: print immediate in decimal
	 //
	 // Notes:
	 //   - lui: decoded addr_imm is used for output.  IMP: probe immediate signal?
	 
	 addiu_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  addiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  addiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 andi_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  andi    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  andi    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 ori_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  ori     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  ori     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 xori_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  xori    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  xori    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);  
		end
	   `endif
	 lui_opcode:  // prints lui   dest reg (rt)   addr_imm (decoded from instr)
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  lui     r%0d,  %0d              Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, addr_imm, addr_imm, rt, write_data);
		  $display("0x%h:  lui     r%0d,  %0d              Imm=%0d,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rt, addr_imm, addr_imm, rt, write_data);
		end
	   `endif
	 slti_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  slti    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  slti    r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 sltiu_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  sltiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  sltiu   r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, rs, addr_imm, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 beq_opcode:
	   `ifdef synthesis
	   `else
	     begin  // branch immediates displayed in decimal
		  $fwrite(fd, "0x%h:  beq     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, rt, addr_imm, rs, MEMWBrs, rt, MEMWBrt); 
		  $display("0x%h:  beq     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rs, rt, addr_imm, rs, MEMWBrs, rt, MEMWBrt);
		end
	   `endif
	 bne_opcode:
	   `ifdef synthesis
	   `else
	     begin
            $fwrite(fd, "0x%h:  bne     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, rt, addr_imm, rs, MEMWBrs, rt, MEMWBrt); 
		  $display("0x%h:  bne     r%0d,  r%0d,  %0d         R[r%0d]=0x%8h,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rs, rt, addr_imm, rs, MEMWBrs, rt, MEMWBrt);
		end
	   `endif
	 branch_rt_opcode:
        case(rt)
	   bgez_rt:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  bgez    r%0d,  %0d              R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, addr_imm, rs, MEMWBrs);
		  $display("0x%h:  bgez    r%0d,  %0d              R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rs, addr_imm, rs, MEMWBrs);  		
		end
	     `endif
	   bltz_rt:
	     `ifdef synthesis
	     `else
	     begin
		  $fwrite(fd, "0x%h:  bltz    r%0d,  %0d              R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rs, addr_imm, rs, MEMWBrs);
		  $display("0x%h:  bltz    r%0d,  %0d              R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rs, addr_imm, rs, MEMWBrs);
		end
	     `endif
	   default:
	     begin
		end
	   endcase // case(rt)	   
	 j_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  j                           target=0x%8h\n",
		          MEMWBinstr_addr, {MEMWBinstr_addr[31:28], target_addr, 2'b0});
		  $display("0x%h:  j                           target=0x%8h",
		          MEMWBinstr_addr, {MEMWBinstr_addr[31:28], target_addr, 2'b0});		
		end
	   `endif
	 jal_opcode:  // print jal    target, write_data signal to see what's stored in r31
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  jal                         target=0x%8h,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, {MEMWBinstr_addr[31:28], target_addr, 2'b0}, 31, write_data);
	       $display("0x%h:  jal                         target=0x%8h,  R[r%0d]=0x%8h",
		           MEMWBinstr_addr, {MEMWBinstr_addr[31:28], target_addr, 2'b0}, 31, write_data);
		end
	   `endif
	 lw_opcode:
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  lw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d, R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, addr_imm, rs, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		  $display("0x%h:  lw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d, R[r%0d]=0x%8h",
		           MEMWBinstr_addr, rt, addr_imm, rs, rs, MEMWBalu_in1, MEMWBalu_in2, rt, write_data);
		end
	   `endif
	 sw_opcode:	  // IMP: need to extend to show what's being stored, for now use rt_data,
	                 // can later extend it to sample the data in the MEM stage before it is stored
				  // perhaps need to sample data in MEM stage to account for forwarding effects DONE!
	   `ifdef synthesis
	   `else
	     begin
		  $fwrite(fd, "0x%h:  sw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h\n",
		          MEMWBinstr_addr, rt, addr_imm, rs, rs, MEMWBalu_in1, MEMWBalu_in2, rt, MEMWBmem_data_in);
		  $display("0x%h:  sw      r%0d,  %0d(r%0d)          R[r%0d]=0x%8h,  Imm=%0d,  R[r%0d]=0x%8h",
		          MEMWBinstr_addr, rt, addr_imm, rs, rs, MEMWBalu_in1, MEMWBalu_in2, rt, MEMWBmem_data_in);
		end
	   `endif
	 default: // output error msg even if instr=32'hx (want to know where instruction don't cares appear)
	   `ifdef synthesis
        `else
        begin
	     //if (instr != 32'hx)
		//begin
		$fwrite(fd, "No instruction exists for op code %d\n", op);
		$display("No instruction exists for op code %d", op);
	     //end
	   end
        `endif
	 endcase // case(op)
    
      // check
	 if (debug == 1'b1)
	   begin
	     // print extra info
	   
	     // cycle counter
	   end
    
      
    end // else
  end  // always

/*
   for each instruction,
   if synthesis
     do nothing
   else
	fwrite/display full info
	fwrite/display addr/instr only

  Notes:
    alu inputs: i.e. addu, addiu
    rs/rt inputs: i.e. beq
    ...

*/

endmodule
