//------------------------------------------------------------------
//-- Verilog Model "sramblock2048.v" 
//--	a Single Port 256 line word RAM w/ Synch Read, Synch Write, Synch Reset
//--		Initializes memory to contents in the file "memory.contents"
//--		where each line in the file represents a line in memory in hexidecimal 
//--		- says Ben Liao
//--
//--	for use by Spring 2003 Computer Science 152 only
//--
//--	256 word lines (32-bit = word)
//--	
//--	in order of precedence of signals:
//--		en, rst, we
//--		which means if en == 0 and rst == 1, nothing happens
//-------------------------------------------------------------------
module ramblock2048 (addr, clk, din, dout, we);
input [10 : 0] addr;
input clk;
input [31 : 0] din;
output [31 : 0] dout;
input we;

datasource tempBlock(.addr(addr), .clk(clk), .din(din), .dout2(dout), 
				    .en(1), .we(we));

// We do not initialize the cache.  -Thomas

//----------EDIT MEMORY INITIALIZATION FILE HERE---------------------
//defparam tempBlock.inputFile = "memory.contents";
//---------- if you want to have this mem block initialize with the
//---------- initialization file, set noInitVector to 0, else the mem
//---------- block will initialize to all 0 values.
defparam tempBlock.noInitVector = 1;
//-------------------------------------------------------------------

endmodule

module datasource (
	addr,
	clk,
	din,
	dout,
	dout2,
	en,
	we);    // synthesis black_box

input [10 : 0] addr;
input clk;
input [31 : 0] din;
output [31 : 0] dout, dout2;
input en;
input we;

parameter inputFile = 0;
parameter noInitVector = 0;

// synopsys translate_off

	BLKMEMSP_V4_0 #(
		11,	// c_addr_width
		"0",	// c_default_data
		2048,	// c_depth
		0,	// c_family
		noInitVector,	// c_has_default_data  HAVE TO SET TO 0 to load init file!! 
		1,	// c_has_din
		1,	// c_has_en
		0,	// c_has_limit_data_pitch
		0,	// c_has_nd
		0,	// c_has_rdy
		0,	// c_has_rfd
		0,	// c_has_sinit
		1,	// c_has_we
		8,	// c_limit_data_pitch
		inputFile,	// c_mem_init_file
		0,	// c_pipe_stages
		0,	// c_reg_inputs
		"0",	// c_sinit_value
		32,	// c_width
		0,	// c_write_mode
		"0",	// c_ybottom_addr
		1,	// c_yclk_is_rising
		1,	// c_yen_is_high
		"ramblock2048",	// c_yhierarchy
		0,	// c_ymake_bmm
		"4kx1",	// c_yprimitive_type
		1,	// c_ysinit_is_high
		"1024",	// c_ytop_addr
		0,	// c_yuse_single_primitive
		1)	// c_ywe_is_high
	inst (
		.ADDR(addr),
		.CLK(clk),
		.DIN(din),
		.DOUT(dout),
		.DOUT2(dout2),
		.EN(en),
		.WE(we),
		.ND(),
		.RFD(),
		.RDY(),
		.SINIT());


// synopsys translate_on

// FPGA Express black box declaration
// synopsys attribute fpga_dont_touch "true"
// synthesis attribute fpga_dont_touch of ramblock2048 is "true"

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of ramblock2048 is "black_box"

endmodule
/*******************************************************************
* This file is owned and controlled by Xilinx and must be used     *
* solely for design, simulation, implementation and creation of    *
* design files limited to Xilinx devices or technologies. Use      *
* with non-Xilinx devices or technologies is expressly prohibited  *
* and immediately terminates your license.                         *
*                                                                  *
* Xilinx products are not intended for use in life support         *
* appliances, devices, or systems. Use in such applications are    *
* expressly prohibited.                                            *
*                                                                  *
* Copyright (C) 2001, Xilinx, Inc.  All Rights Reserved.           *
*******************************************************************/ 

