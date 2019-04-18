module MultDivid_adder(in0,in1,sum, op);
//1 is adding
//0 is subtracting
	input [33:0] in0; //input value 1
	input [33:0] in1; //input value 2   		
	output [33:0] sum; //output value
	input op;

//Your code here
	assign sum = op? in0 + in1: in0 - in1 ;
endmodule
