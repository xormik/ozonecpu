// debugged from rom_test_mem2

/*
# memory instructions test 2
# by Thomas Yiu

# first sw and lw from set 0
# then sw and lw from set 1 with same index
# then sw and lw which kicks one of the sets out
# restore the original 

addiu $1, $0, 1
addu $2, $1, $1
addu $3, $2, $1
addu $4, $2, $2
addu $5, $3, $2
addu $6, $3, $3
addu $7, $4, $3

lui $21, 0x0040
# 23, 22, and 21 are in the same cache line
ori $23, $21, 0x0118
ori $22, $21, 0x0110
ori $21, $21, 0x0100
sw $1, 0($21)  # mem[0x10000100] <= 1
sw $2, 0($22)  # mem[0x10000110] <= 2
lw $12, 0($22) # R12 <= 2
sw $3, 0($23)  # mem[0x10000118] <= 3
lw $11, 0($21) # R11 <= 1
lw $13, 0($23) # R13 <= 3

lui $24, 0x0050
ori $25, $24, 0x0110
ori $26, $24, 0x0118
ori $24, $24, 0x0100
sw $4, 0($24)  # mem[0x20000100] <= 1
sw $5, 0($25)  # mem[0x20000110] <= 2
sw $6, 0($26)  # mem[0x20000118] <= 3
lw $14, 0($24) # R14 <= 4
lw $15, 0($25) # R15 <= 5
lw $16, 0($26) # R16 <= 6


lui $27, 0x0060
ori $27, $27, 0x0110
sw $7, 0($27)  # mem[0x30000100] <= 7
lw $17, 0($27) # R17 <= 7, will kick out one of the cache lines


lw $24, 0($24) # R24 <= 4
lw $22, 0($22) # R22 <= 2
lw $25, 0($25) # R25 <= 5
lw $21, 0($21) # R21 <= 1
lw $27, 0($27) # R27 <= 7
*/

module rom_test_mem2b (addr, instr);

  input [5:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)
	   'h00: instr <= 32'h24010001;	// addiu $1, $0, 1	  
	   'h01: instr <= 32'h00211021;
	   'h02: instr <= 32'h00411821;
	   'h03: instr <= 32'h00422021;
 	   'h04: instr <= 32'h00622821;	  
	   'h05: instr <= 32'h00633021;   
	   'h06: instr <= 32'h00833821;
	   'h07: instr <= 32'h3c150040;
	   'h08: instr <= 32'h36b70118;
	   'h09: instr <= 32'h36b60110;	  
	   'h0A: instr <= 32'h36b50100;	  
	   'h0B: instr <= 32'haea10000;			
	   'h0C: instr <= 32'haec20000;			
	   'h0D: instr <= 32'h8ecc0000;			  
	   'h0E: instr <= 32'haee30000;			   
	   'h0F: instr <= 32'h8eab0000;			  
	   'h10: instr <= 32'h8eed0000;	   
	   'h11: instr <= 32'h3c180050;			 
	   'h12: instr <= 32'h37190110;			  
	   'h13: instr <= 32'h371a0118;			   
	   'h14: instr <= 32'h37180100;			    
	   'h15: instr <= 32'haf040000;				
	   'h16: instr <= 32'haf250000;				 
	   'h17: instr <= 32'haf460000;
	   'h18: instr <= 32'h8f0e0000;
	   'h19: instr <= 32'h8f2f0000;
	   'h1a: instr <= 32'h8f500000;
	   'h1b: instr <= 32'h3c1b0060;
	   'h1c: instr <= 32'h377b0110;
	   'h1d: instr <= 32'haf670000;
	   'h1e: instr <= 32'h8f710000;
	   'h1f: instr <= 32'h8f180000;
	   'h20: instr <= 32'h8ed60000;
	   'h21: instr <= 32'h8f390000;
	   'h22: instr <= 32'h8eb50000;
	   'h23: instr <= 32'h8f7b0000;
	   default: begin
	     instr <= 32'b0; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
