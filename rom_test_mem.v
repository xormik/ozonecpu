/*
# memory instructions test
# by Thomas Yiu

addiu $1, $0, 1
addiu $2, $0, 2
addu $3, $2, $1
addiu $12, $0, 12
addiu $28, $0, -4

sw $1, 0($0)
lw $11, 4($28)   # $11 <= 1
sw $2, 8($0)
sw $3, -12($0)
lw $12, -4($12)  # $12 <= 2
lw $13, -14($12) # $13 <= 3
*/

module rom_test_mem (addr, instr);

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
	   5'h02: instr <= 32'h00411821;
	   5'h03: instr <= 32'h240c000c;
 	   5'h04: instr <= 32'h241cfffc;	  
	   5'h05: instr <= 32'hac010000;   
	   5'h06: instr <= 32'h8f8b0004;
	   5'h07: instr <= 32'hac020008;
	   5'h08: instr <= 32'hac03fff4;
	   5'h09: instr <= 32'h8d8cfffc;	  
	   5'h0A: instr <= 32'h8d8dfff2;	  
	   5'h0B: instr <= 32'h00000000;			
	   5'h0C: instr <= 32'h00000000;			
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
	   5'h1f: instr <= 32'h8c0a0008;
	   default: begin
	     instr <= 32'b0; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
