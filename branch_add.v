module branch_add(immed, addr_in, addr_taken, addr_notTaken);

input [15:0] immed;
input [31:0] addr_in;
output [31:0] addr_taken;
output [31:0] addr_notTaken;

wire [31:0] extendedImmed;

extend myExtender(.in0(immed), .out0(extendedImmed), .extendType(2'b01));

assign addr_taken = addr_in + 4 + {extendedImmed[29:0],2'b00};
assign addr_notTaken = addr_in + 8;

endmodule
