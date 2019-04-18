module regfile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, clk, rst, ReadData1, ReadData2);
	input [4:0] ReadRegister1;
	input [4:0] ReadRegister2;
	input [4:0] WriteRegister;
	input [31:0] WriteData;
	input RegWrite, clk, rst;
	output [31:0] ReadData1;
	output [31:0] ReadData2;
					 
	reg [31:0] ReadData1;
	reg [31:0] ReadData2;

	wire [31:0] regOut0;
	wire [31:0] regOut1;
	wire [31:0] regOut2;
	wire [31:0] regOut3;
	wire [31:0] regOut4;
	wire [31:0] regOut5;
	wire [31:0] regOut6;
	wire [31:0] regOut7;
	wire [31:0] regOut8;
	wire [31:0] regOut9;
	wire [31:0] regOut10;
	wire [31:0] regOut11;
	wire [31:0] regOut12;
	wire [31:0] regOut13;
	wire [31:0] regOut14;
	wire [31:0] regOut15;
	wire [31:0] regOut16;
	wire [31:0] regOut17;
	wire [31:0] regOut18;
	wire [31:0] regOut19;
	wire [31:0] regOut20;
	wire [31:0] regOut21;
	wire [31:0] regOut22;
	wire [31:0] regOut23;
	wire [31:0] regOut24;
	wire [31:0] regOut25;
	wire [31:0] regOut26;
	wire [31:0] regOut27;
	wire [31:0] regOut28;
	wire [31:0] regOut29;
	wire [31:0] regOut30;
	wire [31:0] regOut31;

	register #(32) reg0(.CLK(clk),.RST(1'b1),.WE(1'b0),.DIN(WriteData),.DOUT(regOut0));
	register #(32) reg1(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 1),.DIN(WriteData),.DOUT(regOut1));
	register #(32) reg2(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 2),.DIN(WriteData),.DOUT(regOut2));
	register #(32) reg3(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 3),.DIN(WriteData),.DOUT(regOut3));
	register #(32) reg4(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 4),.DIN(WriteData),.DOUT(regOut4));
	register #(32) reg5(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 5),.DIN(WriteData),.DOUT(regOut5));
	register #(32) reg6(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 6),.DIN(WriteData),.DOUT(regOut6));
	register #(32) reg7(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 7),.DIN(WriteData),.DOUT(regOut7));
	register #(32) reg8(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 8),.DIN(WriteData),.DOUT(regOut8));
	register #(32) reg9(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 9),.DIN(WriteData),.DOUT(regOut9));
	register #(32) reg10(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 10),.DIN(WriteData),.DOUT(regOut10));
	register #(32) reg11(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 11),.DIN(WriteData),.DOUT(regOut11));
	register #(32) reg12(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 12),.DIN(WriteData),.DOUT(regOut12));
	register #(32) reg13(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 13),.DIN(WriteData),.DOUT(regOut13));
	register #(32) reg14(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 14),.DIN(WriteData),.DOUT(regOut14));
	register #(32) reg15(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 15),.DIN(WriteData),.DOUT(regOut15));
	register #(32) reg16(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 16),.DIN(WriteData),.DOUT(regOut16));
	register #(32) reg17(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 17),.DIN(WriteData),.DOUT(regOut17));
	register #(32) reg18(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 18),.DIN(WriteData),.DOUT(regOut18));
	register #(32) reg19(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 19),.DIN(WriteData),.DOUT(regOut19));
	register #(32) reg20(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 20),.DIN(WriteData),.DOUT(regOut20));
	register #(32) reg21(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 21),.DIN(WriteData),.DOUT(regOut21));
	register #(32) reg22(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 22),.DIN(WriteData),.DOUT(regOut22));
	register #(32) reg23(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 23),.DIN(WriteData),.DOUT(regOut23));
	register #(32) reg24(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 24),.DIN(WriteData),.DOUT(regOut24));
	register #(32) reg25(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 25),.DIN(WriteData),.DOUT(regOut25));
	register #(32) reg26(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 26),.DIN(WriteData),.DOUT(regOut26));
	register #(32) reg27(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 27),.DIN(WriteData),.DOUT(regOut27));
	register #(32) reg28(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 28),.DIN(WriteData),.DOUT(regOut28));
	register #(32) reg29(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 29),.DIN(WriteData),.DOUT(regOut29));
	register #(32) reg30(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 30),.DIN(WriteData),.DOUT(regOut30));
	register #(32) reg31(.CLK(clk),.RST(rst),.WE(RegWrite && WriteRegister == 31),.DIN(WriteData),.DOUT(regOut31));

	always @ (ReadRegister1 or ReadRegister2 or 
			regOut0 or regOut1 or regOut2 or regOut3 or regOut4 or regOut5 or regOut6 or
			regOut7 or regOut8 or regOut9 or regOut10 or regOut11 or regOut12 or regOut13 or
			regOut14 or regOut15 or regOut16 or regOut17 or regOut18 or regOut19 or regOut20 or
			regOut21 or regOut22 or regOut23 or regOut24 or regOut25 or regOut26 or regOut27 or
			regOut28 or regOut29 or regOut30 or regOut31)
	  begin
	    case (ReadRegister1)
	    5'd0: ReadData1 <= regOut0;
	    5'd1: ReadData1 <= regOut1;
	    5'd2: ReadData1 <= regOut2;
	    5'd3: ReadData1 <= regOut3;
	    5'd4: ReadData1 <= regOut4;
	    5'd5: ReadData1 <= regOut5;
	    5'd6: ReadData1 <= regOut6;
	    5'd7: ReadData1 <= regOut7;
	    5'd8: ReadData1 <= regOut8;
	    5'd9: ReadData1 <= regOut9;
	    5'd10: ReadData1 <= regOut10;
	    5'd11: ReadData1 <= regOut11;
	    5'd12: ReadData1 <= regOut12;
	    5'd13: ReadData1 <= regOut13;
	    5'd14: ReadData1 <= regOut14;
	    5'd15: ReadData1 <= regOut15;
	    5'd16: ReadData1 <= regOut16;
	    5'd17: ReadData1 <= regOut17;
	    5'd18: ReadData1 <= regOut18;
	    5'd19: ReadData1 <= regOut19;
	    5'd20: ReadData1 <= regOut20;
	    5'd21: ReadData1 <= regOut21;
	    5'd22: ReadData1 <= regOut22;
	    5'd23: ReadData1 <= regOut23;
	    5'd24: ReadData1 <= regOut24;
	    5'd25: ReadData1 <= regOut25;
	    5'd26: ReadData1 <= regOut26;
	    5'd27: ReadData1 <= regOut27;
	    5'd28: ReadData1 <= regOut28;
	    5'd29: ReadData1 <= regOut29;
	    5'd30: ReadData1 <= regOut30;
	    5'd31: ReadData1 <= regOut31;
	    endcase

	    case (ReadRegister2)
	    5'd0: ReadData2 <= regOut0;
	    5'd1: ReadData2 <= regOut1;
	    5'd2: ReadData2 <= regOut2;
	    5'd3: ReadData2 <= regOut3;
	    5'd4: ReadData2 <= regOut4;
	    5'd5: ReadData2 <= regOut5;
	    5'd6: ReadData2 <= regOut6;
	    5'd7: ReadData2 <= regOut7;
	    5'd8: ReadData2 <= regOut8;
	    5'd9: ReadData2 <= regOut9;
	    5'd10: ReadData2 <= regOut10;
	    5'd11: ReadData2 <= regOut11;
	    5'd12: ReadData2 <= regOut12;
	    5'd13: ReadData2 <= regOut13;
	    5'd14: ReadData2 <= regOut14;
	    5'd15: ReadData2 <= regOut15;
	    5'd16: ReadData2 <= regOut16;
	    5'd17: ReadData2 <= regOut17;
	    5'd18: ReadData2 <= regOut18;
	    5'd19: ReadData2 <= regOut19;
	    5'd20: ReadData2 <= regOut20;
	    5'd21: ReadData2 <= regOut21;
	    5'd22: ReadData2 <= regOut22;
	    5'd23: ReadData2 <= regOut23;
	    5'd24: ReadData2 <= regOut24;
	    5'd25: ReadData2 <= regOut25;
	    5'd26: ReadData2 <= regOut26;
	    5'd27: ReadData2 <= regOut27;
	    5'd28: ReadData2 <= regOut28;
	    5'd29: ReadData2 <= regOut29;
	    5'd30: ReadData2 <= regOut30;
	    5'd31: ReadData2 <= regOut31;
	    endcase
	  end

endmodule