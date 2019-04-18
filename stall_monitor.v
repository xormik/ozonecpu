// prints stalls

module stall_monitor(clk,
                     stall,
                     robFull, brnchFull, aluFull, mulDivFull, lwFull, swFull,
				 cycle_count);

  input clk;
  input stall, robFull, brnchFull, aluFull, mulDivFull, lwFull, swFull;
  input [63:0] cycle_count;

  	// open file for writing
  	`ifdef synthesis
  	`else
    		integer fd = 0;
    		initial begin
    		fd = $fopen("trace_stall.txt", "w");
    		end
  	`endif

  always @ (posedge clk)
  begin

  if (stall | robFull | brnchFull | aluFull | mulDivFull | lwFull | swFull)
  begin	
	$fwrite(fd, "CC: 0x%16h Stall!\n",
		   cycle_count);
  end

  end

endmodule
