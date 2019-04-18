module rom_test_bgez_bltz (addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

/*
 * THIS TEST ROM DOES NOT WORK BECAUSE THE ADDRESSING IS OFF
 * YOU CAN RECREATE THE ROM BY CONVERTING u:\ozone\bgezbltz.s
 * Note that the jump instructions need to be converted to jump
 *  into the ROM address space
 */

 /*
 # Test program for bgez, bltz for Victor.
# Author: - The Deprived One
0x00 ori	$1,$0,0x01
0x08 ori	$3,$0,0x04
0x10 lui	$5,0x8001
0x18 lui	$7,0x7fff
0x1c lui	$8,0xffff
0x20 ori	$8,$8,0xffff
0x24 ori	$9,$0,0x0

begin:
0x28 jal	end	# jal to 0x38 begin at the end
0x2c sll	$0,$0,0
0x30 j	done
0x34 sll	$0,$0,0
end:

#
# bgez
#

test1:	# bgez equal
0x38 bgez	$9,test2
0x3c sll	$0,$0,0
0x40 j	fail1
0x44 sll	$0,$0,0

test2:	# bgez greater sml pos
0x48 bgez	$7,test3
0x4c sll	$0,$0,0
0x50 j	fail2
0x54 sll	$0,$0,0

test3:	# bgez greater big pos
0x58 bgez	$1,test4
0x5c sll	$0,$0,0
0x60 j	fail3
0x64 sll	$0,$0,0

test4:	# bgez less sml neg
0x68 bgez	$8,fail4
0x6c sll	$0,$0,0

test5:	# bgez less big neg
0x70 bgez	$5,fail5
0x74 sll	$0,$0,0

#
# bltz
#

test6:	# bltz equal
0x78 bltz	$9,fail6
0x7c sll	$0,$0,0

test7:	# bltz greater sml pos
0x80 bltz	$3,fail7
0x84 sll	$0,$0,0

test8:	# bltz greater big pos
0x88 bltz	$7,fail8
0x8c sll	$0,$0,0

test9:	# bltz less sml neg
0x90 bltz	$8,test10
0x94 sll	$0,$0,0
0x98 j	fail9
0x9c sll	$0,$0,0

test10:	# bltz less big neg
0xa0 bltz	$5,test11
0xa4 sll	$0,$0,0
0xa8 j	fail10
0xac sll	$0,$0,0

test11:
0xb0 jr	$31
0xb4 sll	$0,$0,0
fail1:
fail2:
fail3:
fail4:
fail5:
fail6:
fail7:
fail8:
fail9:
fail10:
ori	$20,$0,0xBAD
j	finish
sll	$0,$0,0
done:
ori	$20,$0,0x600D
finish:

*/
 
 
 
  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)
	   	  
	   5'h00: instr <= 32'h34010001;
	   5'h01: instr <= 32'h34030004;
	   5'h02: instr <= 32'h3c058001;
	   5'h03: instr <= 32'h3c077fff;
	   5'h04: instr <= 32'h3c08ffff;
	   5'h05: instr <= 32'h3508ffff;
	   5'h06: instr <= 32'h34090000;
	   5'h07: instr <= 32'h0fffffce;  // 0c00000e; // jal
	   5'h08: instr <= 32'h00000000;
	   5'h09: instr <= 32'h0bfffff1;  // 08000031;
	   5'h0a: instr <= 32'h00000000;
/* commented out b/c rom addresses is only 5 bits
 * uncomment this to run bgez tests, but then comment out bltz tests
	   // bgez tests
	   5'h0b: instr <= 32'h05210003;
	   5'h0c: instr <= 32'h00000000;
	   5'h0d: instr <= 32'h0bffffee;  // 0800002e;
	   5'h0e: instr <= 32'h00000000;
	   5'h0f: instr <= 32'h04e10003;
	   5'h10: instr <= 32'h00000000;
	   5'h11: instr <= 32'h0bffffee;
	   5'h12: instr <= 32'h00000000;
	   5'h13: instr <= 32'h04210003;
	   5'h14: instr <= 32'h00000000;
	   5'h15: instr <= 32'h0bffffee;
	   5'h16: instr <= 32'h00000000;
	   5'h17: instr <= 32'h05010013;
	   5'h18: instr <= 32'h00000000;
	   5'h19: instr <= 32'h04a10011;
	   5'h1a: instr <= 32'h00000000;
*/
	   
	   // bltz tests
	   5'h0b: instr <= 32'h0520000f; // bltz
	   5'h0c: instr <= 32'h00000000;
	   5'h0d: instr <= 32'h0460000d;
	   5'h0e: instr <= 32'h00000000;
	   5'h0f: instr <= 32'h04e0000b;
	   5'h10: instr <= 32'h00000000;
	   5'h11: instr <= 32'h05000003;
	   5'h12: instr <= 32'h00000000;
	   5'h13: instr <= 32'h0bffffee;
	   5'h14: instr <= 32'h00000000;
	   5'h15: instr <= 32'h04a0ffd7;
	   5'h16: instr <= 32'h00000000;
	   5'h17: instr <= 32'h0bffffee;
	   5'h18: instr <= 32'h00000000;

	   // ending test
	   5'h19: instr <= 32'h03e00008;
	   5'h1a: instr <= 32'h00000000;
	   5'h1b: instr <= 32'h34140bad;
	   5'h1c: instr <= 32'h0bfffff2;  // 08000032;
	   5'h1d: instr <= 32'h00000000;
	   5'h1e: instr <= 32'h3414600d;

	   default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule
