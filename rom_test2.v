// Thomas' test instructions.
// Current test: data forwarding for alu instructions

/*
# tests alu_dependencies
# by Thomas Yiu

addiu $1, $0, 1
addiu $2, $0, 2
addu $3, $1, $2
sll $12, $3, 2
break 1
subu $9, $12, $3
sra $6, $12, 1
addu $15, $9, $6
addu $30, $15, $15
addu $31, $1, $2
subu $31, $1, $2
slt $4, $31, $0
sltu $5, $31, $0

*/

module rom_test2 (addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)
	   5'h00: instr <= 32'h24010001;	// addiu $1, $0, 1	  
	   5'h01: instr <= 32'h24020002;
	   5'h02: instr <= 32'h00221821;
	   5'h03: instr <= 32'h00036080;
 	   5'h04: instr <= 32'h01834823;	  
	   5'h05: instr <= 32'h0000004d;   // break 1
	   5'h06: instr <= 32'h000c3043;
	   5'h07: instr <= 32'h01267821;
	   5'h08: instr <= 32'h01eff021;
	   5'h09: instr <= 32'h0022f821;	  
	   5'h0A: instr <= 32'h0022f823;	  
	   5'h0B: instr <= 32'h03e0202a;			
	   5'h0C: instr <= 32'h03e0282b;			
	   5'h0D: instr <= 32'h00000000;			  
	   5'h0E: instr <= 32'h00000000;			   
	   5'h0F: instr <= 32'h00000000;			  
	   5'h10: instr <= 32'h00000000;	   
	   5'h11: instr <= 32'h00000000;			 
	   5'h12: instr <= 32'h00000000;			  
	   5'h13: instr <= 32'h00000000;			   
	   5'h14: instr <= 32'h00000000;			    
	   5'h15: instr <= 32'h00000000;				
	   5'h16: instr <= 32'h00000000;				 
	   5'h17: instr <= 32'h00000000;
	   default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
