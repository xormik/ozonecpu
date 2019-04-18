/////////////////////////////////////////////////////////////////////////
//FPGA_top.v
// Top level interface from a Xilinx V2000-E FG680 FPGA
// to U.C. Berkeley CalLinx board.
// from EECS150 w/ modifications by Jack Kang Fall 2003
// FOR USE IN CS152 FALL 2003 ONLY
/////////////////////////////////////////////////////////////////////////


// *** Change the following two lines depending on the lab you are in ***
// *** CS152 lab should use the first line.
// *** CS150 lab should use the second line.
`include "C:\synplicity\Synplify_71\lib\xilinx\virtexe.v"
//`include "C:\Program Files\synplicity\Synplify_731\lib\xilinx\virtexe.v"
//this include file will instantiate all the black boxes necessary for synplify

module TopLevel (
		 /////////////////////////////////////////////////////////
		 //RJ45 LEDs, bank 2 left-top
		 RJ45_TRC, //2 bits
		 RJ45_BRC, //2 bits
		 RJ45_TLC, //2 bits
		 RJ45_BLC, //2 bits
		 /////////////////////////////////////////////////////////
		 //ethernet phy layer, bank 0,1 top
		 PHY_LEDCLK,
		 PHY_LEDDAT,
		 PHY_LEDENA,
		 PHY_ADD_, //3 bits
		 PHY_MDIO,
		 PHY_MDINT,
		 PHY_MDC,
		 PHY_MDDIS,
		 PHY_PWRDN,
		 PHY_RESET,
		 PHY_FDE,
		 PHY_AUTOENA,
		 PHY_BYPSCR,
		 PHY_CFG_, //3 bits
		 PHY_LED0_, //3 bits
		 PHY_LED1_, //3 bits
		 PHY_LED2_, //3 bits
		 PHY_LED3_, //3 bits
		 PHY_RXD0_, //4 bits
		 PHY_RXD1_, //4 bits
		 PHY_RXD2_, //4 bits
		 PHY_RXD3_, //4 bits
		 PHY_RX_DV_, //4 bits,A
   		 PHY_RX_CLK_, //4 bits
		 PHY_RX_ER_, //4 bits
		 PHY_TX_ER_, //4 bits
   		 PHY_TX_CLK_, //4 bits,A,A
		 PHY_TX_EN_, //4 bits
		 PHY_TXD0_, //4 bits
		 PHY_TXD1_, //4 bits
		 PHY_TXD2_, //4 bits,A
		 PHY_TXD3_, //4 bits
   		 PHY_COL_, //4 bits
  		 PHY_CRS_, //4 bits
		 PHY_TRSTE_, //4 bits
		 ///////////////////////////////////////////////////
		 //Audio Codec, Bank 1 top-left
		 AP_SDATA_OUT,
		 AP_BIT_CLOCK,
		 AP_SDATA_IN,
		 AP_SYNC,
		 AP_RESET_B,
		 AP_PC_BEEP,
		 //Audio amp mute.
		 AA_MUTE,
		 ///////////////////////////////////////////////////
		 //SDRAM, bank 7 right-top
		 RAM_DQ,  //32 bits
		 RAM_CLK,
		 RAM_CLKE,
		 RAM_DQMH,
		 RAM_DQML,
		 RAM_CS,
		 RAM_RAS,
		 RAM_CAS,
		 RAM_WE,
		 RAM_BA, //2 bits
		 RAM_A, //12 bits
		 ///////////////////////////////////////////////////
		 //buttons and dipswitches, bank 7,6 right
		 SW9_, //8 bits
		 SW10_, // 8 bits
		 SW, // 8 bits
		 ///////////////////////////////////////////////////
		 //SYSTEM ACE CHIP, bank 2 top-left
		 ACE_MPBRDY,
		 ACE_MPIRQ,
		 ACE_MPCE_B,
		 ACE_MPWE_B,
		 ACE_MPOE_B,
		 ACE_MPA, //7 bits
		 ACE_MPD, //16 bits
		 ///////////////////////////////////////////////////
		 //Video Encoder, bank 3 left-bottom 
		 VE_P, //10 bits
		 VE_SCLK,
		 VE_SDA,
		 VE_PAL_NTSC,
		 VE_RESET_B,
		 VE_HSYNC_B,
		 VE_VSYNC_B,
		 VE_BLANK_B,
		 VE_SCRESET,
		 VE_CLOCK,
		 VE_CLKIN_,
		 ///////////////////////////////////////////////////
		 //Video Decoder, bank 3 left bottom
		 VD_CLOCK,
		 VD_CHAN1_LLC, //2 bits
		 VD_CHAN1_DATA, //10 bits
		 VD_CHAN1_I2C_CLOCK,
		 VD_CHAN1_I2C_DATA,
		 VD_CHAN1_ISO,
		 VD_RESET_B,
		 ///////////////////////////////////////////////////
		 LED, //8 bits
		 ///////////////////////////////////////////////////
		 //7 segment LEDs x8, bank 4,5 bottom
		 SEG1_, //8 bits,
		 SEG2_, //8 bits,
		 SEG3_, //8 bits,
		 SEG4_, //8 bits,
		 SEG5_, //8 bits,
		 SEG6_, //8 bits,
		 SEG7_, //8 bits,
		 SEG8_, //8 bits,
		 SEG_PT_,
		 SEG_COM_, //8 bits
		 ///////////////////////////////////////////////////
		 // Pinouts around FPGA
		 PINOUT_TOP_CLOSE,
		 PINOUT_TOP_FAR,
		 PINOUT_LEFT_CLOSE,
		 PINOUT_LEFT_FAR,
		 PINOUT_BOTTOM_CLOSE,
		 PINOUT_BOTTOM_FAR,
		 PINOUT_RIGHT_CLOSE,
		 PINOUT_RIGHT_FAR);  
  
   ///////////////////////////////////////////////////
   //RJ45 Connector LEDs
   output [2:1]  RJ45_TRC /*synthesis xc_loc = "E1,D3"*/;
   output [2:1]  RJ45_BRC /*synthesis xc_loc = "F1,E2"*/;
   output [2:1]  RJ45_TLC /*synthesis xc_loc = "F3,F2"*/;
   output [2:1]  RJ45_BLC /*synthesis xc_loc = "G1,F4"*/;
   ///////////////////////////////////////////////////
   //ethernet phy layer common connections
   input 	 PHY_LEDCLK /*synthesis  xc_loc = "D14"*/; 
   input 	 PHY_LEDDAT /*synthesis  xc_loc = "A15"*/; 
   input 	 PHY_LEDENA /*synthesis  xc_loc = "B15"*/; 
   output [4:2]  PHY_ADD_ /*synthesis  xc_loc = "A16,D15,C15"*/; 
   //inout 	PHY_MDIO;
   input 	 PHY_MDIO /*synthesis  xc_loc = "B32"*/; 
   input 	 PHY_MDINT /*synthesis  xc_loc = "A32"*/; 
   output 	 PHY_MDC /*synthesis  xc_loc = "D33"*/; 
   output 	 PHY_MDDIS /*synthesis  xc_loc = "C33"*/; 
   output 	 PHY_PWRDN /*synthesis  xc_loc = "B33"*/; 
   output 	 PHY_RESET /*synthesis  xc_loc = "A34"*/; 
   output 	 PHY_FDE /*synthesis  xc_loc = "D35"*/; 
   output 	 PHY_AUTOENA /*synthesis  xc_loc = "C35"*/; 
   output 	 PHY_BYPSCR /*synthesis  xc_loc = "B35"*/; 
   output [2:0]  PHY_CFG_ /*synthesis  xc_loc = "A35,B36,A36"*/; 
   input [2:0] 	 PHY_LED0_ /* synthesis xc_pullup = 1 xc_loc = "C14,B14,A14"*/; 
   input [2:0] 	 PHY_LED1_ /* synthesis xc_pullup = 1 xc_loc = "D13,C13,B13"*/; 
   input [2:0] 	 PHY_LED2_ /* synthesis xc_pullup = 1 xc_loc = "A13,C12,B12"*/;  
   input [2:0] 	 PHY_LED3_ /* synthesis xc_pullup = 1 xc_loc = "A12,D11,C11"*/; 
   input [3:0] 	 PHY_RXD0_ /*synthesis  xc_loc = "B16,C16,D16,A17"*/; 
   input [3:0] 	 PHY_RXD1_ /*synthesis  xc_loc = "D19,C21,B20,B21"*/; 
   input [3:0] 	 PHY_RXD2_ /*synthesis  xc_loc = "C24,B24,A24,D25"*/; 
   input [3:0] 	 PHY_RXD3_ /*synthesis  xc_loc = "B28,A28,D29,C29"*/; 
   input [3:0] 	 PHY_RX_DV_ /*synthesis  xc_loc = "B29,C25,A21,B17"*/;
   input [3:0] 	 PHY_RX_CLK_/* synthesis syn_noclockbuf = 1 xc_loc = "A29,B25,E22,C17"*/;
   input [3:0] 	 PHY_RX_ER_ /*synthesis  xc_loc = "D30,A25,D22,D17"*/;
   output [3:0]  PHY_TX_ER_ /*synthesis  xc_loc = "C30,D26,C22,E17"*/;
   input [3:0] 	 PHY_TX_CLK_ /* synthesis syn_noclockbuf = 1 xc_loc = "B30,C26,B22,A18"*/;
   output [3:0]  PHY_TX_EN_ /*synthesis  xc_loc = "A30,B26,A22,B18"*/;
   output [3:0]  PHY_TXD0_ /*synthesis  xc_loc = "A19,E18,D18,C18"*/;
   output [3:0]  PHY_TXD1_ /*synthesis  xc_loc = "B23,C23,D23,E23"*/;
   output [3:0]  PHY_TXD2_ /*synthesis  xc_loc = "A26,D27,C27,B27"*/;
   output [3:0]  PHY_TXD3_ /*synthesis  xc_loc = "A31,B31,C31,D31"*/;
   input [3:0] 	 PHY_COL_ /*synthesis  xc_loc = "D32,A27,A23,B19"*/;
   input [3:0] 	 PHY_CRS_ /*synthesis  xc_loc = "C32,C28,D24,C19"*/;
   output [3:0]  PHY_TRSTE_ /*synthesis  xc_loc = "A33,D34,C34,B34"*/;
   ///////////////////////////////////////////////////
   //Audio Codec
   input 	 AP_SDATA_OUT /*synthesis xc_loc = "A4"*/;
   input 	 AP_BIT_CLOCK /*synthesis xc_loc = "A5"*/;
   output 	 AP_SDATA_IN /*synthesis xc_loc = "B5"*/;
   output 	 AP_SYNC /*synthesis xc_loc = "C5"*/;
   output 	 AP_RESET_B /*synthesis xc_loc = "A6"*/;
   output 	 AP_PC_BEEP /*synthesis xc_loc = "B6"*/;
   // Audio Amp Mute
   output 	 AA_MUTE /*synthesis xc_loc = "D1"*/;
   ///////////////////////////////////////////////////
   //SDRAM
   inout [31:0]  RAM_DQ /*synthesis  xc_loc = "L36,L37,L38,L39,K36,K37,K38,K39,J36,J37,J38,J39,H36,H37,H38,H39,G36,G37,G38,G39,F36,F37,F38,F39,E37,E38,E39,D37,D38,D39,C38,B37"*/;
   output 	 RAM_CLK /*synthesis xc_loc = "M39"*/;
   output 	 RAM_CLKE /*synthesis xc_loc = "M38"*/;
   output 	 RAM_DQMH /*synthesis xc_loc = "M37"*/;
   output 	 RAM_DQML /*synthesis xc_loc = "N39"*/;
   output 	 RAM_CS /*synthesis xc_loc = "N38"*/;
   output 	 RAM_RAS /*synthesis xc_loc = "N37"*/;
   output 	 RAM_CAS /*synthesis xc_loc = "N36"*/;
   output 	 RAM_WE /*synthesis xc_loc = "P39"*/;
   output [1:0]  RAM_BA /*synthesis xc_loc = "P38,P37"*/;
   output [11:0] RAM_A /*synthesis xc_loc = "U37,U38,U39,T36,T37,T38,T39,R36,R37,R38,R39,P36"*/;
   ///////////////////////////////////////////////////
   input [8:1] 	 SW9_ /*synthesis xc_loc = "AD36,AC39,AC38,AC37,AC36,AC35,AB39,AB38"*/;
   input [8:1] 	 SW10_ /*synthesis xc_loc = "AF36,AE39,AE38,AE37,AE36,AD39,AD38,AD37"*/;
   input [8:1]	 SW /*synthesis xc_loc = "AB37,AB36,AB35,AA39,AA38,AA36,Y39,Y38"*/;
   ///////////////////////////////////////////////////
   //SYSTEM ACE CHIP
   input 	 ACE_MPBRDY /*synthesis xc_loc = "M2"*/;
   output 	 ACE_MPIRQ /*synthesis xc_loc = "M3"*/;
   output 	 ACE_MPCE_B /*synthesis xc_loc = "N1"*/;
   output 	 ACE_MPWE_B /*synthesis xc_loc = "N2"*/;
   output 	 ACE_MPOE_B /*synthesis xc_loc = "N3"*/;
   output [6:0]  ACE_MPA /*synthesis xc_loc = "T1,R4,R3,R2,P2,P1,N4"*/;
   inout [15:0]  ACE_MPD /*synthesis xc_loc = "W4,W3,W2,V5,V4,V3,V2,V1,U5,U4,U3,U2,U1,T4,T3,T2"*/; 
   ///////////////////////////////////////////////////
   //Video Encoder
   output [9:0]  VE_P /*synthesis xc_loc = "AM3,AM4,AL1,AL2,AL3,AL4,AK1,AK2,AK3,AK4"*/;
   input 	 VE_SCLK /*synthesis xc_loc = "AM2"*/;
   output 	 VE_SDA /*synthesis xc_loc = "AM1"*/;
   input 	 VE_PAL_NTSC /*synthesis xc_loc = "AN4"*/;
   output 	 VE_RESET_B /*synthesis xc_loc = "AN3"*/;
   input 	 VE_HSYNC_B /*synthesis xc_loc = "AN2"*/;
   input 	 VE_VSYNC_B /*synthesis xc_loc = "AN1"*/;
   input 	 VE_BLANK_B /*synthesis xc_loc = "AP4"*/;
   output 	 VE_SCRESET /*synthesis xc_loc = "AP3"*/;
   input 	 VE_CLOCK /*synthesis xc_loc = "A20"*/; // should be (GCLK3),A20
	output		VE_CLKIN_	/*synthesis xc_loc = "AP2"*/;
   ///////////////////////////////////////////////////
   //Video Decoder
   input 	 VD_CLOCK ;
   input [2:1] 	 VD_CHAN1_LLC;
   input [9:0] 	 VD_CHAN1_DATA;
   input 	 VD_CHAN1_I2C_CLOCK;
   input 	 VD_CHAN1_I2C_DATA;
   input 	 VD_CHAN1_ISO /*synthesis xc_loc = "AC2"*/;
   output 	 VD_RESET_B /*synthesis xc_loc = "AC1"*/;
   ///////////////////////////////////////////////////
   output [8:1]  LED /*synthesis xc_loc = "W38,V35,V36,V37,V38,V39,U35,U36"*/;
   ///////////////////////////////////////////////////
   //7 segment LEDs x8
   output [6:0]  SEG1_ /*synthesis xc_loc = "AV8,AW8,AU8,AT8,AV9,AU9,AT9"*/;
   output [6:0]  SEG2_ /*synthesis xc_loc = "AU10,AV10,AT10,AW11,AU11,AT11,AW12"*/;
   output [6:0]  SEG3_ /*synthesis xc_loc = "AT18,AR18,AU18,AV18,AR17,AT17,AU17"*/; 
   output [6:0]  SEG4_ /*synthesis xc_loc = "AU21,AT19,AT21,AV20,AV21,AW21,AR22"*/;
   output [6:0]  SEG5_ /*synthesis xc_loc = "AW28,AT29,AV28,AU28,AV27,AU27,AT27"*/;
   output [6:0]  SEG6_ /*synthesis xc_loc = "AT31,AU31,AW30,AV30,AT30,AW29,AV29"*/;
   output [6:0]  SEG7_ /*synthesis xc_loc = "AU33,AV33,AT33,AW32,AU32,AT32,AW31"*/;
   output [6:0]  SEG8_ /*synthesis xc_loc = "AU36,AV36,AW35,AV35,AV34,AU34,AT34"*/; 
   output [8:1]  SEG_PT_ /*synthesis xc_loc = "AW34,AV32,AU30,AW27,AW20,AW18,AV11,AW9"*/;
   output [8:1]  SEG_COM_ /*synthesis xc_loc = "AW36,AW33,AV31,AU29,AU19,AV19,AW10,AT7"*/;
   
   ///////////////////////////////////////////////////
   output [19:0]  PINOUT_TOP_CLOSE /*synthesis xc_loc = "C6,D6,A7,B7,C7,D7,A8,B8,C8,D8,A9,B9,C9,D9,A10,B10,C10,D10,A11,B11" */;
   output [19:0]  PINOUT_TOP_FAR /*synthesis xc_loc = "M1,L4,L3,L2,L1,K4,K3,K2,K1,J4,J3,J2,J1,H4,H3,H2,H1,G4,G3,G2"*/;
   output [19:0]  PINOUT_LEFT_CLOSE /*synthesis xc_loc = "AP1,AR3,AR2,AR1,AT3,AT2,AT1,AV3,AW4,AV4,AU4,AW5,AV5,AW6,AV6,AU6,AT6,AW7,AV7,AU7"*/;
   output [19:0]  PINOUT_LEFT_FAR /*synthesis xc_loc = "AD4,AD2,AD1,AE4,AE3,AE2,AE1,AF4,AF3,AF2,AF1,AG4,AG3,AG1,AH3,AH2,AJ4,AJ3,AJ2,AJ1"*/;
   output [19:0]  PINOUT_BOTTOM_CLOSE /*synthesis xc_loc = "AT22,AV22,AW22,AR23,AT23,AU23,AV23,AW23,AT24,AU24,AV24,AW24,AT25,AU25,AV25,AW25,AT26,AU26,AV26,AW26"*/;
   output [19:0]  PINOUT_BOTTOM_FAR /*synthesis xc_loc = "AV12,AU12,AW13,AV13,AU13,AT13,AW14,AV14,AU14,AT14,AW15,AV15,AU15,AT15,AW16,AV16,AU16,AT16,AW17,AV17"*/;
   output [19:0]  PINOUT_RIGHT_CLOSE /*synthesis xc_loc = "AL38,AL39,AM36,AM37,AM38,AM39,AN36,AN37,AN38,AN39,AP36,AP37,AP38,AP39,AR36,AR37,AR38,AR39,AT38,AT39"*/;
   output [19:0]  PINOUT_RIGHT_FAR /*synthesis xc_loc = "AF37,AF38,AF39,AG36,AG37,AG38,AG39,AH37,AH38,AH39,AJ36,AJ37,AJ38,AJ39,AK36,AK37,AK38,AK39,AL36,AL37"*/;