// The synopsys directives "translate_off/translate_on" specified
// below are supported by XST, FPGA Express, Exemplar and Synplicity
// synthesis tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file ramblock2048.v when simulating
// the core, ramblock2048. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "Coregen Users Guide".
/*****************************************************************************
 * $Id: sramblock2048.v,v 1.1 2003/11/27 11:02:34 cs152-aj Exp $
 *****************************************************************************
 * Block Memory Compiler - Verilog Behavioral Model
 *****************************************************************************
 *
 * This File is owned and controlled by Xilinx and must be used solely  
 * for design, simulation, implementation and creation of design files   
 * limited to Xilinx devices or technologies. Use with non-Xilinx       
 * devices or technologies is expressly prohibited and immediately      
 * terminates your license.                                             
 *                                                                      
 * Xilinx products are not intended for use in life support             
 * appliances, devices, or systems. Use in such applications is          
 * expressly prohibited.
 * 
 *        ****************************
 *        ** Copyright Xilinx, Inc. **
 *        ** All rights reserved.   **
 *        ****************************
 *
 *************************************************************************
 * Filename:   blkmemsp_v4_0
 *
 * Decsription: Single Port V2 BRAM behavioral model. Extendable depth/width.
 *              The behavior for EN = `X`, WE = `X`, and for CLK transitions to
 *              or from `X` is not considered.
 *
 **************************************************************************/
`timescale 1ns/10ps

`celldefine


