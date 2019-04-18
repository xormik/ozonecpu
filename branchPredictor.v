module branchPredictor(inst, branchPC, updatePC, notTakenPC, takenPC, branchResult, update,
			predictedPC, clk, rst);

input [31:0] inst;		// the input inst, we have to decode it to determine if it is a branch inst.
input [31:0] branchPC;	// PC of the branch instruction being predicted
input [31:0] updatePC;	// PC of the branch we've determined the result for and now want to update
input [31:0] notTakenPC;	// BranchPC + 8
input [31:0] takenPC;	// BranchPC + 4 + immed
input branchResult;		// correct branch result, used when update also asserted
input update;			// assert for one cycle when result of branch determined, update accordingly
input clk;			// clock
input rst;			// reset
output [31:0] predictedPC;
reg [1:0] NextState, CurState;
reg [1:0] BHT[0:255];	// Stores state of prediction (4 states, 2 bits).  Indexed by [9:2].
reg [31:0] predictedPC;
parameter	notTaken = 2'b00, notTaken2 = 2'b01, taken = 2'b10, taken2 = 2'b11;
parameter	beq_opcode = 6'b000100,	  // beq (opcode 4)
		bne_opcode = 6'b000101,	  // bne (opcode 5)
	     branch_rt_opcode = 6'b000001; //bgez/bltz (opcode 1) differentiated by rt field


