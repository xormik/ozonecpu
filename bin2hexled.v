//////////////////////////////////////////////////////////////////////////
//binary to segment LED converter 
// converts from 4bit input to coresponding 
module bin2HexLED (IN, SEGLED);
   input [3:0] IN;
   output [6:0] SEGLED;
   reg [6:0] 	SEGLED;
   
   always @(IN) begin
      case (IN)
	4'h0: SEGLED <= 7'b0111111;
	4'h1: SEGLED <= 7'b0000110;
	4'h2: SEGLED <= 7'b1011011;
	4'h3: SEGLED <= 7'b1001111;
	4'h4: SEGLED <= 7'b1100110;
	4'h5: SEGLED <= 7'b1101101;
	4'h6: SEGLED <= 7'b1111101;
	4'h7: SEGLED <= 7'b0000111;
	4'h8: SEGLED <= 7'b1111111;
	4'h9: SEGLED <= 7'b1100111;
	4'hA: SEGLED <= 7'b1110111;
	4'hB: SEGLED <= 7'b1111100;
	4'hC: SEGLED <= 7'b1011000;
	4'hD: SEGLED <= 7'b1011110;
	4'hE: SEGLED <= 7'b1111001;
	4'hF: SEGLED <= 7'b1110001;
      endcase
   end
endmodule // HEXLED