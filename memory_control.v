//////////////////////////////////////////////////////////
// Memory Control for CS152
//
// Interfaces between the processor and the Micron SDRAMs
// on the Calinx Board
//
// Originally Written by Jack Kang and Roger Hong Fall 2002
// Modified by Jack Kang 4/03 and 10/03
//
// You may modify and do anything you wish with this module.
// This is only provided for your convenience. You are not 
// required to use this module in any way shape or form if 
// you do not wish to.
//////////////////////////////////////////////////////////


//A Message has dissappeared

`timescale 1ns/1ps

module memory_control(RESET, PROCCLK, request, r_w, address, data_in, data_out, waitForMem, DRAMCLK, Data,
	              Addr, Ba, CKE, CS, RAS, CAS, WE, DQM, burstReadDone_reg, readBuffer_WE);

  //Processor Interface		    
  input RESET;			//System reset
  input PROCCLK; 		//Processor clock
  input request;		//Set to 1 on when processor making request			  
  input r_w;			//Set to 1 when processor is writing
  input [22:0]address;	//23 bits = 8 megabytes of *words*
  input [31:0]data_in;	//input data
  output [31:0]data_out;	//output data
  output waitForMem; 	//Tells the processor to wait for the next value
	  
  //DRAM Interface
  input DRAMCLK;
  inout [31:0]Data;
  output [11:0]Addr;
  output [1:0]Ba;
  output CKE, CS, RAS, CAS, WE;
  output [1:0]DQM;
  output burstReadDone_reg;
  output readBuffer_WE;

  //Port Declarations
  reg [31:0] data_out;
  reg waitForMem;
  reg [11:0]Addr;
  reg [1:0]Ba;
  reg CS, RAS, CAS, WE;
  reg [1:0] DQM;

  //FSM and Counter Registers
  reg [3:0] CurState, NextState;

  assign CKE = 1; //always high since we do not use SELF REFRESH

  wire [22:0]address_out;
  wire [31:0]data_in_dout;
  wire r_w_dout;

  //reg burstReadDone; 	
  reg burstReadDone;
  wire burstReadDone_reg;
  wire waitForMem_reg;
  reg readBuffer_WE;

  //Parameters for FSM
  parameter init = 4'b000, write = 4'b001, read= 4'b010, idle = 4'b011, refresh = 4'b100, 
  		  refresh_wait = 4'b101, waitForProc = 4'b110, waitForReq = 4'b111,
		  cacheWrite = 4'b1000,  // state which waits for processor to write cache line
		  postWrite = 4'b1001,   // state which makes sure processor gets waitForMem signal
                  refresh_cacheWrite = 4'b1010,
                  refresh_postWrite = 4'b1011;

  //**************************COUNTERS and wires for COUNTERS******************************/
  wire [11:0] fsmcounter_out;
  wire fsmcounter_enable;
  assign fsmcounter_enable = (CurState == init);

  wire [2:0]eight_counter_out;
  wire eight_counter_enable;
  // MODIFIED BY CHAK/RICHARD
  //assign eight_counter_enable = (CurState == write || CurState == read);
  assign eight_counter_enable = (CurState == write);


  wire [1:0]three_counter_out;
  wire three_counter_enable, three_counter_reset;
  assign three_counter_enable = (CurState == refresh) || (CurState == refresh_wait);
  assign three_counter_reset = RESET || (three_counter_out == 2);

  // ADDED BY CHAK/RICHARD
  wire [3:0] thirteen_counter_out;
  wire thirteen_counter_enable, thirteen_counter_reset;
  assign thirteen_counter_enable = (CurState == read);
  assign thirteen_counter_reset = RESET || (thirteen_counter_out == 12);

  // Refresh counter enable is asserted when refresh_decrementer_out
  // is 0 (a refresh was missed) to increment the count.
  // Refresh counter enable is asserted when three_counter_out is 2
  // (a refresh has just been completed, since three_counter used only
  // by the refresh state) to decrement the count.
  wire [11:0]refresh_counter_out;
  wire refresh_counter_enable, refresh_counter_inc;
  wire [9:0]refresh_decrementer_out;
  wire refresh_decrementer_enable, refresh_decrementer_inc;

  assign refresh_counter_enable = ((refresh_decrementer_out == 0) ^ (three_counter_out == 2));
  assign refresh_counter_inc = ((refresh_decrementer_out == 0) &&  (three_counter_out != 2));
  assign refresh_decrementer_enable = 1;
  assign refresh_decrementer_inc = 0;

  // Tristate buffer wire declarations
  wire [31:0]ts_data;
  wire [31:0]Data;

  wire clockFlag;
  wire upedge_reset;
  assign upedge_reset = (CurState != waitForProc) & (CurState != refresh_wait);

	counter #(12) fsmcounter(.OUT(fsmcounter_out), 
			 			.CLK(DRAMCLK), 
				   		.ENABLE(fsmcounter_enable),
			   			.RESET(RESET));

	counter #(3) eight_counter(.OUT(eight_counter_out), 
			     		  .CLK(DRAMCLK), 
						  .ENABLE(eight_counter_enable),
			    	 		  .RESET(RESET)); //always automatically resets at end of 8th cycle (becomes 0 again)
	 							  					     

 	counter #(2) three_counter(.OUT(three_counter_out),
						  .CLK(DRAMCLK),
			     		  .ENABLE(three_counter_enable),
			     		  .RESET(three_counter_reset));

	// ADDED BY CHAK/RICHARD
	counter #(4) thirteen_counter(.OUT(thirteen_counter_out),
						     .CLK(DRAMCLK),
			     		     .ENABLE(thirteen_counter_enable),
			     		     .RESET(thirteen_counter_reset));

  // Counts the number of missed refreshes
	updown_counter #(0, 12) refresh_counter(.OUT(refresh_counter_out),
				       				.CLK(DRAMCLK),
				       				.ENABLE(refresh_counter_enable),
				       				.RESET(RESET),
				       				.INC(refresh_counter_inc));

  // Counts down the average number of cycles between refreshes.
	updown_counter #(390, 10) refresh_decrementer(.OUT(refresh_decrementer_out),
					    					 .CLK(DRAMCLK),
					   					 .ENABLE(refresh_decrementer_enable),
					     				 .RESET(RESET),
						  				 .INC(refresh_decrementer_inc));


  //Instantiate a tristate buffer for the bi-directional data bus
  //puts high impedance on the data bus during reads (r_w is low)
  //You guys should of wrote this in lab 3
  	bts32 ts(.DIN(data_in_dout),
       	    .ENABLE(r_w_dout),  // changed by Thomas 10/25
	         .DOUT(Data));

	upedge_detector myUpedger (.I(PROCCLK),
						  .C(DRAMCLK),
						  .O(clockFlag),
						  .RST(upedge_reset));

  //this register takes in the address coming from the processor and stores it in the register
  register #(23) address_reg(.DIN(address), 
  					    .DOUT(address_out), 
					    .WE((NextState == write & CurState == idle) | (NextState == read & CurState == idle)), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

  //this register takes in the data_in coming from the processor and stores it in the register
  register #(32) data_in_reg(.DIN(data_in), 
   					    .DOUT(data_in_dout),
					    .WE((NextState == write & CurState == idle) | (NextState == read & CurState == idle)),
					    .CLK(DRAMCLK),
					    .RST(RESET));

  //this register takes in the r_w coming from the processor and stores it in the register
  //added by Thomas 10/25
  register #(1) r_w_reg(.DIN(r_w), 
   				    .DOUT(r_w_dout),
				    .WE((NextState == write & CurState == idle) | (NextState == read & CurState == idle)),
				    .CLK(DRAMCLK),
				    .RST(RESET));


//always block to assign the data out register after every read
  always @(posedge DRAMCLK) begin
  	if (RESET)
		data_out <= 32'b0;
	//else if (CurState == read || NextState == waitForProc)
	else if (CurState == read && eight_counter_out == 6) 
		data_out <= Data;
	else
		data_out <= data_out;
  end
  
  //***************************************************************************************/

  //wire declarations: we make the 23 bit address and divide it up between bank, addr, and column
  wire [1:0] bank;
  wire [11:0] row;
  wire [8:0] column;

  assign bank[1:0] = address_out[22:21];
  assign row[11:0] = address_out[20:9];
  assign column[8:0] = address_out[8:0];

//================================State Machine Below=====================================

//state register
always @ (posedge DRAMCLK)
begin
	#1
	if (RESET) 
		CurState <= init;
   else 
		CurState <= NextState;
end

			
//Next State Logic
// sensitivity list MODIFIED BY CHAK/RICHARD
always @ (CurState or request or r_w or refresh_counter_out or
	  fsmcounter_out or eight_counter_out or three_counter_out or clockFlag or eight_counter_out or 
	  thirteen_counter_out or burstReadDone_reg or waitForMem_reg)

begin
	#1
	case (CurState)
		
		init: 
			begin
				if (fsmcounter_out == 3008) NextState <= idle;
				else NextState <= init;			
			end
		idle:
			begin
				if (request == 0 && refresh_counter_out > 0) 
				     NextState <= refresh; 
				else if (refresh_counter_out > 4000)
	   		     // getting close to DRAM failing, automatically refresh
					  NextState <= refresh;
				else if (request == 1 && r_w == 1) 
				     NextState <= write;
				else if (request == 1 && r_w == 0) 
				     NextState <= read;
				else 
				     NextState <= idle;
			end
		write: 
			begin	
				if (eight_counter_out == 7) 
				     NextState <= waitForProc; // 8 cycles, we're done writing
				else 
				     NextState <= write;
			end
		postWrite:
			begin
				if (waitForMem_reg)
					NextState <= waitForProc;
				else
					NextState <= postWrite;
			end
			
		read: 
			begin
				if (thirteen_counter_out == 12)  // MODIFIED BY CHAK/RICHARD 
				     NextState <= cacheWrite; // 8 cycles, we're done reading
				else 
				     NextState <= read;
			end
		cacheWrite:
			begin
				if (burstReadDone_reg) // make sure proc clock has registered this value
					NextState <= waitForProc;
				else
					NextState <= cacheWrite;
			end
		waitForProc:
		   begin
				if (clockFlag)
					NextState <= waitForReq;
				else if (refresh_counter_out > 0)
					NextState <= refresh_wait;
				else
					NextState <= waitForProc;
			end
		waitForReq:
		   begin
				if (~request)
					NextState <= idle;
				else 
					NextState <= waitForReq;
			end
		refresh_wait:
			begin
				if(three_counter_out == 2)
					NextState <= waitForProc;
	  		   else
					NextState <= refresh_wait;
			end
		refresh:
			begin
   	      if(three_counter_out == 2)
					NextState <= idle;
				else
					NextState <= refresh;
			end
		refresh_cacheWrite:
			begin
				if (three_counter_out == 2)
					NextState <= cacheWrite;
				else
					NextState <= refresh_cacheWrite;
			end
		refresh_postWrite:
			begin
				if (three_counter_out == 2)
					NextState <= postWrite;
				else
					NextState <= refresh_postWrite;
			end

		default:
			NextState <= init; 		
	endcase
end

//Output Logic
always @(CurState or fsmcounter_out or three_counter_out or eight_counter_out or bank or row or column
         or thirteen_counter_out or refresh_counter_out)  // MODIFIED BY CHAK/RICHARD
begin
   #1
	CS <= 0;
	RAS <= 1;
	CAS <= 1;
	WE <= 1; //defaults (NOP)
	Addr[11:0] <= 11'bx;
	Ba[1:0] <= 2'bx;
	DQM <= 0;
	waitForMem <= 0;
	burstReadDone <= 0;
	readBuffer_WE <= 0;
 
	case(CurState)
		init: begin
			if (fsmcounter_out >= 0 && fsmcounter_out < 101) //power_up stage needs to be 100us
								        // need to check that 3001 cycles is enough
				begin
					//do nothing
					waitForMem <= 1;
					////$display("Power-up");
				end
			else if (fsmcounter_out >= 101 && fsmcounter_out < 3001) //NOP_Long
				begin
					CS <= 0;					   
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					waitForMem <= 1;
					////$display("101->3001, fsm = %d", fsmcounter_out);
				end		
			else if (fsmcounter_out == 3001) //precharge
				begin
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 0;
					Addr[9:0] <= 10'bxxxxxxxxxx;
					Addr[10] <= 1;
					Addr[11] <= 1'bx;		
				  	waitForMem <= 1;
					//$display("3001");		
				end
			else if (fsmcounter_out == 3002 || fsmcounter_out == 3004
				 || fsmcounter_out == 3006 || fsmcounter_out == 3008) //NOP
				 begin
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					waitForMem <= 1;
					//$display("%d",fsmcounter_out);
				end
			else if(fsmcounter_out == 3003 || fsmcounter_out == 3005) //auto refresh
				begin
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
			 		waitForMem <= 1;
					//$display("%d",fsmcounter_out);
				end
			else if(fsmcounter_out == 3007) // load mode register
				begin
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 0;
					//Addr[11:0] <= 12'b001000100000;
					Addr[11:0] <= 12'b001000100011;  // MODIFIED BY CHAK/RICHARD
						// sets the RAM to the following parameters:
							//Write Burst = only 1
							//CAS latency = 2
							//Burst type = sequential
							//Burst length = 8 :P
					waitForMem <= 1;
					//$display("%d",fsmcounter_out);
				end
			else
				begin
				//$display("uh oh! transition! %d", fsmcounter_out);
				end
		end //end init		

		write:  begin
		//default cases
			case(eight_counter_out)
				0 : begin // active
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 1;
					Addr <= row;
					Ba <= bank;
					DQM <= 2'bx;
					waitForMem <= 1;
					//$display("writing, row: %h", row);					
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;	
				     end		
				2 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
				     end						
				3 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
				     end					
				4 : begin //write //data needs to be correct on this cycle
					CS <= 0;
					RAS <= 1;
					CAS <= 0;
					WE <= 0;
					Addr[10] <= 1; //for autoprecharge
				 	Addr[8:0] <= column;
					Ba <= bank;
					DQM <= 2'b00;
					waitForMem <= 1;
				     end						
				5 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
				     end	
				6 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
				     end	
				7 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
				     end	
			endcase //eight_counter_out				     			     				     			
		end

		postWrite: 
			waitForMem <= 1;

		read: begin
			case(thirteen_counter_out)
				0 : begin // active
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 1;
					Addr <= row;
					Ba <= bank;
					DQM <= 2'bx;
					waitForMem <= 1;
					burstReadDone <= 0;
					readBuffer_WE <= 0;
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
					burstReadDone <= 0;						
				     readBuffer_WE <= 0;
					end			
				2 : begin //read
					CS <= 0;
					RAS <= 1;
					CAS <= 0;
					WE <= 1;
					Addr[8:0] <= column;
					Addr[10] <= 1;
					Ba <= bank ;
					DQM <= 2'b00;
					waitForMem <= 1;
				     burstReadDone <= 0;
					readBuffer_WE <= 0;
					end						
				3 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 0;
					end	
				4 : begin //nop - word 1 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
					burstReadDone <= 0;
					readBuffer_WE <= 1;					
				     end	
				5 : begin //nop - word 2 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				6 : begin      //nop - word 3 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				7 : begin //nop- word 4 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				8 : begin //nop - word 5 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				9 : begin //nop - word 6 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				10 : begin //nop - word 7 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end	
				11 : begin //nop - word 8 is coming out
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 0;
					readBuffer_WE <= 1;
					end
				12 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;					
				     burstReadDone <= 1;
					readBuffer_WE <= 0;
					end
			endcase //eight_counter_out	
		end		

		cacheWrite:
		  begin
		   burstReadDone <= 1;
		   waitForMem <= 1;
		  end

		refresh_wait: begin
			case(three_counter_out)
				0 : begin // precharge
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 0;
					Addr[9:0] <= 10'bxxxxxxxxxx;
					Addr[10] <= 1;
					Addr[11] <= 1'bx;		
					Ba <= 2'bx;
					DQM <= 2'bx;
				  	waitForMem <= 1;
					//$display("Refresh_Wait - Precharge");		
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1;
					//$display("Refresh_Wait - NOP");
				     end				
				2 : begin //auto refresh
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					Ba <= 2'bx;
					DQM <= 2'bx;
			 		waitForMem <= 1;
					//$display("Refresh_Wait - AutoRefresh");
				    end
			endcase //three_counter_out
		end	

		refresh: begin
			case(three_counter_out)
				0 : begin // precharge
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 0;
					Addr[9:0] <= 10'bxxxxxxxxxx;
					Addr[10] <= 1;
					Addr[11] <= 1'bx;		
					Ba <= 2'bx;
					DQM <= 2'bx;
				  	waitForMem <= 1; // edited by Thomas
					//$display("Refresh - Precharge");		
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1; // edited by Thomas
					//$display("Refresh - NOP");
				     end				
				2 : begin //auto refresh
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					Ba <= 2'bx;
					DQM <= 2'bx;
			 		waitForMem <= 1; // edited by Thomas
					//$display("Refresh - AutoRefresh");
				    end
			endcase //three_counter_out
		end		


		refresh_cacheWrite: begin
			case(three_counter_out)
				0 : begin // precharge
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 0;
					Addr[9:0] <= 10'bxxxxxxxxxx;
					Addr[10] <= 1;
					Addr[11] <= 1'bx;		
					Ba <= 2'bx;
					DQM <= 2'bx;
				  	waitForMem <= 1; // edited by Thomas
					//$display("Refresh - Precharge");		
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1; // edited by Thomas
					//$display("Refresh - NOP");
				     end				
				2 : begin //auto refresh
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					Ba <= 2'bx;
					DQM <= 2'bx;
			 		waitForMem <= 1; // edited by Thomas
					//$display("Refresh_cacheWrite - AutoRefresh");
				    end
			endcase //three_counter_out
		end		

		refresh_postWrite: begin
			case(three_counter_out)
				0 : begin // precharge
					CS <= 0;
					RAS <= 0;
					CAS <= 1;
					WE <= 0;
					Addr[9:0] <= 10'bxxxxxxxxxx;
					Addr[10] <= 1;
					Addr[11] <= 1'bx;		
					Ba <= 2'bx;
					DQM <= 2'bx;
				  	waitForMem <= 1; // edited by Thomas
					//$display("Refresh - Precharge");		
				    end
				1 : begin //nop
					CS <= 0;
					RAS <= 1;
					CAS <= 1;
					WE <= 1;
					Addr <= 12'bx;
					Ba <= 2'bx;
					DQM <= 2'bx;
					waitForMem <= 1; // edited by Thomas
					//$display("Refresh - NOP");
				     end				
				2 : begin //auto refresh
					CS <= 0;
					RAS <= 0;
					CAS <= 0;
					WE <= 1;
					Addr[11:0] <= 12'bxxxxxxxxxxxx;
					Ba <= 2'bx;
					DQM <= 2'bx;
			 		waitForMem <= 1; // edited by Thomas
					//$display("Refresh_refresh_postWrite - AutoRefresh");
				    end
			endcase //three_counter_out
		end		



		waitForReq: begin
			CS <= 0;
			RAS <= 1;
			CAS <= 1;
			WE <= 1;
			Addr <= 12'b0;
			Ba <= 2'b0;
			DQM <= 2'b0;
			waitForMem <= 0;
			//$display("waitForReq - NOP");			
		end

		waitForProc: begin
			CS <= 0;
			RAS <= 1;
			CAS <= 1;
			WE <= 1;
			Addr <= 12'b0;
			Ba <= 2'b0;
			DQM <= 2'b0;
			waitForMem <= 1;
			//$display("waitForProc - NOP");
		end

		idle: begin
			CS <= 0;
			RAS <= 1;
			CAS <= 1;
			WE <= 1;
			Addr <= 12'b0;
			Ba <= 2'b0;
			DQM <= 2'b0;
			waitForMem <= (refresh_counter_out == 1); // edited by Thomas
			//$display("Idle - NOP");
		end


	endcase // CS
end
//===========end of state machine============================

// Added by Chak and Thomas
// Since the processor clock might be slower than the DRAM clock, cache might not have
// a chance to write the cache line.  FSM makes sure burstReadDone stays high until
// burstReadDone_reg goes high.
	register #(1) burstReadDone_register (.DIN(burstReadDone), .DOUT(burstReadDone_reg), .WE(1'b1), 
				.CLK(PROCCLK), .RST(RESET));
	register #(1) waitForMem_register (.DIN(waitForMem), .DOUT(waitForMem_reg), .WE(1'b1),
				.CLK(PROCCLK), .RST(RESET));

endmodule