always @ (posedge clk) begin
	if (rst) begin
		CurState = notTaken;
		NextState = notTaken;
		BHT[0] = taken2; BHT[1] = taken2; BHT[2] = taken2; BHT[3] = taken2; BHT[4] = taken2; BHT[5] = taken2; BHT[6] = taken2; BHT[7] = taken2; BHT[8] = taken2; BHT[9] = taken2; BHT[10] = taken2; BHT[11] = taken2; BHT[12] = taken2; BHT[13] = taken2; BHT[14] = taken2; BHT[15] = taken2; BHT[16] = taken2; BHT[17] = taken2; BHT[18] = taken2; BHT[19] = taken2; BHT[20] = taken2; BHT[21] = taken2; BHT[22] = taken2; BHT[23] = taken2; BHT[24] = taken2; BHT[25] = taken2; BHT[26] = taken2; BHT[27] = taken2; BHT[28] = taken2; BHT[29] = taken2; BHT[30] = taken2; BHT[31] = taken2; BHT[32] = taken2; BHT[33] = taken2; BHT[34] = taken2; BHT[35] = taken2; BHT[36] = taken2; BHT[37] = taken2; BHT[38] = taken2; BHT[39] = taken2; BHT[40] = taken2; BHT[41] = taken2; BHT[42] = taken2; BHT[43] = taken2; BHT[44] = taken2; BHT[45] = taken2; BHT[46] = taken2; BHT[47] = taken2; BHT[48] = taken2; BHT[49] = taken2; BHT[50] = taken2; BHT[51] = taken2; BHT[52] = taken2; BHT[53] = taken2; BHT[54] = taken2; BHT[55] = taken2; BHT[56] = taken2; BHT[57] = taken2; BHT[58] = taken2; BHT[59] = taken2; BHT[60] = taken2; BHT[61] = taken2; BHT[62] = taken2; BHT[63] = taken2; 
		BHT[64] = taken2; BHT[65] = taken2; BHT[66] = taken2; BHT[67] = taken2; BHT[68] = taken2; BHT[69] = taken2; BHT[70] = taken2; BHT[71] = taken2; BHT[72] = taken2; BHT[73] = taken2; BHT[74] = taken2; BHT[75] = taken2; BHT[76] = taken2; BHT[77] = taken2; BHT[78] = taken2; BHT[79] = taken2; BHT[80] = taken2; BHT[81] = taken2; BHT[82] = taken2; BHT[83] = taken2; BHT[84] = taken2; BHT[85] = taken2; BHT[86] = taken2; BHT[87] = taken2; BHT[88] = taken2; BHT[89] = taken2; BHT[90] = taken2; BHT[91] = taken2; BHT[92] = taken2; BHT[93] = taken2; BHT[94] = taken2; BHT[95] = taken2; BHT[96] = taken2; BHT[97] = taken2; BHT[98] = taken2; BHT[99] = taken2; BHT[100] = taken2; BHT[101] = taken2; BHT[102] = taken2; BHT[103] = taken2; BHT[104] = taken2; BHT[105] = taken2; BHT[106] = taken2; BHT[107] = taken2; BHT[108] = taken2; BHT[109] = taken2; BHT[110] = taken2; BHT[111] = taken2; BHT[112] = taken2; BHT[113] = taken2; BHT[114] = taken2; BHT[115] = taken2; BHT[116] = taken2; BHT[117] = taken2; BHT[118] = taken2; BHT[119] = taken2; BHT[120] = taken2; BHT[121] = taken2; BHT[122] = taken2; BHT[123] = taken2; BHT[124] = taken2; BHT[125] = taken2; BHT[126] = taken2; BHT[127] = taken2; 
		BHT[128] = taken2; BHT[129] = taken2; BHT[130] = taken2; BHT[131] = taken2; BHT[132] = taken2; BHT[133] = taken2; BHT[134] = taken2; BHT[135] = taken2; BHT[136] = taken2; BHT[137] = taken2; BHT[138] = taken2; BHT[139] = taken2; BHT[140] = taken2; BHT[141] = taken2; BHT[142] = taken2; BHT[143] = taken2; BHT[144] = taken2; BHT[145] = taken2; BHT[146] = taken2; BHT[147] = taken2; BHT[148] = taken2; BHT[149] = taken2; BHT[150] = taken2; BHT[151] = taken2; BHT[152] = taken2; BHT[153] = taken2; BHT[154] = taken2; BHT[155] = taken2; BHT[156] = taken2; BHT[157] = taken2; BHT[158] = taken2; BHT[159] = taken2; BHT[160] = taken2; BHT[161] = taken2; BHT[162] = taken2; BHT[163] = taken2; BHT[164] = taken2; BHT[165] = taken2; BHT[166] = taken2; BHT[167] = taken2; BHT[168] = taken2; BHT[169] = taken2; BHT[170] = taken2; BHT[171] = taken2; BHT[172] = taken2; BHT[173] = taken2; BHT[174] = taken2; BHT[175] = taken2; BHT[176] = taken2; BHT[177] = taken2; BHT[178] = taken2; BHT[179] = taken2; BHT[180] = taken2; BHT[181] = taken2; BHT[182] = taken2; BHT[183] = taken2; BHT[184] = taken2; BHT[185] = taken2; BHT[186] = taken2; BHT[187] = taken2; BHT[188] = taken2; BHT[189] = taken2; BHT[190] = taken2; BHT[191] = taken2; 
		BHT[192] = taken2; BHT[193] = taken2; BHT[194] = taken2; BHT[195] = taken2; BHT[196] = taken2; BHT[197] = taken2; BHT[198] = taken2; BHT[199] = taken2; BHT[200] = taken2; BHT[201] = taken2; BHT[202] = taken2; BHT[203] = taken2; BHT[204] = taken2; BHT[205] = taken2; BHT[206] = taken2; BHT[207] = taken2; BHT[208] = taken2; BHT[209] = taken2; BHT[210] = taken2; BHT[211] = taken2; BHT[212] = taken2; BHT[213] = taken2; BHT[214] = taken2; BHT[215] = taken2; BHT[216] = taken2; BHT[217] = taken2; BHT[218] = taken2; BHT[219] = taken2; BHT[220] = taken2; BHT[221] = taken2; BHT[222] = taken2; BHT[223] = taken2; BHT[224] = taken2; BHT[225] = taken2; BHT[226] = taken2; BHT[227] = taken2; BHT[228] = taken2; BHT[229] = taken2; BHT[230] = taken2; BHT[231] = taken2; BHT[232] = taken2; BHT[233] = taken2; BHT[234] = taken2; BHT[235] = taken2; BHT[236] = taken2; BHT[237] = taken2; BHT[238] = taken2; BHT[239] = taken2; BHT[240] = taken2; BHT[241] = taken2; BHT[242] = taken2; BHT[243] = taken2; BHT[244] = taken2; BHT[245] = taken2; BHT[246] = taken2; BHT[247] = taken2; BHT[248] = taken2; BHT[249] = taken2; BHT[250] = taken2; BHT[251] = taken2; BHT[252] = taken2; BHT[253] = taken2; BHT[254] = taken2; BHT[255] = taken2; 
	end
	else	begin
		if (update) begin
			case (BHT[updatePC[9:2]])
			notTaken: NextState = (branchResult) ?  notTaken2: notTaken;
			notTaken2: NextState = (branchResult) ?  taken2: notTaken;
			taken:	NextState = (branchResult) ? taken: taken2;
			taken2:	NextState = (branchResult) ? taken: notTaken2;
			endcase
			if (inst[31:26] == beq_opcode || inst[31:26] == bne_opcode || inst[31:26] == branch_rt_opcode)
				if (branchPC == updatePC)
					predictedPC = (NextState[1]) ? takenPC : notTakenPC;
				else predictedPC = (CurState[1]) ? takenPC : notTakenPC;
			BHT[ updatePC[9:2] ] = NextState;
		end	
		if ((inst[31:26] == beq_opcode || inst[31:26] == bne_opcode || inst[31:26] == branch_rt_opcode) 
			&& !update) begin
			CurState = BHT[ branchPC[9:2] ];
			predictedPC = (CurState[1]) ? takenPC : notTakenPC;
			end
		//else predictedPC = 32'b0;	// set to 0 b/c we don't want to send xXx to inst cache
	end
end
endmodule