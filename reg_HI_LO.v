module reg_HI_LO(RegWrite, WriteData, ReadRegister, clk, rst, ReadData, writeReg);
	input RegWrite;		// we always write to both HI and LO at the same time
	input [63:0] WriteData;
	input ReadRegister;		// HI = 0   LO = 1
	input clk;
	input rst;
     input writeReg;	// if 1, then write to HI LO, if 0, do nothing
 

	output [31:0] ReadData;

	wire [31:0] regOutHI;
	wire [31:0] regOutLO;

     // only write to HI LO if regWrite==1 && dest reg is 6'b100000

	register #(32) regHI(.CLK(clk),.RST(rst),.WE(RegWrite & writeReg),.DIN(WriteData[63:32]),.DOUT(regOutHI));
	register #(32) regLO(.CLK(clk),.RST(rst),.WE(RegWrite & writeReg),.DIN(WriteData[31:0]),.DOUT(regOutLO));

	assign ReadData = (ReadRegister) ? regOutLO : regOutHI;

endmodule
