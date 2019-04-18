module chakRom (addr, instr);

  input [4:0] addr;
  output [31:0] instr;
  reg [31:0] instr;

  // addresses converted from 32 bit byte-addressable
  // to 23-bit word-addressable
  always @ (addr)
    begin
      case(addr)
	   
	   5'h00: instr <= 32'h24010bad;
	   5'h00: instr <= 32'h3c020152;
	   5'h00: instr <= 32'h00000000;
	   5'h00: instr <= 32'h00000000;
	   5'h00: instr <= 32'h14220002;
	   5'h00: instr <= 32'h34220000;
	   5'h00: instr <= 32'h241e001e;
	   5'h00: instr <= 32'h240a000a;
	   5'h00: instr <= 32'h240b000b;
	   5'h00: instr <= 32'h240c000c;
	   5'h00: instr <= 32'h240d000d;
	   5'h00: instr <= 32'h156c0002;
	   5'h00: instr <= 32'h240e000e;
	   5'h00: instr <= 32'h241f001f;
	   5'h00: instr <= 32'h240f000f;	   
	   

	   default: begin
	     instr <= 32'bx; 
          //$display("Invalid ROM address: %h", addr);
	   end
	 endcase
    end
	 
endmodule

