// register result status
// Basic Operations>
//   Reading a value:
//   Writing a value: 

module reg_status(issue, issued_to, dest_reg_no, j_reg_no, k_reg_no, 
				result_wr, result_wr_reg_no, clk, rst, 
				j_status, k_status, result_wr_status, flush);

     input clk;
	input rst;
	input flush;
	
	// write-enable signals
	input issue;			// asserted for one cycle during issue
     input result_wr;	 	// asserted as result is being written from rob to regfile	

     // writing signals	
	input [5:0] dest_reg_no;	// destination register number of instruction being issued RegisterStat[rd]
	input [4:0] issued_to;	// slot being issued to (ROB entry)
	input [5:0] result_wr_reg_no; // register number of register in regfile being written
	
	// reading signals
	input [5:0] j_reg_no;	// register j of instruction being issued    RegisterStat[rs]
						// j_reg_no is 6 bits because it can also be 6'd32 for HI/LO
	input [4:0] k_reg_no;	// register k of instruction being issued	RegisterStat[rt]
	
	output [4:0] j_status;	// RegisterStat[rs].Reorder	
	output [4:0] k_status;	// RegisterStat[rt].Reorder
	output [4:0] result_wr_status; // for commit

	parameter in_regfile = 5'h0;

	// status is now 5 bits, representing the 31 ROB slots
	wire [4:0] status1, status2, status3, status4, status5, status6, status7, status8, status9, status10,
		status11, status12, status13, status14, status15, status16, status17, status18, status19, status20,
		status21, status22, status23, status24, status25, status26, status27, status28, status29, status30, 
		status31, statusHILO;							   

	//                      .DIN = 0 (not busy) || ROB entry 								 WE if issue || commit
	register #(5) reg1 (.DIN((issue & dest_reg_no == 1) ? issued_to : in_regfile), .DOUT(status1), .WE((issue & dest_reg_no == 1) | (result_wr & result_wr_reg_no == 1)), .CLK(clk), .RST(rst | flush));
	register #(5) reg2 (.DIN((issue & dest_reg_no == 2) ? issued_to : in_regfile), .DOUT(status2), .WE((issue & dest_reg_no == 2) | (result_wr & result_wr_reg_no == 2)), .CLK(clk), .RST(rst | flush));
	register #(5) reg3 (.DIN((issue & dest_reg_no == 3) ? issued_to : in_regfile), .DOUT(status3), .WE((issue & dest_reg_no == 3) | (result_wr & result_wr_reg_no == 3)), .CLK(clk), .RST(rst | flush));
	register #(5) reg4 (.DIN((issue & dest_reg_no == 4) ? issued_to : in_regfile), .DOUT(status4), .WE((issue & dest_reg_no == 4) | (result_wr & result_wr_reg_no == 4)), .CLK(clk), .RST(rst | flush));
	register #(5) reg5 (.DIN((issue & dest_reg_no == 5) ? issued_to : in_regfile), .DOUT(status5), .WE((issue & dest_reg_no == 5) | (result_wr & result_wr_reg_no == 5)), .CLK(clk), .RST(rst | flush));
	register #(5) reg6 (.DIN((issue & dest_reg_no == 6) ? issued_to : in_regfile), .DOUT(status6), .WE((issue & dest_reg_no == 6) | (result_wr & result_wr_reg_no == 6)), .CLK(clk), .RST(rst | flush));
	register #(5) reg7 (.DIN((issue & dest_reg_no == 7) ? issued_to : in_regfile), .DOUT(status7), .WE((issue & dest_reg_no == 7) | (result_wr & result_wr_reg_no == 7)), .CLK(clk), .RST(rst | flush));
	register #(5) reg8 (.DIN((issue & dest_reg_no == 8) ? issued_to : in_regfile), .DOUT(status8), .WE((issue & dest_reg_no == 8) | (result_wr & result_wr_reg_no == 8)), .CLK(clk), .RST(rst | flush));
	register #(5) reg9 (.DIN((issue & dest_reg_no == 9) ? issued_to : in_regfile), .DOUT(status9), .WE((issue & dest_reg_no == 9) | (result_wr & result_wr_reg_no == 9)), .CLK(clk), .RST(rst | flush));
	register #(5) reg10 (.DIN((issue & dest_reg_no == 10) ? issued_to : in_regfile), .DOUT(status10), .WE((issue & dest_reg_no == 10) | (result_wr & result_wr_reg_no == 10)), .CLK(clk), .RST(rst | flush));
	register #(5) reg11 (.DIN((issue & dest_reg_no == 11) ? issued_to : in_regfile), .DOUT(status11), .WE((issue & dest_reg_no == 11) | (result_wr & result_wr_reg_no == 11)), .CLK(clk), .RST(rst | flush));
	register #(5) reg12 (.DIN((issue & dest_reg_no == 12) ? issued_to : in_regfile), .DOUT(status12), .WE((issue & dest_reg_no == 12) | (result_wr & result_wr_reg_no == 12)), .CLK(clk), .RST(rst | flush));
	register #(5) reg13 (.DIN((issue & dest_reg_no == 13) ? issued_to : in_regfile), .DOUT(status13), .WE((issue & dest_reg_no == 13) | (result_wr & result_wr_reg_no == 13)), .CLK(clk), .RST(rst | flush));
	register #(5) reg14 (.DIN((issue & dest_reg_no == 14) ? issued_to : in_regfile), .DOUT(status14), .WE((issue & dest_reg_no == 14) | (result_wr & result_wr_reg_no == 14)), .CLK(clk), .RST(rst | flush));
	register #(5) reg15 (.DIN((issue & dest_reg_no == 15) ? issued_to : in_regfile), .DOUT(status15), .WE((issue & dest_reg_no == 15) | (result_wr & result_wr_reg_no == 15)), .CLK(clk), .RST(rst | flush));
	register #(5) reg16 (.DIN((issue & dest_reg_no == 16) ? issued_to : in_regfile), .DOUT(status16), .WE((issue & dest_reg_no == 16) | (result_wr & result_wr_reg_no == 16)), .CLK(clk), .RST(rst | flush));
	register #(5) reg17 (.DIN((issue & dest_reg_no == 17) ? issued_to : in_regfile), .DOUT(status17), .WE((issue & dest_reg_no == 17) | (result_wr & result_wr_reg_no == 17)), .CLK(clk), .RST(rst | flush));
	register #(5) reg18 (.DIN((issue & dest_reg_no == 18) ? issued_to : in_regfile), .DOUT(status18), .WE((issue & dest_reg_no == 18) | (result_wr & result_wr_reg_no == 18)), .CLK(clk), .RST(rst | flush));
	register #(5) reg19 (.DIN((issue & dest_reg_no == 19) ? issued_to : in_regfile), .DOUT(status19), .WE((issue & dest_reg_no == 19) | (result_wr & result_wr_reg_no == 19)), .CLK(clk), .RST(rst | flush));
	register #(5) reg20 (.DIN((issue & dest_reg_no == 20) ? issued_to : in_regfile), .DOUT(status20), .WE((issue & dest_reg_no == 20) | (result_wr & result_wr_reg_no == 20)), .CLK(clk), .RST(rst | flush));
	register #(5) reg21 (.DIN((issue & dest_reg_no == 21) ? issued_to : in_regfile), .DOUT(status21), .WE((issue & dest_reg_no == 21) | (result_wr & result_wr_reg_no == 21)), .CLK(clk), .RST(rst | flush));
	register #(5) reg22 (.DIN((issue & dest_reg_no == 22) ? issued_to : in_regfile), .DOUT(status22), .WE((issue & dest_reg_no == 22) | (result_wr & result_wr_reg_no == 22)), .CLK(clk), .RST(rst | flush));
	register #(5) reg23 (.DIN((issue & dest_reg_no == 23) ? issued_to : in_regfile), .DOUT(status23), .WE((issue & dest_reg_no == 23) | (result_wr & result_wr_reg_no == 23)), .CLK(clk), .RST(rst | flush));
	register #(5) reg24 (.DIN((issue & dest_reg_no == 24) ? issued_to : in_regfile), .DOUT(status24), .WE((issue & dest_reg_no == 24) | (result_wr & result_wr_reg_no == 24)), .CLK(clk), .RST(rst | flush));
	register #(5) reg25 (.DIN((issue & dest_reg_no == 25) ? issued_to : in_regfile), .DOUT(status25), .WE((issue & dest_reg_no == 25) | (result_wr & result_wr_reg_no == 25)), .CLK(clk), .RST(rst | flush));
	register #(5) reg26 (.DIN((issue & dest_reg_no == 26) ? issued_to : in_regfile), .DOUT(status26), .WE((issue & dest_reg_no == 26) | (result_wr & result_wr_reg_no == 26)), .CLK(clk), .RST(rst | flush));
	register #(5) reg27 (.DIN((issue & dest_reg_no == 27) ? issued_to : in_regfile), .DOUT(status27), .WE((issue & dest_reg_no == 27) | (result_wr & result_wr_reg_no == 27)), .CLK(clk), .RST(rst | flush));
	register #(5) reg28 (.DIN((issue & dest_reg_no == 28) ? issued_to : in_regfile), .DOUT(status28), .WE((issue & dest_reg_no == 28) | (result_wr & result_wr_reg_no == 28)), .CLK(clk), .RST(rst | flush));
	register #(5) reg29 (.DIN((issue & dest_reg_no == 29) ? issued_to : in_regfile), .DOUT(status29), .WE((issue & dest_reg_no == 29) | (result_wr & result_wr_reg_no == 29)), .CLK(clk), .RST(rst | flush));
	register #(5) reg30 (.DIN((issue & dest_reg_no == 30) ? issued_to : in_regfile), .DOUT(status30), .WE((issue & dest_reg_no == 30) | (result_wr & result_wr_reg_no == 30)), .CLK(clk), .RST(rst | flush));
	register #(5) reg31 (.DIN((issue & dest_reg_no == 31) ? issued_to : in_regfile), .DOUT(status31), .WE((issue & dest_reg_no == 31) | (result_wr & result_wr_reg_no == 31)), .CLK(clk), .RST(rst | flush));
	register #(5) regHILO (.DIN((issue & dest_reg_no == 32) ? issued_to : in_regfile), .DOUT(statusHILO), .WE((issue & dest_reg_no == 32) | (result_wr & result_wr_reg_no == 32)), .CLK(clk), .RST(rst | flush));


	reg [4:0] j_status, k_status, result_wr_status;

	always @ (status1 or status2 or status3 or status4 or status5 or status6 or status7 or status8 or 
			status9 or status10 or status11 or status12 or status13 or status14 or status15 or status16 or 
			status17 or status18 or status19 or status20 or status21 or status22 or status23 or status24 or
			status25 or status26 or status27 or status28 or status29 or status30 or status31 or statusHILO or
			j_reg_no or k_reg_no or result_wr_reg_no)
	  begin
		case (j_reg_no)
		0: j_status <= in_regfile;
		1: j_status <= status1;
		2: j_status <= status2;
		3: j_status <= status3;
		4: j_status <= status4;
		5: j_status <= status5;
		6: j_status <= status6;
		7: j_status <= status7;
		8: j_status <= status8;
		9: j_status <= status9;
		10: j_status <= status10;
		11: j_status <= status11;
		12: j_status <= status12;
		13: j_status <= status13;
		14: j_status <= status14;
		15: j_status <= status15;
		16: j_status <= status16;
		17: j_status <= status17;
		18: j_status <= status18;
		19: j_status <= status19;
		20: j_status <= status20;
		21: j_status <= status21;
		22: j_status <= status22;
		23: j_status <= status23;
		24: j_status <= status24;
		25: j_status <= status25;
		26: j_status <= status26;
		27: j_status <= status27;
		28: j_status <= status28;
		29: j_status <= status29;
		30: j_status <= status30;
		31: j_status <= status31;
		32: j_status <= statusHILO;
		default: j_status <= 0;
	  	endcase

		case (k_reg_no)
		0: k_status <= in_regfile;
		1: k_status <= status1;
		2: k_status <= status2;
		3: k_status <= status3;
		4: k_status <= status4;
		5: k_status <= status5;
		6: k_status <= status6;
		7: k_status <= status7;
		8: k_status <= status8;
		9: k_status <= status9;
		10: k_status <= status10;
		11: k_status <= status11;
		12: k_status <= status12;
		13: k_status <= status13;
		14: k_status <= status14;
		15: k_status <= status15;
		16: k_status <= status16;
		17: k_status <= status17;
		18: k_status <= status18;
		19: k_status <= status19;
		20: k_status <= status20;
		21: k_status <= status21;
		22: k_status <= status22;
		23: k_status <= status23;
		24: k_status <= status24;
		25: k_status <= status25;
		26: k_status <= status26;
		27: k_status <= status27;
		28: k_status <= status28;
		29: k_status <= status29;
		30: k_status <= status30;
		31: k_status <= status31;
	  	endcase

		case (result_wr_reg_no)
		0: result_wr_status <= in_regfile;
		1: result_wr_status <= status1;
		2: result_wr_status <= status2;
		3: result_wr_status <= status3;
		4: result_wr_status <= status4;
		5: result_wr_status <= status5;
		6: result_wr_status <= status6;
		7: result_wr_status <= status7;
		8: result_wr_status <= status8;
		9: result_wr_status <= status9;
		10: result_wr_status <= status10;
		11: result_wr_status <= status11;
		12: result_wr_status <= status12;
		13: result_wr_status <= status13;
		14: result_wr_status <= status14;
		15: result_wr_status <= status15;
		16: result_wr_status <= status16;
		17: result_wr_status <= status17;
		18: result_wr_status <= status18;
		19: result_wr_status <= status19;
		20: result_wr_status <= status20;
		21: result_wr_status <= status21;
		22: result_wr_status <= status22;
		23: result_wr_status <= status23;
		24: result_wr_status <= status24;
		25: result_wr_status <= status25;
		26: result_wr_status <= status26;
		27: result_wr_status <= status27;
		28: result_wr_status <= status28;
		29: result_wr_status <= status29;
		30: result_wr_status <= status30;
		31: result_wr_status <= status31;
		32: result_wr_status <= statusHILO;
		default: result_wr_status <= 0;
	  	endcase

	  end

endmodule
