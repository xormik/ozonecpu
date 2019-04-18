//------------------------------------------------------------------
//-- Verilog Model of MIPS ALU, "alu.v"
//-- 	by Ben Liao
//--    modified by Jack Kang
//--	Fall 2003 Computer Science 152
//--
//-- The ALU operates on two 32-bit quantities and outputs a 32-bit
//-- result plus the condition codes carry, zero, negative.
//--
//-- The functions implemented by the alu are:
//--		ADD  (condition codes always set) - FSEL = 000
//--		AND  (condition codes always set) - FSEL = 001
//--		OR   (condition codes always set) - FSEL = 010
//--		XOR  (condition codes always set) - FSEL = 011
//--		SUB  (condition codes always set) - FSEL = 100
//--		
//-------------------------------------------------------------------


//timing delay is 1ns, accuracy is 1ps
`timescale 1ns / 1ps

module alu(A, B,	//input vectors(31:0)
     	   DOUT,      	//output vectors(31:0)
     	   FSEL,      	//input function select(2:0)
     	   COUT,   	//output carry out
	   ZERO,	//output if alu out is zero	
     	   NEG,		//output if alu out is negative
     	   OVF		//output indicating overflow
     	   );
//-------------Input Signals---------------------------
input [31:0] 	A;
input [31:0] 	B;
input [2:0] 	FSEL;
     
//-------------Output Signals--------------------------
output [31:0]   DOUT;
output 		COUT;
output		ZERO;
output		NEG;
output		OVF;

//-------------Port Declarations-----------------------
reg  [31:0]	DOUT;
reg 		COUT;
reg		ZERO;
reg		NEG;
reg		OVF;	
		
//-------------Parameter Declarations------------------
parameter 	debugging = 0;
//a parameter like this makes it easy to switch back and forth between debugging modes.

always @(FSEL or A or B)
begin
	case (FSEL)
		0 : //ADD
			begin
				{COUT, DOUT} =  A+B;
				ZERO = (DOUT == 0)? 1:0;
				NEG = DOUT[31];
				OVF = (((A[31] == 0) && (B[31] == 0) && (DOUT[31] == 1)) ||
						((A[31] == 1) && (B[31] == 1) && (DOUT[31] == 0)))?
						1:0;
				if (debugging == 1) $display("%d ADD %d = %d", A, B, DOUT);
			end
		1 : //AND
			begin
				DOUT = A&B;
				COUT = 0;
				ZERO = (DOUT == 0)? 1:0;
				NEG = DOUT[31];
				OVF = 0;
				if (debugging == 1) $display("%d AND %d = %d", A, B, DOUT);
			end
		2 : //OR
			begin
				DOUT = A|B;
				COUT = 0;
				ZERO = (DOUT == 0)? 1:0;
				NEG = DOUT[31];
				OVF = 0;
				if (debugging == 1) $display("%d OR %d = %d", A, B, DOUT);
			end
		3 : //XOR
			begin
				DOUT = A^B;
				COUT = 0;
				ZERO = (DOUT == 0)? 1:0;
				NEG = DOUT[31];
				OVF = 0;
				if (debugging == 1) $display("%d XOR %d = %d", A, B, DOUT);
			end
		4 : //SUB
			begin
				{COUT, DOUT} = A-B;
				ZERO = (DOUT == 0)? 1:0;
				NEG = DOUT[31];
				OVF = (((A[31] == 1) && (B[31] == 0) && (DOUT[31] == 0)) ||
						((A[31] == 0) && (B[31] == 1) && (DOUT[31] == 1)))?
						1:0;
				if (debugging == 1) $display("%d SUB %d = %d", A, B, DOUT);
			end
		default : //always having a default case is a good idea!
			begin
				DOUT = 0;
				COUT = 0;
				ZERO = 1;
				NEG = 0;
				OVF = 0;
			end
		endcase
end

endmodule     	  
