// Module: ROB
// Author: Thomas Yiu
// Interfaces with:

// Reorder buffer, whom we affectionately refer to as Rob, serves as 
// an in-order commit unit for out-of-order execution.  He also doubles
// as a write buffer for memory cache.

module rob(clk,rst,issue,addrIN,readyIN,swIN,destIN,CDBIN,CDB_en,commit,
		 loadEntry1,loadEntry2,loadEntry3,loadEntry4,loadEntry5,loadEntry6,loadCurrPtr,loadIsCC,
		 storeAddrBus,storeAddrBus_en,
		 isSpecBranchIN, rollback, isSpecBranchOUT,
		 loadAddrBus,
		 readEntryNo1, readEntryNo1_HIorLO, readValueOUT1, readReadyOUT1,
		 readEntryNo2, readValueOUT2, readReadyOUT2,
		 addrOUT, swOUT, destOUT,valueOUT,readyOUT,loadData,loadDataValid,loadReadyToExe,ROBFull,
		 issue_ptr,commit_ptr, readPredAddr, memio_bit, postBranchDelayEntryValid,
		 mult_kickOut, valueOUT_reg);
	input clk;
	input rst;
	
	input [31:0] addrIN;	// 32-bit byte-addressable (for dmdb_commit)
	input [5:0] destIN; // destination register.  HI/LO is 100000
	input readyIN; // bit will be asserted if instruction did not go through a res station
	input [68:0] CDBIN; // 32-bit valuIN and 5-bit ROB entry tag
	                     // and 32-bit HI
	input swIN; 		// boolean which says if the instruction is an sw 
	input CDB_en;	
	
	input [28:0] loadAddrBus; // 5 bit ROB # + memio + value		
	input [4:0] loadEntry1; // 5 bit ROB #.  From load_buffer
	input [4:0] loadEntry2; 
	input [4:0] loadEntry3; 
	input [4:0] loadEntry4;
	input [4:0] loadEntry5; 
	input [4:0] loadEntry6; 
	input [2:0] loadCurrPtr;  // 1 to 6
	input [6:1] loadIsCC; // tells if each entry is a cycle counter instruction

	input [28:0] storeAddrBus; // 5 bit ROB # + 1 memio bit + 23 bit address.  From store_buffer
	input storeAddrBus_en;
	input isSpecBranchIN; // boolean saying if issuing instruction is a speculative branch 
	input rollback; // flush entire ROB (sent from commit unit)

     // signals to indicate ACTIVE stages
     input issue; // asserted for one cycle at an instruction issue
     input commit; // asserted for one cycle if ready to commit

	input [5:0] mult_kickOut; // comes from mult_res_stations.  we will make an entry
						// valid if it has been kicked out from mult_res_stations

	output [31:0] addrOUT;
	output [22:0] destOUT;
	output [63:0] valueOUT;
	output [31:0] valueOUT_reg;
	output readyOUT;
	output swOUT;
	output memio_bit;
	output postBranchDelayEntryValid;

	output [31:0] loadData;
	output loadDataValid;
	output [6:1] loadReadyToExe; // 1 bit for each reservation station
	output ROBFull;
	output [4:0] issue_ptr;
	output [4:0] commit_ptr;
	output isSpecBranchOUT;

	// Given a readEntryNo, outputs the value, valid bit, and ready bit of that particular entry
	input [4:0] readEntryNo1;
	input readEntryNo1_HIorLO;
	output [31:0] readValueOUT1;
	output readReadyOUT1;
	input [4:0] readEntryNo2;
	output [31:0] readValueOUT2;
	output readReadyOUT2;

	

	wire [4:0] CDBIN_tag;
	wire [31:0] CDBIN_data;
	wire [31:0] CDBIN_HI;
	wire [4:0] storeAddrBus_tag;
	wire storeAddrMemio; // originally bit 31 of address
	wire [22:0] storeAddr;
	wire [4:0] loadAddrBus_tag;
	wire loadAddrMemio; // originally bit 31 of address
	wire [22:0] loadAddr;
	wire mult_kickOut_en;
	assign CDBIN_tag = CDBIN[36:32];
	assign CDBIN_data = CDBIN[31:0];
	assign CDBIN_HI = CDBIN[68:37];
	assign storeAddrBus_tag = storeAddrBus[28:24];
	assign storeAddrMemio = storeAddrBus[23];
	assign storeAddr = storeAddrBus[22:0];
	assign loadAddrBus_tag = loadAddrBus[28:24];
	assign loadAddrMemio = loadAddrBus[23];
	assign loadAddr = loadAddrBus[22:0];
	assign mult_kickOut_en = mult_kickOut[5];

	
	// Main ROB entry FIELDS
	reg [31:0] addr[0:31];	// 32-bit byte-addressable address (for dmdb_commit)
	reg [22:0] dest[0:31];   // either the 5-bit destination register or 23-bit store address
	reg memio[0:31];		// memio bit.  Asserted if storing value to memio
	reg [31:0] value[0:31]; 
	reg [31:0] HI[0:31];
	reg ready[0:31];		// ready field indicates that the instruction has completed
						// execution and the value (value) is ready. 
	
	// Additional ROB entry FIELDS
	reg sw[0:31];
	reg swValueReady[0:31]; // asserted if store value is ready
	reg swAddrReady[0:31]; // asserted if store address is ready
	
	reg valid[0:31]; // valid means the slot currently contains an instruction
	// [0:31]'s are intentional.  do not change

	reg [4:0] issue_ptr; // points at the next slot to issue to
	reg [4:0] commit_ptr; // points at the next slot to commit
	reg [4:0] spec_ptr; // points at speculative branch if exists, 0 if not

	assign destOUT = dest[commit_ptr];
	assign valueOUT = {HI[commit_ptr], value[commit_ptr]};
	assign addrOUT = addr[commit_ptr];
	assign swOUT = sw[commit_ptr];
	assign readyOUT = ready[commit_ptr];

	assign memio_bit = memio[commit_ptr];

	assign ROBFull = (commit_ptr == issue_ptr) & (valid[commit_ptr] == 1); 
	assign isSpecBranchOUT = (spec_ptr == commit_ptr);

     // signals for checking the address of the instruction two instructions away from branch (currently
	// at head of rob)
	output [31:0] readPredAddr;
	wire [4:0] readPredAddr_ptr;
	assign readPredAddr_ptr = (commit_ptr == 5'd31) ? 5'd2 :
	                      (commit_ptr == 5'd30) ? 5'd1 :
	 				  (commit_ptr + 2); 
	
	assign readPredAddr = addr[readPredAddr_ptr]; 
	assign postBranchDelayEntryValid = valid[readPredAddr_ptr];

	// pointer logic block (pTrLoGiCbLk)
	always @ (posedge clk)
	begin
		if (rst)
		  begin
			issue_ptr <= 5'd1;
			commit_ptr <= 5'd1;
			spec_ptr <= 5'd0;
		  end
		else if (rollback)
		  // must occur while current commit_ptr is pointing at speculative branch
		  begin
		  	if (commit_ptr == 31)
				issue_ptr <= (valid[1]) ? 2 : 1;
			else if (commit_ptr == 30)
				issue_ptr <= (valid[31]) ? 1 : 31;
			else
				issue_ptr <= (valid[commit_ptr + 1]) ? (commit_ptr + 2) : (commit_ptr + 1);
			commit_ptr <= (commit_ptr == 5'd31) ? 5'd1 : (commit_ptr + 1); 
			  // so that we commit the branch delay slot
			spec_ptr <= 5'd0;
		  end
		else
		  begin
			if (issue)
				issue_ptr <= (issue_ptr == 5'd31) ? 5'd1 : (issue_ptr + 1);
			
			if (commit) // not else if
				commit_ptr <= (commit_ptr == 5'd31) ? 5'd1 : (commit_ptr + 1);
			
			if (isSpecBranchIN & issue)
				spec_ptr <= issue_ptr;
		  end
	
	end

	// assigning register values
	// 
	//Richard: Can several stages happen at the same time?  i.e. Can we
	// issue and commit in the same stage?  If we don't, it seems like 
	// we're not exploiting ILP.
	always @ (posedge clk)
	  begin
		dest[0] <= 0;
		memio[0] <= 0;
		value[0] <= 0;
		valid[0] <= 0;
		ready[0] <= 0;
		sw[0] <= 0;
		if (rst)
		  begin
			{valid[1], ready[1], dest[1], memio[1], sw[1]} <= 0;
			{valid[2], ready[2], dest[2], memio[2], sw[2]} <= 0;
			{valid[3], ready[3], dest[3], memio[3], sw[3]} <= 0;
			{valid[4], ready[4], dest[4], memio[4], sw[4]} <= 0;
			{valid[5], ready[5], dest[5], memio[5], sw[5]} <= 0;
			{valid[6], ready[6], dest[6], memio[6], sw[6]} <= 0;
			{valid[7], ready[7], dest[7], memio[7], sw[7]} <= 0;
			{valid[8], ready[8], dest[8], memio[8], sw[8]} <= 0;
			{valid[9], ready[9], dest[9], memio[9], sw[9]} <= 0;
			{valid[10], ready[10], dest[10], memio[10], sw[10]} <= 0;
			{valid[11], ready[11], dest[11], memio[11], sw[11]} <= 0;
			{valid[12], ready[12], dest[12], memio[12], sw[12]} <= 0;
			{valid[13], ready[13], dest[13], memio[13], sw[13]} <= 0;
			{valid[14], ready[14], dest[14], memio[14], sw[14]} <= 0;
			{valid[15], ready[15], dest[15], memio[15], sw[15]} <= 0;
			{valid[16], ready[16], dest[16], memio[16], sw[16]} <= 0;
			{valid[17], ready[17], dest[17], memio[17], sw[17]} <= 0;
			{valid[18], ready[18], dest[18], memio[18], sw[18]} <= 0;
			{valid[19], ready[19], dest[19], memio[19], sw[19]} <= 0;
			{valid[20], ready[20], dest[20], memio[20], sw[20]} <= 0;
			{valid[21], ready[21], dest[21], memio[21], sw[21]} <= 0;
			{valid[22], ready[22], dest[22], memio[22], sw[22]} <= 0;
			{valid[23], ready[23], dest[23], memio[23], sw[23]} <= 0;
			{valid[24], ready[24], dest[24], memio[24], sw[24]} <= 0;
			{valid[25], ready[25], dest[25], memio[25], sw[25]} <= 0;
			{valid[26], ready[26], dest[26], memio[26], sw[26]} <= 0;
			{valid[27], ready[27], dest[27], memio[27], sw[27]} <= 0;
			{valid[28], ready[28], dest[28], memio[28], sw[28]} <= 0;
			{valid[29], ready[29], dest[29], memio[29], sw[29]} <= 0;
			{valid[30], ready[30], dest[30], memio[30], sw[30]} <= 0;
			{valid[31], ready[31], dest[31], memio[31], sw[31]} <= 0;
		  end
		else
		  begin 
			if (issue)
			  begin
				addr[issue_ptr] <= addrIN;
				sw[issue_ptr] <= swIN;
				dest[issue_ptr] <= destIN;
				ready[issue_ptr] <= readyIN;
				swAddrReady[issue_ptr] <= 0;
				swValueReady[issue_ptr] <= 0;
				valid[issue_ptr] <= 1;
				
				// if destIN = 0 ($r0, set value[issue_ptr] to 0
				// so we can properly output 0 in dmdb_commit
				if (!destIN) value[issue_ptr] <= 0;
				 
			  end
			if (CDB_en & valid[CDBIN_tag])
			  begin
				value[CDBIN_tag] <= CDBIN_data;
				HI[CDBIN_tag] <= CDBIN_HI;
				ready[CDBIN_tag] <= ~sw[CDBIN_tag] | swAddrReady[CDBIN_tag];
				// set ready to 1 for non-sw's and sw's that have the address ready
				swValueReady[CDBIN_tag] <= 1; // set to one for sw's.  don't care of non-sw's
			  end
			if (storeAddrBus_en & valid[storeAddrBus_tag])
			  begin
				dest[storeAddrBus_tag] <= storeAddr;
				memio[storeAddrBus_tag] <= storeAddrMemio;
				ready[storeAddrBus_tag] <= swValueReady[storeAddrBus_tag];
				swAddrReady[storeAddrBus_tag] <= 1;
				// entire sw instruction is ready if store value is also ready
			  end
			// important that this clause happens after the CDB_en and storeAddrBus_en clauses.
			// happens when both addr and value for the same slot comes in at the same clock cycle
			if (CDB_en & storeAddrBus_en & CDBIN_tag == storeAddrBus_tag & valid[storeAddrBus_tag])
				ready[CDBIN_tag] <= 1;
			if (commit)
			  begin
			  	ready[commit_ptr] <= 0;
				valid[commit_ptr] <= 0;
			  end
			if (mult_kickOut_en)
				ready[mult_kickOut[4:0]] <= 1;
		  end


		if (rollback & ~rst)
		  begin
		     // don't wanna reset branch delay slot upon rollback
		  	if (commit_ptr != 31)
				{valid[1], ready[1], dest[1]} <= 0;
			if (commit_ptr != 1)
				{valid[2], ready[2], dest[2]} <= 0;
			if (commit_ptr != 2)
				{valid[3], ready[3], dest[3]} <= 0;
			if (commit_ptr != 3)
				{valid[4], ready[4], dest[4]} <= 0;
			if (commit_ptr != 4)
				{valid[5], ready[5], dest[5]} <= 0;
			if (commit_ptr != 5)
				{valid[6], ready[6], dest[6]} <= 0;
			if (commit_ptr != 6)
				{valid[7], ready[7], dest[7]} <= 0;
			if (commit_ptr != 7)
				{valid[8], ready[8], dest[8]} <= 0;
			if (commit_ptr != 8)
				{valid[9], ready[9], dest[9]} <= 0;
			if (commit_ptr != 9)
				{valid[10], ready[10], dest[10]} <= 0;
			if (commit_ptr != 10)
				{valid[11], ready[11], dest[11]} <= 0;
			if (commit_ptr != 11)
				{valid[12], ready[12], dest[12]} <= 0;
			if (commit_ptr != 12)
				{valid[13], ready[13], dest[13]} <= 0;
			if (commit_ptr != 13)
				{valid[14], ready[14], dest[14]} <= 0;
			if (commit_ptr != 14)
				{valid[15], ready[15], dest[15]} <= 0;
			if (commit_ptr != 15)
				{valid[16], ready[16], dest[16]} <= 0;
			if (commit_ptr != 16)
				{valid[17], ready[17], dest[17]} <= 0;
			if (commit_ptr != 17)
				{valid[18], ready[18], dest[18]} <= 0;
			if (commit_ptr != 18)
				{valid[19], ready[19], dest[19]} <= 0;
			if (commit_ptr != 19)
				{valid[20], ready[20], dest[20]} <= 0;
			if (commit_ptr != 20)
				{valid[21], ready[21], dest[21]} <= 0;
			if (commit_ptr != 21)
				{valid[22], ready[22], dest[22]} <= 0;
			if (commit_ptr != 22)
				{valid[23], ready[23], dest[23]} <= 0;
			if (commit_ptr != 23)
				{valid[24], ready[24], dest[24]} <= 0;
			if (commit_ptr != 24)
				{valid[25], ready[25], dest[25]} <= 0;
			if (commit_ptr != 25)
				{valid[26], ready[26], dest[26]} <= 0;
			if (commit_ptr != 26)
				{valid[27], ready[27], dest[27]} <= 0;
			if (commit_ptr != 27)
				{valid[28], ready[28], dest[28]} <= 0;
			if (commit_ptr != 28)
				{valid[29], ready[29], dest[29]} <= 0;
			if (commit_ptr != 29)
				{valid[30], ready[30], dest[30]} <= 0;
			if (commit_ptr != 30)
				{valid[31], ready[31], dest[31]} <= 0;
		  end
	  end


	// reading a specified entry's value and valid bit
	reg readValidOUT1;
	reg [31:0] readValueOUT1;
	reg readReadyOUT1;
	always @ (readEntryNo1 or valid[readEntryNo1] or value[readEntryNo1] or HI[readEntryNo1] or
			sw[readEntryNo1] or dest[readEntryNo1] or ready[readEntryNo1] or readEntryNo1_HIorLO)
	  begin
		readValidOUT1 <= valid[readEntryNo1];
		readValueOUT1 <= (~sw[readEntryNo1] & dest[readEntryNo1] == 6'd32 & ~readEntryNo1_HIorLO) ? 
			HI[readEntryNo1] : // output HI iff current issuing instruction is an mfhi
			value[readEntryNo1];
		readReadyOUT1 <= ready[readEntryNo1];
	  end

	reg readValidOUT2;
	reg [31:0] readValueOUT2;
	reg readReadyOUT2;
	always @ (readEntryNo2 or valid[readEntryNo2] or value[readEntryNo2] or ready[readEntryNo2])
	  begin
		readValidOUT2 <= valid[readEntryNo2];
		readValueOUT2 <= value[readEntryNo2];
		readReadyOUT2 <= ready[readEntryNo2];
	  end



	// load word logic

	reg loadDataValid;
	reg [31:0] loadData;


	// entry_before_lw is a boolean indicating if an entry is before a lw instruction.  
	// Used to check to see if a sw is ready before we start executing a lw
	wire [31:0] entry_before_lw1, entry_before_lw2, entry_before_lw3, entry_before_lw4, 
				entry_before_lw5, entry_before_lw6, entry_before_lw_curr;

	check_all_positions check_all_positions1 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry1), .entry_before_lw(entry_before_lw1));
	check_all_positions check_all_positions2 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry2), .entry_before_lw(entry_before_lw2));
	check_all_positions check_all_positions3 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry3), .entry_before_lw(entry_before_lw3));
	check_all_positions check_all_positions4 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry4), .entry_before_lw(entry_before_lw4));
	check_all_positions check_all_positions5 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry5), .entry_before_lw(entry_before_lw5));
	check_all_positions check_all_positions6 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
										.lw_entry(loadEntry6), .entry_before_lw(entry_before_lw6));

	assign entry_before_lw_curr = (loadCurrPtr == 6) ? entry_before_lw6 :
							(loadCurrPtr == 5) ? entry_before_lw5 :
							(loadCurrPtr == 4) ? entry_before_lw4 :
							(loadCurrPtr == 3) ? entry_before_lw3 :
							(loadCurrPtr == 2) ? entry_before_lw2 : entry_before_lw1;



	// loadReadyToExe: asserted if there are no unready store words before the load word we want to execute
	wire [6:1] loadReadyToExe;
	assign loadReadyToExe[1] = 
		(~(valid[1] & sw[1] & entry_before_lw1[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw1[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw1[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw1[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw1[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw1[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw1[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw1[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw1[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw1[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw1[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw1[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw1[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw1[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw1[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw1[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw1[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw1[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw1[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw1[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw1[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw1[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw1[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw1[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw1[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw1[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw1[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw1[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw1[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw1[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw1[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry1] & loadIsCC[1] & commit_ptr != loadEntry1));

	assign loadReadyToExe[2] = 
		(~(valid[1] & sw[1] & entry_before_lw2[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw2[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw2[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw2[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw2[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw2[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw2[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw2[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw2[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw2[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw2[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw2[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw2[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw2[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw2[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw2[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw2[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw2[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw2[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw2[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw2[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw2[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw2[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw2[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw2[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw2[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw2[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw2[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw2[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw2[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw2[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry2] & loadIsCC[2] & commit_ptr != loadEntry2));

	assign loadReadyToExe[3] = 
		(~(valid[1] & sw[1] & entry_before_lw3[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw3[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw3[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw3[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw3[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw3[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw3[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw3[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw3[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw3[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw3[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw3[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw3[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw3[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw3[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw3[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw3[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw3[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw3[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw3[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw3[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw3[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw3[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw3[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw3[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw3[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw3[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw3[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw3[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw3[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw3[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry3] & loadIsCC[3] & commit_ptr != loadEntry3));

	assign loadReadyToExe[4] = 
		(~(valid[1] & sw[1] & entry_before_lw4[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw4[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw4[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw4[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw4[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw4[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw4[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw4[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw4[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw4[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw4[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw4[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw4[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw4[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw4[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw4[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw4[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw4[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw4[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw4[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw4[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw4[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw4[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw4[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw4[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw4[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw4[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw4[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw4[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw4[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw4[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry4] & loadIsCC[4] & commit_ptr != loadEntry4));

	assign loadReadyToExe[5] = 
		(~(valid[1] & sw[1] & entry_before_lw5[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw5[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw5[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw5[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw5[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw5[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw5[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw5[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw5[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw5[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw5[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw5[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw5[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw5[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw5[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw5[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw5[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw5[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw5[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw5[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw5[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw5[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw5[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw5[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw5[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw5[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw5[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw5[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw5[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw5[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw5[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry5] & loadIsCC[5] & commit_ptr != loadEntry5));

	assign loadReadyToExe[6] = 
		(~(valid[1] & sw[1] & entry_before_lw6[1]) | ready[1]) & 
		(~(valid[2] & sw[2] & entry_before_lw6[2]) | ready[2]) & 		
		(~(valid[3] & sw[3] & entry_before_lw6[3]) | ready[3]) & 
		(~(valid[4] & sw[4] & entry_before_lw6[4]) | ready[4]) & 		
		(~(valid[5] & sw[5] & entry_before_lw6[5]) | ready[5]) & 
		(~(valid[6] & sw[6] & entry_before_lw6[6]) | ready[6]) & 		
		(~(valid[7] & sw[7] & entry_before_lw6[7]) | ready[7]) & 
		(~(valid[8] & sw[8] & entry_before_lw6[8] ) | ready[8]) & 		
		(~(valid[9] & sw[9] & entry_before_lw6[9]) | ready[9]) & 
		(~(valid[10] & sw[10] & entry_before_lw6[10]) | ready[10]) & 		
		(~(valid[11] & sw[11] & entry_before_lw6[11]) | ready[11]) & 
		(~(valid[12] & sw[12] & entry_before_lw6[12]) | ready[12]) & 		
		(~(valid[13] & sw[13] & entry_before_lw6[13]) | ready[13]) & 
		(~(valid[14] & sw[14] & entry_before_lw6[14]) | ready[14]) & 		
		(~(valid[15] & sw[15] & entry_before_lw6[15]) | ready[15]) & 
		(~(valid[16] & sw[16] & entry_before_lw6[16]) | ready[16]) & 		
		(~(valid[17] & sw[17] & entry_before_lw6[17]) | ready[17]) & 
		(~(valid[18] & sw[18] & entry_before_lw6[18]) | ready[18]) & 		
		(~(valid[19] & sw[19] & entry_before_lw6[19]) | ready[19]) & 
		(~(valid[20] & sw[20] & entry_before_lw6[20]) | ready[20]) & 		
		(~(valid[21] & sw[21] & entry_before_lw6[21]) | ready[21]) & 
		(~(valid[22] & sw[22] & entry_before_lw6[22]) | ready[22]) & 		
		(~(valid[23] & sw[23] & entry_before_lw6[23]) | ready[23]) & 
		(~(valid[24] & sw[24] & entry_before_lw6[24]) | ready[24]) & 		
		(~(valid[25] & sw[25] & entry_before_lw6[25]) | ready[25]) & 
		(~(valid[26] & sw[26] & entry_before_lw6[26]) | ready[26]) & 		
		(~(valid[27] & sw[27] & entry_before_lw6[27]) | ready[27]) & 
		(~(valid[28] & sw[28] & entry_before_lw6[28]) | ready[28]) & 		
		(~(valid[29] & sw[29] & entry_before_lw6[29]) | ready[29]) & 
		(~(valid[30] & sw[30] & entry_before_lw6[30]) | ready[30]) & 		
		(~(valid[31] & sw[31] & entry_before_lw6[31]) | ready[31]) &
		// special case for cycle counter instructions
		(~(valid[loadEntry6] & loadIsCC[6] & commit_ptr != loadEntry6));


/* moved to block above
	always @ (posedge clk) // these are dummy values.  valid[0] must be 0 though.
	  begin
		dest[0] <= 0;
		memio[0] <= 0;
		value[0] <= 0;
		valid[0] <= 0;
		ready[0] <= 0;
		sw[0] <= 0;
	  end
*/

	wire [4:0] issueMinus1, issueMinus2, issueMinus3, issueMinus4, issueMinus5, issueMinus6, issueMinus7,
			issueMinus8, issueMinus9, issueMinus10, issueMinus11, issueMinus12, issueMinus13, issueMinus14,
			issueMinus15, issueMinus16, issueMinus17, issueMinus18, issueMinus19, issueMinus20, issueMinus21, 
			issueMinus22, issueMinus23, issueMinus24, issueMinus25, issueMinus26, issueMinus27, issueMinus28, 
			issueMinus29, issueMinus30, issueMinus31;
	assign issueMinus1 = issue_ptr - 1;
	assign issueMinus2 = issue_ptr - 2;
	assign issueMinus3 = issue_ptr - 3;
	assign issueMinus4 = issue_ptr - 4;
	assign issueMinus5 = issue_ptr - 5;
	assign issueMinus6 = issue_ptr - 6;
	assign issueMinus7 = issue_ptr - 7;
	assign issueMinus8 = issue_ptr - 8;
	assign issueMinus9 = issue_ptr - 9;
	assign issueMinus10 = issue_ptr - 10;
	assign issueMinus11 = issue_ptr - 11;
	assign issueMinus12 = issue_ptr - 12;
	assign issueMinus13 = issue_ptr - 13;
	assign issueMinus14 = issue_ptr - 14;
	assign issueMinus15 = issue_ptr - 15;
	assign issueMinus16 = issue_ptr - 16;
	assign issueMinus17 = issue_ptr - 17;
	assign issueMinus18 = issue_ptr - 18;
	assign issueMinus19 = issue_ptr - 19;
	assign issueMinus20 = issue_ptr - 20;
	assign issueMinus21 = issue_ptr - 21;
	assign issueMinus22 = issue_ptr - 22;
	assign issueMinus23 = issue_ptr - 23;
	assign issueMinus24 = issue_ptr - 24;
	assign issueMinus25 = issue_ptr - 25;
	assign issueMinus26 = issue_ptr - 26;
	assign issueMinus27 = issue_ptr - 27;
	assign issueMinus28 = issue_ptr - 28;
	assign issueMinus29 = issue_ptr - 29;
	assign issueMinus30 = issue_ptr - 30;
	assign issueMinus31 = issue_ptr - 31;

	always @ (loadAddr or value[0] or value[1] or value[2] or value[3] or value[4] or value[5] or value[6] or
			value[7] or value[8] or value[9] or value[10] or value[11] or value[12] or value[13] or value[14] or 
			value[15] or value[16] or value[17] or value[18] or value[19] or value[20] or value[21] or value[22] or 
			value[23] or value[24] or value[25] or value[26] or value[27] or value[28] or value[29] or value[30] or 
			value[31] or dest[0] or dest[1] or dest[2] or dest[3] or dest[4] or dest[5] or dest[6] or
			dest[7] or dest[8] or dest[9] or dest[10] or dest[11] or dest[12] or dest[13] or dest[14] or 
			dest[15] or dest[16] or dest[17] or dest[18] or dest[19] or dest[20] or dest[21] or dest[22] or 
			dest[23] or dest[24] or dest[25] or dest[26] or dest[27] or dest[28] or dest[29] or dest[30] or 
			dest[31] or ready[0] or ready[1] or ready[2] or ready[3] or ready[4] or ready[5] or ready[6] or 
			ready[7] or ready[8] or ready[9] or ready[10] or ready[11] or ready[12] or ready[13] or ready[14] or 
			ready[15] or ready[16] or ready[17] or ready[18] or ready[19] or ready[20] or ready[21] or ready[22] or 
			ready[23] or ready[24] or ready[25] or ready[26] or ready[27] or ready[28] or ready[29] or 
			ready[30] or ready[31] or valid[0] or valid[1] or valid[2] or valid[3] or valid[4] or valid[5] or 
			valid[6] or valid[7] or valid[8] or valid[9] or valid[10] or valid[11] or valid[12] or valid[13] or 
			valid[14] or valid[15] or valid[16] or valid[17] or valid[18] or valid[19] or valid[20] or valid[21] or 
			valid[22] or valid[23] or valid[24] or valid[25] or valid[26] or valid[27] or valid[28] or valid[29] or 
			valid[30] or valid[31] or issue_ptr or loadAddrMemio or memio[0] or memio[1] or memio[2] or memio[3] or 
			memio[4] or memio[5] or memio[6] or memio[7] or memio[8] or memio[9] or memio[10] or memio[11] or 
			memio[12] or memio[13] or memio[14] or memio[15] or memio[16] or memio[17] or memio[18] or memio[19] or 
			memio[20] or memio[21] or memio[22] or memio[23] or memio[24] or memio[25] or memio[26] or memio[27] or 
			memio[28] or memio[29] or memio[30] or memio[31] or sw[0] or sw[1] or sw[2] or sw[3] or sw[4] or 
			sw[5] or sw[6] or sw[7] or sw[8] or sw[9] or sw[10] or sw[11] or sw[12] or sw[13] or sw[14] or 
			sw[15] or sw[16] or sw[17] or sw[18] or sw[19] or sw[20] or sw[21] or sw[22] or sw[23] or sw[24] 
			or sw[25] or sw[26] or sw[27] or sw[28] or sw[29] or sw[30] or sw[31] or entry_before_lw_curr or
			issueMinus1 or issueMinus2 or issueMinus3 or issueMinus4 or issueMinus5 or issueMinus6 or issueMinus7 or issueMinus8 or 
			issueMinus9 or issueMinus10 or issueMinus11 or issueMinus12 or issueMinus13 or issueMinus14 or issueMinus15 or issueMinus16 or 
			issueMinus17 or issueMinus18 or issueMinus19 or issueMinus20 or issueMinus21 or issueMinus22 or issueMinus23 or issueMinus24 or 
			issueMinus25 or issueMinus26 or issueMinus27 or issueMinus28 or issueMinus29 or issueMinus30 or issueMinus31)
	  begin
		if (valid[issueMinus1] & ready[issueMinus1] & sw[issueMinus1] & dest[issueMinus1] == loadAddr & memio[issueMinus1] == loadAddrMemio & entry_before_lw_curr[issueMinus1])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus1]};
		else if (valid[issueMinus2] & ready[issueMinus2] & sw[issueMinus2] & dest[issueMinus2] == loadAddr & memio[issueMinus2] == loadAddrMemio & entry_before_lw_curr[issueMinus2])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus2]};
		else if (valid[issueMinus3] & ready[issueMinus3] & sw[issueMinus3] & dest[issueMinus3] == loadAddr & memio[issueMinus3] == loadAddrMemio & entry_before_lw_curr[issueMinus3])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus3]};
		else if (valid[issueMinus4] & ready[issueMinus4] & sw[issueMinus4] & dest[issueMinus4] == loadAddr & memio[issueMinus4] == loadAddrMemio & entry_before_lw_curr[issueMinus4])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus4]};
		else if (valid[issueMinus5] & ready[issueMinus5] & sw[issueMinus5] & dest[issueMinus5] == loadAddr & memio[issueMinus5] == loadAddrMemio & entry_before_lw_curr[issueMinus5])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus5]};
		else if (valid[issueMinus6] & ready[issueMinus6] & sw[issueMinus6] & dest[issueMinus6] == loadAddr & memio[issueMinus6] == loadAddrMemio & entry_before_lw_curr[issueMinus6])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus6]};
		else if (valid[issueMinus7] & ready[issueMinus7] & sw[issueMinus7] & dest[issueMinus7] == loadAddr & memio[issueMinus7] == loadAddrMemio & entry_before_lw_curr[issueMinus7])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus7]};
		else if (valid[issueMinus8] & ready[issueMinus8] & sw[issueMinus8] & dest[issueMinus8] == loadAddr & memio[issueMinus8] == loadAddrMemio & entry_before_lw_curr[issueMinus8])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus8]};
		else if (valid[issueMinus9] & ready[issueMinus9] & sw[issueMinus9] & dest[issueMinus9] == loadAddr & memio[issueMinus9] == loadAddrMemio & entry_before_lw_curr[issueMinus9])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus9]};
		else if (valid[issueMinus10] & ready[issueMinus10] & sw[issueMinus10] & dest[issueMinus10] == loadAddr & memio[issueMinus10] == loadAddrMemio & entry_before_lw_curr[issueMinus10])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus10]};
		else if (valid[issueMinus11] & ready[issueMinus11] & sw[issueMinus11] & dest[issueMinus11] == loadAddr & memio[issueMinus11] == loadAddrMemio & entry_before_lw_curr[issueMinus11])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus11]};
		else if (valid[issueMinus12] & ready[issueMinus12] & sw[issueMinus12] & dest[issueMinus12] == loadAddr & memio[issueMinus12] == loadAddrMemio & entry_before_lw_curr[issueMinus12])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus12]};
		else if (valid[issueMinus13] & ready[issueMinus13] & sw[issueMinus13] & dest[issueMinus13] == loadAddr & memio[issueMinus13] == loadAddrMemio & entry_before_lw_curr[issueMinus13])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus13]};
		else if (valid[issueMinus14] & ready[issueMinus14] & sw[issueMinus14] & dest[issueMinus14] == loadAddr & memio[issueMinus14] == loadAddrMemio & entry_before_lw_curr[issueMinus14])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus14]};
		else if (valid[issueMinus15] & ready[issueMinus15] & sw[issueMinus15] & dest[issueMinus15] == loadAddr & memio[issueMinus15] == loadAddrMemio & entry_before_lw_curr[issueMinus15])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus15]};
		else if (valid[issueMinus16] & ready[issueMinus16] & sw[issueMinus16] & dest[issueMinus16] == loadAddr & memio[issueMinus16] == loadAddrMemio & entry_before_lw_curr[issueMinus16])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus16]};
		else if (valid[issueMinus17] & ready[issueMinus17] & sw[issueMinus17] & dest[issueMinus17] == loadAddr & memio[issueMinus17] == loadAddrMemio & entry_before_lw_curr[issueMinus17])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus17]};
		else if (valid[issueMinus18] & ready[issueMinus18] & sw[issueMinus18] & dest[issueMinus18] == loadAddr & memio[issueMinus18] == loadAddrMemio & entry_before_lw_curr[issueMinus18])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus18]};
		else if (valid[issueMinus19] & ready[issueMinus19] & sw[issueMinus19] & dest[issueMinus19] == loadAddr & memio[issueMinus19] == loadAddrMemio & entry_before_lw_curr[issueMinus19])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus19]};
		else if (valid[issueMinus20] & ready[issueMinus20] & sw[issueMinus20] & dest[issueMinus20] == loadAddr & memio[issueMinus20] == loadAddrMemio & entry_before_lw_curr[issueMinus20])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus20]};
		else if (valid[issueMinus21] & ready[issueMinus21] & sw[issueMinus21] & dest[issueMinus21] == loadAddr & memio[issueMinus21] == loadAddrMemio & entry_before_lw_curr[issueMinus21])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus21]};
		else if (valid[issueMinus22] & ready[issueMinus22] & sw[issueMinus22] & dest[issueMinus22] == loadAddr & memio[issueMinus22] == loadAddrMemio & entry_before_lw_curr[issueMinus22])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus22]};
		else if (valid[issueMinus23] & ready[issueMinus23] & sw[issueMinus23] & dest[issueMinus23] == loadAddr & memio[issueMinus23] == loadAddrMemio & entry_before_lw_curr[issueMinus23])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus23]};
		else if (valid[issueMinus24] & ready[issueMinus24] & sw[issueMinus24] & dest[issueMinus24] == loadAddr & memio[issueMinus24] == loadAddrMemio & entry_before_lw_curr[issueMinus24])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus24]};
		else if (valid[issueMinus25] & ready[issueMinus25] & sw[issueMinus25] & dest[issueMinus25] == loadAddr & memio[issueMinus25] == loadAddrMemio & entry_before_lw_curr[issueMinus25])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus25]};
		else if (valid[issueMinus26] & ready[issueMinus26] & sw[issueMinus26] & dest[issueMinus26] == loadAddr & memio[issueMinus26] == loadAddrMemio & entry_before_lw_curr[issueMinus26])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus26]};
		else if (valid[issueMinus27] & ready[issueMinus27] & sw[issueMinus27] & dest[issueMinus27] == loadAddr & memio[issueMinus27] == loadAddrMemio & entry_before_lw_curr[issueMinus27])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus27]};
		else if (valid[issueMinus28] & ready[issueMinus28] & sw[issueMinus28] & dest[issueMinus28] == loadAddr & memio[issueMinus28] == loadAddrMemio & entry_before_lw_curr[issueMinus28])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus28]};
		else if (valid[issueMinus29] & ready[issueMinus29] & sw[issueMinus29] & dest[issueMinus29] == loadAddr & memio[issueMinus29] == loadAddrMemio & entry_before_lw_curr[issueMinus29])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus29]};
		else if (valid[issueMinus30] & ready[issueMinus30] & sw[issueMinus30] & dest[issueMinus30] == loadAddr & memio[issueMinus30] == loadAddrMemio & entry_before_lw_curr[issueMinus30])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus30]};
		else if (valid[issueMinus31] & ready[issueMinus31] & sw[issueMinus31] & dest[issueMinus31] == loadAddr & memio[issueMinus31] == loadAddrMemio & entry_before_lw_curr[issueMinus31])
			{loadDataValid, loadData} <= {1'b1, value[issueMinus31]};
		else if (valid[issue_ptr] & ready[issue_ptr] & sw[issue_ptr] & dest[issue_ptr] == loadAddr & memio[issue_ptr] == loadAddrMemio)
			{loadDataValid, loadData} <= {1'b1, value[issue_ptr]};
		else
			{loadDataValid, loadData} <= {1'b0, 32'h0};		
	  end


	reg [31:0] valueOUT_reg;
	always @ (posedge clk)
	  begin
		valueOUT_reg <= valueOUT[31:0];
	  end
	
endmodule
