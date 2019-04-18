module rom_test3(addr, instr);
// Thomas' test instructions.
// Current test: data forwarding for alu instructions

/*
# tests alu_dependencies
# by Victor Kwok
0x00 addiu	$5, $0, ffff
0x04 addiu	$6, $0, ffff
0x08 mult	$5, $6
0x0c mfhi	$7
0x10 mflo	$8
0x14 divu	$6, $5
0x18 mfhi	$9
0x1c mflo	$10

*/



  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)

	 5'h00: instr <= 32'h2405ffff;
	 5'h01: instr <= 32'h24060001;
	 5'h02: instr <= 32'h00a60018;
	 5'h03: instr <= 32'h00003810;
	 5'h04: instr <= 32'h00004012;
	 5'h05: instr <= 32'h00c5001b;
	 5'h06: instr <= 32'h00004810;
	 5'h07: instr <= 32'h00005012;
	   default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule