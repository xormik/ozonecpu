module rom (addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)
	   5'h00: instr <= 32'h3c08dead;	  
	   5'h01: instr <= 32'h3508beef;	  
	   5'h02: instr <= 32'hac08fff0;
	   5'h03: instr <= 32'h3c018000;
 	   5'h04: instr <= 32'h34072000;	  
	   5'h05: instr <= 32'h0BFFFFD0;	// j L3, Victor fixed this
	   5'h06: instr <= 32'h8c280004;
	   5'h07: instr <= 32'h24210008;
	   5'h08: instr <= 32'h8c240000;
	   5'h09: instr <= 32'hac440000;	  
	   5'h0A: instr <= 32'h2463ffff;	  
	   5'h0B: instr <= 32'h24210004;			
	   5'h0C: instr <= 32'h1460fffb;			
	   5'h0D: instr <= 32'h24420004;			  
	   5'h0E: instr <= 32'h0027282a;			   
	   5'h0F: instr <= 32'h10a00006;			  
	   5'h10: instr <= 32'h8c230000;	   
	   5'h11: instr <= 32'h1460fff5;			 
	   5'h12: instr <= 32'h8c220004;			  
	   5'h13: instr <= 32'hac08fff0;			   
	   5'h14: instr <= 32'h01000008;			    
	   5'h15: instr <= 32'h00002a8d;				
	   5'h16: instr <= 32'h0bffffd6;	// j BADEND (08000016) someone fixed this				 
	   5'h17: instr <= 32'h00001fcd;
	   default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
