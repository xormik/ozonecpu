module MultDivid_divisor_multiplier(value, value_out, clk, WE);
		    
	input [33:0] value; //value to store into register
	input clk; //clock
	input WE; //write enable signal to store the value into the register
	output [33:0] value_out; // output to be sent to where?

   reg [33:0] value_out;
   always @ (posedge clk)
      begin
         if (WE)
            begin
               value_out <= value;
            end
      end

endmodule