//****************************************************************//
//        WARNING!! DO NOT CHANGE ANYTHING ABOVE THIS LINE        //
//****************************************************************//

   //////////////////////////////////////////////////////////////////////////
   //PINOUTS: two banks of user defined pinouts on each side of the FPGA
   //hint: when debugging use these to pinout signals in your design
   //      and watch them on the digital analyzer
   //      each bank of pinouts are 20 bits wide [19:0]
   //
   //CS152 note: We will not be using logic analyzers in this class.
   //
   // assign PINOUT_TOP_CLOSE[15:0] = debug[15:0];
   // assign PINOUT_TOP_FAR[0] = PHY_RX_CLK_[0];
   //assign PINOUT_LEFT_CLOSE = ?;
   //assign PINOUT_LEFT_FAR = ?;
   //assign PINOUT_BOTTOM_CLOSE = ?;
   //assign PINOUT_BOTTOM_FAR = ?;
   //assign PINOUT_RIGHT_CLOSE = ?;
   //assign PINOUT_RIGHT_FAR[7:0] = ?;

   
   //////////////////////////////////////////////////////////////////////////
   //User IO Definitions:
   //////////////////////////////////////////////////////////////////////////

   //You can instantiate any wires you may need to connect this top level module to your
   //processor module.

   wire clk;
	wire rst;
	wire io_sel;
	wire rls, rls_single_step;
	wire single_clk;
 	wire processor_clk;
	wire clk_source;

   wire [8:1] leds;
   wire [3:0] segIn1, segIn2, segIn3, segIn4, segIn5, segIn6, segIn7, segIn8;
   wire [7:0] segpts;
   wire [6:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
   wire [31:0] sdram_dataio;
   wire [11:0] sdram_addr;
   wire sdram_we;
   wire sdram_clk;
   wire sdram_clke;
   wire sdram_dqmh;
   wire sdram_dqml;
   wire sdram_cs;
   wire sdram_ras;
   wire sdram_cas;
	wire [1:0] sdram_ba;

	wire [31:0] curr_addr, curr_instr, curr_addr_instr;
	wire [31:0] io_output;


  /*
      Switches with Debouncers
		SW6 - Reset
		SW7 - I/O select (DP0 or DP1)
		SW8 - Release (from break)
		SW4 - Single Clock
   */

	our_debouncer db1(.I(~SW[6]), .O(rst), .C(clk));
   // debouncer db2(.I(~SW[7]), .O(io_sel), .C(clk));
	assign io_sel = ~SW[7];
	//our_debouncer db3(.I(~SW[8]), .O(rls), .C(clk));
	debouncer db3(.I(~SW[8]), .O(rls_single_step), .C(clk));
	our_debouncer db3b(.I(~SW[8]), .O(rls), .C(clk));
	//assign rls = ~SW[8];
	our_debouncer db4(.I(~SW[4]), .O(single_clk), .C(clk));


   /*
       Clock Source
	 */
  
   assign clk_source = ~SW10_[1];
   assign processor_clk = clk_source ? clk : single_clk;
   


   //We will be using DLLs for this lab.
   //VE_CLOCK is an incoming clock from the board that runs at 27Mhz.
   //DLL standard just buffers the clock signal using the DLLs
   //For more information on DLLs, see the M:\lab4\DLL_Examples folder
   //Locked is a signal that the DLL asserts when it has locked in the clock frequency and can guarantee
   //that the clock is accurate. We can ignore this if we set STARTUP_WAIT to true in the clkdll module.
   													    	
   dll_standard myDLL(.CLKIN(VE_CLOCK), .RESET(1'b0), .CLK0(sdram_clk), .LOCKED(), .CLK_DIV_OUT(clk));
   // NEED TO ADD PROCESSOR CLOCK

   //////////////////////////////////////////////////////////////////////////
   //LEDs: (D[8:1]) little red ones on the edge of the board
   //LEDs are ACTIVE LOW
   assign LED = ~leds;
   

//You will need to use the bin2HexLED module to convert 4 bit hex values into 
//the proper values for displaying.   

   bin2HexLED uLed1(.IN(segIn1), .SEGLED(seg1));
   bin2HexLED uLed2(.IN(segIn2), .SEGLED(seg2));
   bin2HexLED uLed3(.IN(segIn3), .SEGLED(seg3));
   bin2HexLED uLed4(.IN(segIn4), .SEGLED(seg4));
   bin2HexLED uLed5(.IN(segIn5), .SEGLED(seg5));
   bin2HexLED uLed6(.IN(segIn6), .SEGLED(seg6));
   bin2HexLED uLed7(.IN(segIn7), .SEGLED(seg7));
   bin2HexLED uLed8(.IN(segIn8), .SEGLED(seg8));

   //////////////////////////////////////////////////////////////////////////
   //Segment LEDs:
   //Common pin must be set to ground for Seg LEDs to work (assign SEG_COM_=8'b0)
   //SEG_PT_ is for the decimal points on each HEX Led.
   //SEG LEDs are ACTIVE HIGH
  
   assign SEG_COM_ = 8'b0;
   assign SEG_PT_ = segpts; 


	wire [6:0] seg1_s, seg2_s, seg3_s, seg4_s, seg5_s, seg6_s, seg7_s, seg8_s;

/* Turn off scrolling right now
   scroll scroll0 (
	      //      C     S     1     5     2    "space"       D       R      E     A     M    "space"     T      E      A     M
   		.msg({6'hc, 6'h1c, 6'h1, 6'h5, 6'h2, 6'h3f,      6'hd, 6'h1b,  6'he, 6'ha,  6'h16,  6'h3f   , 6'h1d, 6'he, 6'ha, 6'h16, 24'hffffff}), 
   		.seg1(seg1_s), 
   		.seg2(seg2_s), 
	   	.seg3(seg3_s), 
		   .seg4(seg4_s), 
		   .seg5(seg5_s), 
		   .seg6(seg6_s), 
		   .seg7(seg7_s), 
		   .seg8(seg8_s), 
		   .clk(clk), 
		   .rst(rst));
*/ assign {seg1_s, seg2_s, seg3_s, seg4_s, seg5_s, seg6_s, seg7_s, seg8_s} = 0;

   // Switch 10_[8] selects whether to read output from charled or bin2HexLed
	assign SEG1_ = ~SW10_[8] ? seg1 : seg1_s;
	assign SEG2_ = ~SW10_[8] ? seg2 : seg2_s;
	assign SEG3_ = ~SW10_[8] ? seg3 : seg3_s;
	assign SEG4_ = ~SW10_[8] ? seg4 : seg4_s;
	assign SEG5_ = ~SW10_[8] ? seg5 : seg5_s;
	assign SEG6_ = ~SW10_[8] ? seg6 : seg6_s;
	assign SEG7_ = ~SW10_[8] ? seg7 : seg7_s;
	assign SEG8_ = ~SW10_[8] ? seg8 : seg8_s;

/*
  assign {SEG1_, SEG2_, SEG3_, SEG4_, SEG5_, SEG6_, SEG7_, SEG8_} = ~SW10_[8] ?
         {seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8} : {seg1_s, seg2_s, seg3_s, seg4_s, seg5_s, seg6_s, seg7_s, seg8_s};
*/

  // DEBUGGING: TEST TO SEE IF OUTPUT TO LEDS
//  assign {segIn1, segIn2, segIn3, segIn4, segIn5, segIn6, segIn7, segIn8} = 32'hFADEFADE;

assign curr_addr_instr = (SW[3]) ? curr_addr : curr_instr;
  
  assign {segIn1, segIn2, segIn3, segIn4, segIn5, segIn6, segIn7, segIn8} = ~SW10_[2] ? io_output : curr_addr_instr;


 assign RAM_CS = sdram_cs, 
 	RAM_RAS = sdram_ras,
	RAM_CAS = sdram_cas, 
	RAM_DQ = sdram_dataio,
	RAM_DQMH = sdram_dqmh,
	RAM_DQML = sdram_dqml,
	RAM_A = sdram_addr,
 	RAM_WE = sdram_we,
 	RAM_CLK = sdram_clk,
 	RAM_CLKE = sdram_clke, // changed from sdram_clk by Thomas
	RAM_BA = sdram_ba;
   
   //////////////////////////////////////////////////////////////////////////
   // Instantiate your processor below
   //////////////////////////////////////////////////////////////////////////
assign segpts = 8'b0;
//assign {sdram_cs, sdram_ras, sdram_cas, sdram_dataio, sdram_dqmh, sdram_dqml,
//		sdram_addr, sdram_we, sdram_clk, sdram_clke, sdram_ba} = 54'b0;


// instantiate processor 

processor cpu(
		.DRAMCLK(sdram_clk),
		.CLK(proc_clk),                // clock from delay_proc_rst module
		.mem_ctrl_rst(rst),            // separate from processor; resets only memory controller
		.memio_in(SW9_),
		.memio_outsel(io_sel),
      .rls(clk_source ? rls : rls_single_step),
		.RST(proc_rst),                // reset signal from delay_proc_rst module
		.Ba(sdram_ba),
		.CAS(sdram_cas),
		.CKE(sdram_clke),
		.CS(sdram_cs),
		.DQM({sdram_dqmh, sdram_dqml}),
		.RAS(sdram_ras),
		.WE(sdram_we),
		.addr(sdram_addr),
		.dm_addr(curr_addr),
		.dm_instr(curr_instr),
      .memio_out(io_output),
		.stat_output(leds),
		.mem_BiData(sdram_dataio)
);

// wires between delay_proc_rst and processor
wire proc_rst, proc_clk;

// instantiate delay_proc_rst NEED TO ADD THIS!!!
delay_proc_rst uut(.rst(rst),						// master reset
						 .DRAMCLK(sdram_clk),				// delay_proc_rst runs on dramclk
						 .PROCCLK_IN(processor_clk),                  
						 .PROCCLK_OUT(proc_clk),         // to processor
						 .proc_rst(proc_rst)				// to processor
						);

/* SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE SAMPLE >>
 		//clock inputs to processor
 		.clk(clk),
 		//segment LEDS output from processor. Each is a 4 bit int array
 		.seg1(segIn1), .seg2(segIn2), .seg3(segIn3), .seg4(segIn4),
 		.seg5(segIn5), .seg6(segIn6), .seg7(segIn7), .seg8(segIn8),
 		//segment points LEDS, array of the 8 points
 		.segpts(segpts),
 		//switches 8, 7, 6, and 4 inputs to proc undebounced.
 		.sw8(~SW8), .sw7(~SW7), .sw6(~SW6), .sw4(~SW4),
 		//dipswitches 9 and 10 8-bit input to proc
 		.sw10(switch10), .sw9(switch9),
 		//SIDE LEDS output, array of 8 bits, active low
 		.leds(leds),
 		//RAM address 12 bits
 		.addr(sdram_addr),
 		//RAM datainout 32 bits
 		.dataio(sdram_dataio),
 		//RAM we
 		.we(sdram_we),
		//RAM_CS
		.cs(sdram_cs),
		//RAM_RAS 
		.ras(sdram_ras),
		//RAM_CAS 
		.cas(sdram_cas), 
		//RAM_DQMH
		.dqmh(sdram_dqmh), //high bit of DQM
		//RAM_DQML 
		.dqml(sdram_dqml), //low bit of DQM
		//RAM_CLK 
		.ramclk(sdram_clk),
 		//RAM_CLKE 
		.ramclke(sdram_clke)
 		);
*/

endmodule



