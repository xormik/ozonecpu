/*
# tests branches
0x00	ori	$8,$0,0x4D4C
0x04	or	$9,$0,$8
0x08	beq	$8,$9,test2a
0x0c	addiu	$15, $0, 1
0x10	j	fail2
test2a:	
0x14	beq	$8,$0,fail2
0x18	addiu	$15, $15, 1	
0x1c	bne	$0,$8,test2b
0x20	addiu	$15, $15, 1	
0x24	j	fail2
test2b:	
0x28	bne	$8,$9,fail2
0x2c	addiu	$15, $15, 1
test2d:	
0x30	addiu	$9,$9,-1
0x34	j	test2e
0x38	addiu	$15, $15, 1
0x3c	j	fail2
test2e:	
0x40	jal	test2f
0x44	addiu	$15, $15, 1
0x48	j	test2g
0x4c	addiu	$15, $15, 1		
0x50	j	fail2
test2f:	
0x54	jr	$ra
0x58	addiu	$15, $15, 1
test2g:	
0x5c	j	done
0x60	addiu	$15, $15, 1	
fail2:	
0x64	addiu	$15, $15, 1
0x68	ori	$7,$0,0x7777
0x6c	j	done
0x70	addiu	$7, $7, 1
done:
0x74	addiu	$21, $0, 21
*/

module rom_test_branch (addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)

	5'h00: instr <= 32'h34084d4c;
	5'h01: instr <= 32'h00084825;
	5'h02: instr <= 32'h11090002;
	5'h03: instr <= 32'h240f0001;
	5'h04: instr <= 32'h0bffffD9; // 32'h08000019; // 0x10	j	fail2
	5'h05: instr <= 32'h11000013;
	5'h06: instr <= 32'h25ef0001;
	5'h07: instr <= 32'h14080002;
	5'h08: instr <= 32'h25ef0001;
	5'h09: instr <= 32'h0bffff19;	// h08000019; // 0x24	j	fail2
	5'h0a: instr <= 32'h1509000e;
	5'h0b: instr <= 32'h25ef0001;
	5'h0c: instr <= 32'h2529ffff;
	5'h0d: instr <= 32'h0bffffD0; // h08000010; // 0x34	j	test2e
	5'h0e: instr <= 32'h25ef0001;
	5'h0f: instr <= 32'h0bffffD9;	// h08000019; // 0x3c	j	fail2
	5'h10: instr <= 32'h0fffffD5; // h0c000015; // 0x40	jal	test2f
	5'h11: instr <= 32'h25ef0001;
	5'h12: instr <= 32'h0bffffD7; // h08000017; // 0x48	j	test2g
	5'h13: instr <= 32'h25ef0001;
	5'h14: instr <= 32'h0bffffD9; // h08000019; // 0x50	j	fail2
	5'h15: instr <= 32'h03e00008;
	5'h16: instr <= 32'h25ef0001;
	5'h17: instr <= 32'h0800001d; // 0x54	jr	$ra
	5'h18: instr <= 32'h25ef0001;
	5'h19: instr <= 32'h25ef0001; 
	5'h1a: instr <= 32'h34077777;
	5'h1b: instr <= 32'h0bffffdd; // h0800001d; // 0x6c	j	done
	5'h1c: instr <= 32'h24e70001;
	5'h1d: instr <= 32'h24150015;
		
		
	default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
