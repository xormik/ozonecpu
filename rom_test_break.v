module rom_test_break(addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  always @ (addr) begin
		case(addr)
			5'h00: instr <= 32'h24010001;
			5'h01: instr <= 32'h24020002;
			5'h02: instr <= 32'h24030003;
			5'h03: instr <= 32'h000000cd;
			5'h04: instr <= 32'h24040004;
			5'h05: instr <= 32'h24050005;
			5'h06: instr <= 32'h0000014d;
			5'h07: instr <= 32'h24060006;
			5'h08: instr <= 32'h24070007;
			5'h09: instr <= 32'h000001cd;
			5'h0a: instr <= 32'h24080008;
			default: begin
	     	instr <= 32'bx; 
			end
		endcase
	end
endmodule
