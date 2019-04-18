module branchPredictor(branchPC, updatePC, notTakenPC, takenPC, branchResult, update, predict,
			predictedPC, clk, rst);
			//prediction, commit, rollbackPC, stall, rollback);

input [31:0] branchPC;	// PC of the branch instruction being predicted
input [31:0] updatePC;	// PC of the branch we've determined the result for and now want to update
input [31:0] notTakenPC;	// BranchPC + 8
input [31:0] takenPC;	// BranchPC + 4 + immed
input branchResult;		// correct branch result, used when update also asserted
input update;			// assert for one cycle when result of branch determined, update accordingly
input predict;			// request prediction at branchPC (assert one cycle)
input clk;			// clock
input rst;			// reset

/*
output prediction;		// branch prediction (asserted for branch taken)
output commit;			// assert for one cycle when prediction determined to be correct
output stall;			// assert when asked to predict during a prediction, until last predict resolved
output [31:0] rollbackPC; // PC of the address the correct branch should have taken
output rollback;		// assert for one cycle when prediction determined to be incorrect
*/

output predictedPC;

//reg stall, commit, rollback, prediction;
//reg [31:0] rollbackPC;

reg [31:0] predictedPC;
reg [2:0] NextState, CurState, updatingState;
reg [1:0] BHT[0:255];	// Stores state of prediction (4 states, 2 bits).  Indexed by [9:2].
reg [67:0] BFA;	// [67]Valid[66]Prediction[65:64]Status[63:32]AddressOfBranch[31:0]rollBackPC
reg branchResult_reg;
reg [31:0] updatePC_reg;

parameter	notTaken = 3'b000, notTaken2 = 3'b001, taken = 3'b010, taken2 = 3'b011, update1 = 3'b100, update2 = 3'b101;