`define c_sp_rom 0
`define c_sp_ram 1
`define c_write_first 0
`define c_read_first  1
`define c_no_change   2

module BLKMEMSP_V4_0(DOUT, DOUT2, ADDR, DIN,  EN, CLK, WE, SINIT, ND, RFD, RDY);

  parameter  c_addr_width          =  9 ; // controls address width of memory
  parameter  c_default_data        = "0"; // indicates string of hex characters used to initialize memory
  parameter  c_depth               = 512 ; // controls depth of memory
  parameter  c_enable_rlocs        = 0 ; //  core includes placement constraints
  parameter  c_has_default_data    =  0; // initializes contents of memory to c_default_data
  parameter  c_has_din             = 1  ; // indicates memory has data input pins
  parameter  c_has_en              =  1 ; // indicates memory has a EN pin
  parameter  c_has_limit_data_pitch       = 0  ; //  
  parameter  c_has_nd              = 0  ; //  Memory has a new data pin
  parameter  c_has_rdy             = 0  ; //  Memory has result ready pin
  parameter  c_has_rfd             = 0  ; //  Memory has ready for data pin
  parameter  c_has_sinit           =  1 ; // indicates memory has a SINIT pin
  parameter  c_has_we              =  1 ; // indicates memory has a WE pin
  parameter  c_limit_data_pitch           = 18; 
  parameter  c_mem_init_file       =  "null.mif";  // controls which .mif file used to initialize memory
  parameter  c_pipe_stages         =  1 ; // indicates the number of pipe stages needed in port A
  parameter  c_reg_inputs          = 0 ;  // indicates WE, ADDR, and DIN are registered
  parameter  c_sinit_value         = "0000"; // indicates string of hex used to initialize  output registers
  parameter  c_width               =  32 ; // controls data width of memory
  parameter  c_write_mode          =  2; // controls which write modes shall be used
   
  parameter  c_ybottom_addr        = "1024";
  parameter  c_yclk_is_rising      = 1;
  parameter  c_yen_is_high         = 1;
  parameter  c_yhierarchy          = "hierarchy1";
  parameter  c_ymake_bmm           = 1;
  parameter  c_yprimitive_type     = "4kx4";
  parameter  c_ysinit_is_high      = 1;
  parameter  c_ytop_addr           = "0";
  parameter  c_yuse_single_primitive = 0;
  parameter  c_ywe_is_high         = 1;

// IO ports


  output [c_width-1:0] DOUT, DOUT2;
  input [c_addr_width-1:0] ADDR;
  input [c_width-1:0] DIN;
  input EN, CLK, WE, SINIT, ND;
  output RFD, RDY;

  //added by Ben
  wire  [c_width-1:0] DOUT2;

  reg RFD ;
  reg RDY ;

  reg [c_width-1:0] dout_int; // output of RAM
  reg [c_width-1:0] pipe_out ; // output of pipeline stage
  wire [c_width-1:0] DOUT = pipe_out ;
  reg [c_depth*c_width-1:0] mem;
  reg [24:0] count;
  reg [1:0] wr_mode;

  wire [c_addr_width-1:0] addr_i = ADDR;
  reg [c_addr_width-1:0] addr_int ;
  reg [c_width-1:0] di_int ;
  wire [c_width-1:0] di_i ;
  wire clk_int ;
  wire en_int ;
  reg we_int  ;
  wire we_i ;
  reg  we_q ;
  wire ssr_int  ;
  wire nd_int ;
  wire nd_i ;
  reg rfd_int ;
  reg rdy_int ;
  reg nd_q ;
  reg [c_width-1:0] di_q ;
  reg [c_addr_width-1:0] addr_q;
  reg new_data ;
  reg new_data_q ; // to track the synchronous PORT RAM output 

  reg [c_width-1:0] default_data ;
  reg [c_width-1:0] ram_temp [0:c_depth-1];
  reg [c_width-1:0] bitval;
  reg [c_width-1:0] sinit_value;

  reg [(c_width-1) : 0] pipeline [0 : c_pipe_stages];
  reg sub_rdy[0 : c_pipe_stages];
  reg [10:0] ci, cj ;
  reg [10:0] dmi, dmj, dni, dnj, doi, doj ;
  integer i, j, k, l, m;
  integer ai, aj, ak, al, am, an, ap ;


// Generate input control signals
// Combinational 

// Take care of ROM/RAM functionality

  assign clk_int = defval(CLK, 1, 1, c_yclk_is_rising);
  assign we_i = defval(WE, c_has_we, 0, c_ywe_is_high);  
  assign di_i  = (c_has_din == 1)?DIN:'b0;
  assign en_int  = defval(EN, c_has_en, 1, c_yen_is_high);
  assign ssr_int = defval(SINIT , c_has_sinit , 0, c_ysinit_is_high);
  assign nd_i = defval (ND, c_has_nd, 1, 1);


//    tri0 GSR = glbl.GSR;

  function defval;
    input i;
    input hassig;
    input val;  
    input active_high;
  begin
    if(hassig == 1)
    begin
      if (active_high == 1)
        defval = i;
      else
        defval = ~i;
    end
    else
      defval = val;
  end
  endfunction

  function max;
    input a;  
    input b;
  begin
    max = (a > b) ? a : b;
  end
  endfunction
 
  function a_is_X;
    input [c_width-1 : 0] i;
    integer j ;
  begin
    a_is_X = 1'b0;
    for(j = 0; j < c_width; j = j + 1)
    begin
      if(i[j] === 1'bx)
        a_is_X = 1'b1;
    end // loop
  end
  endfunction


  function [c_width-1:0] hexstr_conv;
    input [(c_width*8)-1:0] def_data;

    integer index,i,j;
    reg [3:0] bin;   

  begin
    index = 0; 
    hexstr_conv = 'b0; 
    for( i=c_width-1; i>=0; i=i-1 )
    begin
      case (def_data[7:0])
        8'b00000000 :  
      begin
        bin = 4'b0000;
        i = -1;
      end
      8'b00110000 : bin = 4'b0000;
      8'b00110001 : bin = 4'b0001;
      8'b00110010 : bin = 4'b0010;
      8'b00110011 : bin = 4'b0011;
      8'b00110100 : bin = 4'b0100;
      8'b00110101 : bin = 4'b0101;
      8'b00110110 : bin = 4'b0110;
      8'b00110111 : bin = 4'b0111;
      8'b00111000 : bin = 4'b1000;
      8'b00111001 : bin = 4'b1001;
      8'b01000001 : bin = 4'b1010;
      8'b01000010 : bin = 4'b1011;
      8'b01000011 : bin = 4'b1100;
      8'b01000100 : bin = 4'b1101;
      8'b01000101 : bin = 4'b1110;
      8'b01000110 : bin = 4'b1111;
      8'b01100001 : bin = 4'b1010;
      8'b01100010 : bin = 4'b1011;
      8'b01100011 : bin = 4'b1100;
      8'b01100100 : bin = 4'b1101;
      8'b01100101 : bin = 4'b1110;
      8'b01100110 : bin = 4'b1111;
      default :
        begin
          $display("ERROR in %m at time %t : NOT A HEX CHARACTER",$time);
          bin = 4'bx;
        end
      endcase
      for( j=0; j<4; j=j+1)
      begin
        if ((index*4)+j < c_width)
        begin
          hexstr_conv[(index*4)+j] = bin[j];
        end 
      end
      index = index + 1;
      def_data = def_data >> 8;
    end
  end
  endfunction


//  Initialize memory contents to default_data for now . In future, read from .mif file and initialize the content properly

  initial begin
    sinit_value  = 'b0 ;
    default_data = hexstr_conv(c_default_data);
    if (c_has_sinit == 1 )
      sinit_value = hexstr_conv(c_sinit_value);
    for(i = 0; i < c_depth; i = i + 1)
      ram_temp[i] = default_data;
    if (c_has_default_data == 0)
      $readmemh(c_mem_init_file, ram_temp);				 //changed from readmemb to readmemh -ben
	 $display("should be equal to address 0 = %d, %d, %d, %d", ram_temp[0], c_width, c_depth, c_has_default_data);
    for(i = 0; i < c_depth; i = i + 1)
      for(j = 0; j < c_width; j = j + 1)
      begin
        bitval = (1'b1 << j);
        mem[(i*c_width) + j] = (ram_temp[i] & bitval) >> j;
      end
      for (k = 0; k <= c_pipe_stages; k = k + 1)
        pipeline[k] = sinit_value ;
      for (m = 0; m <= c_pipe_stages; m = m + 1)
        sub_rdy[m] = 0 ;
      pipe_out = sinit_value ;
      dout_int = sinit_value ;
      nd_q = 0 ;
      new_data_q = 0 ;
      di_q = 0 ;
      addr_q = 0 ;
      we_q = 0 ;
    end


	 //added by Ben			Must edit if c_width is NOT equal to 32
	 assign	DOUT2[0] = mem[addr_int*c_width+0];
	 assign	DOUT2[1] = mem[addr_int*c_width+1];
	 assign	DOUT2[2] = mem[addr_int*c_width+2];
	 assign	DOUT2[3] = mem[addr_int*c_width+3];
	 assign	DOUT2[4] = mem[addr_int*c_width+4];
	 assign	DOUT2[5] = mem[addr_int*c_width+5];
	 assign	DOUT2[6] = mem[addr_int*c_width+6];
	 assign	DOUT2[7] = mem[addr_int*c_width+7];
	 assign	DOUT2[8] = mem[addr_int*c_width+8];
	 assign	DOUT2[9] = mem[addr_int*c_width+9];
	 assign	DOUT2[10] = mem[addr_int*c_width+10];
	 assign	DOUT2[11] = mem[addr_int*c_width+11];
	 assign	DOUT2[12] = mem[addr_int*c_width+12];
	 assign	DOUT2[13] = mem[addr_int*c_width+13];
	 assign	DOUT2[14] = mem[addr_int*c_width+14];
	 assign	DOUT2[15] = mem[addr_int*c_width+15];
	 assign	DOUT2[16] = mem[addr_int*c_width+16];
	 assign	DOUT2[17] = mem[addr_int*c_width+17];
	 assign	DOUT2[18] = mem[addr_int*c_width+18];
	 assign	DOUT2[19] = mem[addr_int*c_width+19];
	 assign	DOUT2[20] = mem[addr_int*c_width+20];
	 assign	DOUT2[21] = mem[addr_int*c_width+21];
	 assign	DOUT2[22] = mem[addr_int*c_width+22];
	 assign	DOUT2[23] = mem[addr_int*c_width+23];
	 assign	DOUT2[24] = mem[addr_int*c_width+24];
	 assign	DOUT2[25] = mem[addr_int*c_width+25];
	 assign	DOUT2[26] = mem[addr_int*c_width+26];
	 assign	DOUT2[27] = mem[addr_int*c_width+27];
	 assign	DOUT2[28] = mem[addr_int*c_width+28];
	 assign	DOUT2[29] = mem[addr_int*c_width+29];
	 assign	DOUT2[30] = mem[addr_int*c_width+30];
	 assign	DOUT2[31] = mem[addr_int*c_width+31];
	 
//  Generate output control signals RFD and  RDY 
//  Combinational

    always @ ( rfd_int)
    begin
      if (c_has_rfd == 1) 
        RFD = rfd_int ;
      else
        RFD = 1'b0 ;
    end

    always @ (en_int )
    begin
      if (en_int == 1'b1)
        rfd_int = 1'b1 ;
      else
        rfd_int = 1'b0 ;
    end

    always @ (  rdy_int )
    begin
      if ((c_has_rdy == 1) && (c_has_nd == 1) && (c_has_rfd == 1) )
        RDY = rdy_int ;
      else
        RDY = 1'b0 ;
    end

    assign nd_int = en_int && nd_i ; // only pass nd through if en is 1 

// Register hanshaking inputs

    always @(posedge clk_int )
    begin
      if (en_int == 1'b1)
      begin
        if (ssr_int == 1'b1)
          nd_q <= 1'b0 ;
        else
          nd_q   <= nd_int;
        end
      else
        nd_q   <= nd_q ;
    end
// Register data / address / data inputs

  always @(posedge clk_int )
  begin
    if (en_int == 1'b1)
      begin
        di_q  <= di_i ;
        addr_q <= addr_i ;
        we_q <= we_i ;
      end
  end

// Register en input 

// always @(posedge clk_int )
// begin
//      en_q <= en_i ;
// end

// Select registered or non-registered en signal

// always @( en_i or en_q)
// begin
//    if (c_reg_en == 1)
//       en_int = en_q ;
//    else
//       en_int = en_i ;
// end

// select registered or non-registered write enable

  always @( we_i or we_q)
  begin
    if (c_reg_inputs == 1 )
      we_int = we_q ;
     else
      we_int = we_i ;
  end

// select registered data/address/nd inputs

  always @( di_i or di_q)
  begin
    if ( c_reg_inputs == 1)
      di_int = di_q ;
    else
      di_int = di_i ;
  end

  always @( addr_i or addr_q or nd_q or nd_int )
  begin
    if (c_reg_inputs == 1)
      begin
        addr_int = addr_q;
        new_data = nd_q ;
      end
    else
      begin
        addr_int = addr_i ;
        new_data = nd_int ;
      end
  end

// Register the new_data signal to track the synchronous RAM output

  always @(posedge clk_int)
  begin
    if ( en_int == 1'b1 )
      begin
       if (ssr_int == 1'b1)
          new_data_q <= 0 ;
       else
          new_data_q <= new_data ;
      end
  end

//  Ininitialize A and B outputs for INIT_A and INIT_B when GSR asserted .
 
//    always @(GSR)
//        if (GSR) begin
//            assign dout_int = INIT[c_width-1:0];
//        end
//        else begin
//            deassign dout_int;
//        end

   initial begin
     case (c_write_mode)
       `c_write_first : wr_mode <= 2'b00;
       `c_read_first  : wr_mode <= 2'b01;
       `c_no_change   : wr_mode <= 2'b10;
       default        : begin
	 $display("Error in %m at time %t: c_write_mode = %s is not WRITE_FIRST, READ_FIRST or NO_CHANGE.",$time , c_write_mode);
	 $finish;
       end
     endcase
   end


    /***************************************************************
    *The following always block assigns the value for the DOUT bus
    ***************************************************************/   
   always @(posedge clk_int) begin
     if (en_int == 1'b1) begin
       if (ssr_int == 1'b1) begin
         for ( ai = 0; ai < c_width; ai = ai + 1)
           dout_int[ai] <= sinit_value[ai];
       end
       else begin
	 //The following IF block assigns the output for a write operation
         if (we_int == 1'b1) begin
           if (wr_mode == 2'b00) begin
             if (addr_int < c_depth) 
               for (aj = 0; aj < c_width; aj = aj + 1)
                 dout_int[aj] <= di_int[aj];
             else
	       //Warning Condition (Error occurs on rising edge of CLK): 
	       //Write Mode Port is "Write First" and EN = 1 and SINIT = 0 and WE = 1 and ADDR out of the valid range
	       $display("Invalid Address Warning #1: Warning in %m at time %t: Block memory address %d (%b) invalid. Valid depth configured as 0 to %d",$time,addr_int,addr_int,c_depth-1);    
           end
           else if (wr_mode == 2'b01) begin
             if (addr_int < c_depth) 
               for (ak = 0; ak < c_width; ak = ak + 1 )
                 dout_int[ak] <= mem[(addr_int*c_width) + ak];
             else
	       //Warning Condition (Error occurs on rising edge of CLK): 
	       //Write Mode Port is "Read First" and EN = 1 and SINIT = 0 and WE = 1 and ADDR out of the valid range
	      $display("Invalid Address Warning #2: Warning in %m at time %t: Block memory address %d (%b) invalid. Valid depth configured as 0 to %d",$time,addr_int,addr_int,c_depth-1);
           end
           else begin
             if (addr_int < c_depth) 
               dout_int <= dout_int ;
             else
	      //Warning Condition (Error occurs on rising edge of CLK): 
	       //Write Mode Port is "No Change" and EN = 1 and SINIT = 0 and WE = 1 and ADDR out of the valid range
	      $display("Invalid Address Warning #3: Warning in %m at time %t: Block memory address %d (%b) invalid. Valid depth configured as 0 to %d",$time,addr_int,addr_int,c_depth-1);
           end
	 end
	 //The following ELSE block assigns the output for a read operation
	 else begin
           if (addr_int < c_depth) 
             for ( al = 0; al < c_width; al = al + 1)
               dout_int[al] <= mem[(addr_int*c_width) + al];
           else
             //Warning Condition (Error occurs on rising edge of CLK): 
	     //EN = 1 and SINIT = 0 and WE = 0 and ADDRA out of the valid range 
	    $display("Invalid Address Warning #4: Warning in %m at time %t: Block memory address %d (%b) invalid. Valid depth configured as 0 to %d",$time,addr_int,addr_int,c_depth-1);
	 end
       end
     end
   end


// Write to memory contents
    /***************************************************************************************
    *The following always block assigns the DIN bus to the memory during a write operation
    ***************************************************************************************/ 
   always @(posedge clk_int) begin
     if (en_int == 1'b1 && we_int == 1'b1) begin
       if (addr_int < c_depth) 
         for (am = 0; am < c_width; am = am + 1 )
           mem [(addr_int*c_width) + am] <= di_int[am] ;
       else
	 //Warning Condition (Error occurs on rising edge of CLK): 
	 //EN = 1 and WE = 1 and ADDR out of the valid range
	$display("Invalid Address Warning #5: Warning in %m at time %t: Block memory address %d (%b) invalid. Valid depth configured as 0 to %d",$time,addr_int,addr_int,c_depth-1);
     end
   end

//  output pipelines 
 
   always @(posedge clk_int) begin
      if (en_int == 1'b1 && c_pipe_stages > 0)
	begin
           for (i = c_pipe_stages; i >= 1; i = i -1 )
             begin
		if (ssr_int == 1'b1 && en_int == 1'b1)
		  begin
		     pipeline[i] <= sinit_value ;
		     sub_rdy[i] <=  0 ;
		  end
		else
		  begin
		     if (i==1)
		       begin
			  pipeline[1] <= dout_int;
			  sub_rdy[1]  <= new_data_q;
		       end
		     else
		       begin
			  pipeline[i] <= pipeline[i-1] ;
			  sub_rdy[i]  <= sub_rdy[i-1] ;
		       end
		  end
             end
	end
   end

// Select pipelined data output or no-pipelined data output
 
   always @( pipeline[c_pipe_stages] or dout_int or new_data_q or sub_rdy[c_pipe_stages]) begin
     if (c_pipe_stages == 0 )
     begin
       pipe_out = dout_int ;
       rdy_int = new_data_q ;
     end
     else
     begin
       pipe_out = pipeline[c_pipe_stages];
       rdy_int = sub_rdy[c_pipe_stages];
     end
   end


 //   specify
// (CLK *> DOUT) = (1, 1);
//   endspecify

endmodule

`endcelldefine
