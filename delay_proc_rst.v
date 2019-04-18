module delay_proc_rst(rst, DRAMCLK, proc_rst, PROCCLK_IN, PROCCLK_OUT);

  input rst;		  // master reset
  input DRAMCLK;
  input PROCCLK_IN;
  output PROCCLK_OUT;
  reg PROCCLK_OUT;
  reg turnClkOn;  // when asserted, turns on the processor clk

  output proc_rst;    // reset processor
  reg proc_rst;

  // state registers
  reg CurState, NextState;
  parameter init=1'b0, done=1'b1;

  wire [11:0] rstcounter_out;

  counter #(12) rstcounter (.OUT(rstcounter_out),
                            .CLK(DRAMCLK),
					   .ENABLE(1'b1),
					   .RESET(rst)
					   );

  // upon master reset, start counting ~ 3500 dram cycles
  // then assert proc_rst for a few cycles

  //state register
  always @ (posedge DRAMCLK)
  begin
	if (rst) 
		CurState <= init;
     else 
		CurState <= NextState;
  end


  // next state logic
  always @ (CurState or rstcounter_out )
  begin
    case(CurState)
      init:
	   // when reach count of 3500, transition to done state
	   if (rstcounter_out == 3500) NextState <= done;
	   else NextState <= init;
	 done:
	   // done go to done state	(NEVER output proc_rst again)
        NextState <= done;  
    endcase
  end

  // output logic
  always @ (CurState or rstcounter_out or PROCCLK_IN) 
  begin
    proc_rst = 1'b0;
    turnClkOn = 1'b0;


    case(CurState)
      init:
        begin
			 if (rstcounter_out < 3400)
			   PROCCLK_OUT = 1'b0;
//          if (rstcounter_out > 3397) turnClkOn = 1'b1;	 // turn on clock after 3350 cycles

	       // check which cycle, then output proc_rst for x cycles
          //  if (rstcounter_out == 3400 || rstcounter_out == 3401) 
		    else if (rstcounter_out >= 3400 && rstcounter_out < 3410)
			   begin
	           proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b0;
				end
			 else if (rstcounter_out >= 3410 && rstcounter_out < 3420)
			   begin
				  proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b1;
				end
			 else if (rstcounter_out >= 3420 && rstcounter_out < 3430)
			   begin
				  proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b0;
				end
			 else if (rstcounter_out >= 3430 && rstcounter_out < 3440)
			   begin
				  proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b1;
				end
			 else if (rstcounter_out >= 3440 && rstcounter_out < 3450)
			   begin
				  proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b0;
				end
			 else if (rstcounter_out >= 3450 && rstcounter_out < 3460)
			   begin
				  proc_rst = 1'b1;
				  PROCCLK_OUT = 1'b1;
				end
			 else if (rstcounter_out >= 3460 && rstcounter_out < 3470)
			   begin
				  proc_rst = 1'b0;
				  PROCCLK_OUT = 1'b1;
				end
          else
			   begin
	           proc_rst = 1'b0;
				  PROCCLK_OUT = 1'b1;
				end
	     end
		done:
	     begin
		    proc_rst = 1'b0;
		    PROCCLK_OUT = PROCCLK_IN;
//	       turnClkOn = 1'b1;   // continue turning on clock
	     end
	   // output nothing, nada!

    endcase
  end

  //assign PROCCLK_OUT = turnClkOn ? PROCCLK_IN : 1'b0;  // if turnClkOn=1, output clk otherwise not 

//  wire do_proc_rst;    // assert at positive edge of procclk, so that we can deassert rst

  // We want the proc_rst to turn back to 0 only after the positive edge of the processor clock, so use upedge detector
//  upedge_detector uut (.I(PROCCLK_IN),		// detect positive edge of PROCCLK_IN
//						  .C(DRAMCLK),
//						  .O(do_proc_rst),
//						  .RST(rst));

endmodule
