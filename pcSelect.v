module pcSelect(branchIssue, rollback, clk, rst, branchOp, Qj, Qk, sel);

	input branchIssue, rollback;
	input clk, rst;
	input [1:0] branchOp;	// jr: 2'b10
						// jal: 2'b01
						// j: 2'b11
	input [4:0] Qj, Qk;
	output [1:0] sel;	// 00 not branching
					// 01 branching w/ prediction
					// 10 branch w/ no data dependency
					// 11 branch res station
	reg [1:0] sel;

	wire rollback_dout;
	register #(1) rollback_reg(.DIN(rollback), 
   				    .DOUT(rollback_dout),
				    .WE(1'b1),
				    .CLK(clk),
				    .RST(rst));

	always @ (branchIssue or Qj or Qk or branchOp or rollback or rollback_dout) begin
	if (rollback)	   										// ?? from reservation station
		sel = 2'b11;
	else if (rollback_dout) // unconditionally use PC+4 the cycle after rollback
		sel = 2'b00;
	else if (!branchIssue & !(branchOp == 2'b01 || branchOp == 2'b10 || branchOp == 2'b11))	// no branching
		sel = 2'b00;
	else if (Qj || Qk)										// branch with prediction
		sel = 2'b01;
	else if (!Qj && !Qk)									// branch w/ no data dependency
		sel = 2'b10;
	else sel = 2'b00; 
	end

endmodule
