module branchUnit(inst, addr, rs, rt, Qj, Qk, targetAddr);
	
	input [31:0] inst, addr, rs, rt;
	input [4:0] Qj, Qk;				// for checking if operands are ready
	output [31:0] targetAddr;
//	output stall;					// if jr's register is not ready
//   commented out because dispatch takes care of it with jrstall signal
	
	parameter
	rtype_opcode = 6'b0,
	beq_opcode = 6'b000100,	  // beq (opcode 4)
	bne_opcode = 6'b000101,	  // bne (opcode 5)
	branch_rt_opcode = 6'b000001, //bgez/bltz (opcode 1) differentiated by rt field
	j_opcode = 6'b000010,         // j  (opcode 2)
	jal_opcode = 6'b000011,	  // jal (opcode 3)
	jr_funct = 6'b001000,  	  // jr (funct 8)
	bgez_rt = 5'b00001,		  // bgez (rt 1)
  	bltz_rt = 5'b00000;		  // bltz (rt 0)

	wire [31:0] extendedImmed;
	reg [31:0] targetAddr;
	extend myExtender(.in0(inst[15:0]), .out0(extendedImmed), .extendType(2'b01));
	wire [31:0] extendedImmedX;
	assign extendedImmedX = {extendedImmed[29:0],2'b00}; // X is cool

	always @ (inst or addr or rs or rt or Qj or Qk or extendedImmedX) begin
		if (!Qj) begin
			if (inst[31:26] == j_opcode ||
				inst[31:26] == jal_opcode ||
				(inst[31:26] == rtype_opcode && inst[5:0] == jr_funct)) begin
				case (inst[31:26])
				j_opcode: targetAddr = {addr[31:28], inst[25:0], 2'b00};
				jal_opcode: targetAddr = {addr[31:28], inst[25:0], 2'b00};
				rtype_opcode: targetAddr = rs;
				default : targetAddr = 32'bx;
				endcase
			end
			else begin
				if (!Qk) begin
					case (inst[31:26])
					beq_opcode: targetAddr = (rs == rt) ? addr + 4 + extendedImmedX : addr + 8;
					bne_opcode: targetAddr = (rs != rt) ? addr + 4 + extendedImmedX : addr + 8;
					branch_rt_opcode: begin
						if (inst[20:16] == bgez_rt)
							targetAddr = (!rs[31]) ? addr + 4 + extendedImmedX : addr + 8; 
						else if (inst[20:16] == bltz_rt)
							targetAddr = (rs[31]) ? addr + 4 + extendedImmedX : addr + 8;
						else targetAddr = 32'bx;
					end	
			   	default: targetAddr = 32'bx;
					endcase
				end
				else targetAddr = 32'bx;
			end
		end
		else
			targetAddr = 32'bx;	
	end	

//	assign stall = (inst[31:26] == jr_funct) & Qj;


endmodule