always @ (posedge clk) begin
	if (rst) begin
		updatingState <= update1;
		CurState <= notTaken;
		NextState <= notTaken;
		//stall <= 0;
		//commit <= 0;
		//rollback <= 0;
		branchResult_reg <= 0;
		updatePC_reg <= 0;
		//prediction <= 1'bx;
		BFA <= 0;
		BHT[0] <= taken2; BHT[1] <= taken2; BHT[2] <= taken2; BHT[3] <= taken2; BHT[4] <= taken2; BHT[5] <= taken2; BHT[6] <= taken2; BHT[7] <= taken2; BHT[8] <= taken2; BHT[9] <= taken2; BHT[10] <= taken2; BHT[11] <= taken2; BHT[12] <= taken2; BHT[13] <= taken2; BHT[14] <= taken2; BHT[15] <= taken2; BHT[16] <= taken2; BHT[17] <= taken2; BHT[18] <= taken2; BHT[19] <= taken2; BHT[20] <= taken2; BHT[21] <= taken2; BHT[22] <= taken2; BHT[23] <= taken2; BHT[24] <= taken2; BHT[25] <= taken2; BHT[26] <= taken2; BHT[27] <= taken2; BHT[28] <= taken2; BHT[29] <= taken2; BHT[30] <= taken2; BHT[31] <= taken2; BHT[32] <= taken2; BHT[33] <= taken2; BHT[34] <= taken2; BHT[35] <= taken2; BHT[36] <= taken2; BHT[37] <= taken2; BHT[38] <= taken2; BHT[39] <= taken2; BHT[40] <= taken2; BHT[41] <= taken2; BHT[42] <= taken2; BHT[43] <= taken2; BHT[44] <= taken2; BHT[45] <= taken2; BHT[46] <= taken2; BHT[47] <= taken2; BHT[48] <= taken2; BHT[49] <= taken2; BHT[50] <= taken2; BHT[51] <= taken2; BHT[52] <= taken2; BHT[53] <= taken2; BHT[54] <= taken2; BHT[55] <= taken2; BHT[56] <= taken2; BHT[57] <= taken2; BHT[58] <= taken2; BHT[59] <= taken2; BHT[60] <= taken2; BHT[61] <= taken2; BHT[62] <= taken2; BHT[63] <= taken2; 
		BHT[64] <= taken2; BHT[65] <= taken2; BHT[66] <= taken2; BHT[67] <= taken2; BHT[68] <= taken2; BHT[69] <= taken2; BHT[70] <= taken2; BHT[71] <= taken2; BHT[72] <= taken2; BHT[73] <= taken2; BHT[74] <= taken2; BHT[75] <= taken2; BHT[76] <= taken2; BHT[77] <= taken2; BHT[78] <= taken2; BHT[79] <= taken2; BHT[80] <= taken2; BHT[81] <= taken2; BHT[82] <= taken2; BHT[83] <= taken2; BHT[84] <= taken2; BHT[85] <= taken2; BHT[86] <= taken2; BHT[87] <= taken2; BHT[88] <= taken2; BHT[89] <= taken2; BHT[90] <= taken2; BHT[91] <= taken2; BHT[92] <= taken2; BHT[93] <= taken2; BHT[94] <= taken2; BHT[95] <= taken2; BHT[96] <= taken2; BHT[97] <= taken2; BHT[98] <= taken2; BHT[99] <= taken2; BHT[100] <= taken2; BHT[101] <= taken2; BHT[102] <= taken2; BHT[103] <= taken2; BHT[104] <= taken2; BHT[105] <= taken2; BHT[106] <= taken2; BHT[107] <= taken2; BHT[108] <= taken2; BHT[109] <= taken2; BHT[110] <= taken2; BHT[111] <= taken2; BHT[112] <= taken2; BHT[113] <= taken2; BHT[114] <= taken2; BHT[115] <= taken2; BHT[116] <= taken2; BHT[117] <= taken2; BHT[118] <= taken2; BHT[119] <= taken2; BHT[120] <= taken2; BHT[121] <= taken2; BHT[122] <= taken2; BHT[123] <= taken2; BHT[124] <= taken2; BHT[125] <= taken2; BHT[126] <= taken2; BHT[127] <= taken2; 
		BHT[128] <= taken2; BHT[129] <= taken2; BHT[130] <= taken2; BHT[131] <= taken2; BHT[132] <= taken2; BHT[133] <= taken2; BHT[134] <= taken2; BHT[135] <= taken2; BHT[136] <= taken2; BHT[137] <= taken2; BHT[138] <= taken2; BHT[139] <= taken2; BHT[140] <= taken2; BHT[141] <= taken2; BHT[142] <= taken2; BHT[143] <= taken2; BHT[144] <= taken2; BHT[145] <= taken2; BHT[146] <= taken2; BHT[147] <= taken2; BHT[148] <= taken2; BHT[149] <= taken2; BHT[150] <= taken2; BHT[151] <= taken2; BHT[152] <= taken2; BHT[153] <= taken2; BHT[154] <= taken2; BHT[155] <= taken2; BHT[156] <= taken2; BHT[157] <= taken2; BHT[158] <= taken2; BHT[159] <= taken2; BHT[160] <= taken2; BHT[161] <= taken2; BHT[162] <= taken2; BHT[163] <= taken2; BHT[164] <= taken2; BHT[165] <= taken2; BHT[166] <= taken2; BHT[167] <= taken2; BHT[168] <= taken2; BHT[169] <= taken2; BHT[170] <= taken2; BHT[171] <= taken2; BHT[172] <= taken2; BHT[173] <= taken2; BHT[174] <= taken2; BHT[175] <= taken2; BHT[176] <= taken2; BHT[177] <= taken2; BHT[178] <= taken2; BHT[179] <= taken2; BHT[180] <= taken2; BHT[181] <= taken2; BHT[182] <= taken2; BHT[183] <= taken2; BHT[184] <= taken2; BHT[185] <= taken2; BHT[186] <= taken2; BHT[187] <= taken2; BHT[188] <= taken2; BHT[189] <= taken2; BHT[190] <= taken2; BHT[191] <= taken2; 
		BHT[192] <= taken2; BHT[193] <= taken2; BHT[194] <= taken2; BHT[195] <= taken2; BHT[196] <= taken2; BHT[197] <= taken2; BHT[198] <= taken2; BHT[199] <= taken2; BHT[200] <= taken2; BHT[201] <= taken2; BHT[202] <= taken2; BHT[203] <= taken2; BHT[204] <= taken2; BHT[205] <= taken2; BHT[206] <= taken2; BHT[207] <= taken2; BHT[208] <= taken2; BHT[209] <= taken2; BHT[210] <= taken2; BHT[211] <= taken2; BHT[212] <= taken2; BHT[213] <= taken2; BHT[214] <= taken2; BHT[215] <= taken2; BHT[216] <= taken2; BHT[217] <= taken2; BHT[218] <= taken2; BHT[219] <= taken2; BHT[220] <= taken2; BHT[221] <= taken2; BHT[222] <= taken2; BHT[223] <= taken2; BHT[224] <= taken2; BHT[225] <= taken2; BHT[226] <= taken2; BHT[227] <= taken2; BHT[228] <= taken2; BHT[229] <= taken2; BHT[230] <= taken2; BHT[231] <= taken2; BHT[232] <= taken2; BHT[233] <= taken2; BHT[234] <= taken2; BHT[235] <= taken2; BHT[236] <= taken2; BHT[237] <= taken2; BHT[238] <= taken2; BHT[239] <= taken2; BHT[240] <= taken2; BHT[241] <= taken2; BHT[242] <= taken2; BHT[243] <= taken2; BHT[244] <= taken2; BHT[245] <= taken2; BHT[246] <= taken2; BHT[247] <= taken2; BHT[248] <= taken2; BHT[249] <= taken2; BHT[250] <= taken2; BHT[251] <= taken2; BHT[252] <= taken2; BHT[253] <= taken2; BHT[254] <= taken2; BHT[255] <= taken2; 
	end
	else	begin
		if (update) begin
			case (BHT[updatePC[9:2]])
			notTaken: NextState = (branchResult) ?  notTaken2: notTaken;
			notTaken2: NextState = (branchResult) ?  taken2: notTaken;
			taken:	NextState = (branchResult) ? taken: taken2;
			taken2:	NextState = (branchResult) ? taken: notTaken2;
			endcase
			/*
			if (BFA[67] & (updatePC == BFA[63:32])) begin
				stall = 0;
				if (branchResult == BFA[66]) begin // prediction correct, commit
					commit = 1;
					rollback = 0;
				end
				else begin // mispredict, rollback
					rollbackPC = BFA[31:0];
					rollback = 1;
					commit = 0;
				end
				if (predict) begin
					stall = 0;
					prediction = CurState[1]; // CurState[1] == 1 for taken, taken2 states.
					BFA = { 1'b1, prediction, 2'b00, branchPC, (prediction ? notTakenPC : takenPC) };
				end
				else BFA = 0;
			end
			*/
			BHT[ updatePC[9:2] ] = NextState;
		end
		else begin
			commit = 0;
			rollback = 0;
			rollbackPC = 0;
		end
		if (predict && !update) begin	// insert the prediction we made, branchPC, rollbackPC to BFA, the prediction we made to BFA			
			CurState = BHT[ branchPC[9:2] ];
			if (!BFA[67]) begin // the buffer is empty
				stall = 0;
				prediction = CurState[1]; // CurState[1] == 1 for taken, taken2 states.
				BFA = { 1'b1, prediction, 2'b00, branchPC, (prediction ? notTakenPC : takenPC) }; 
			end
			else begin // the buffer is full, stall
				stall = 1;
			end
		end
		else begin
			prediction = 1'bx;  
		end
	end


end

assign predictedPC = (prediction) ? takenPC : notTakenPC;

endmodule