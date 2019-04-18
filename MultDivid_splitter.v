module MultDivid_splitter(in0, op, neg, hi,lo);
	 input op, neg; 
    input [67:0] in0;
    output [31:0] hi;
    output [31:0] lo;

    //assign hi = (~op)? (in0[65:34] >> 1) : in0[65:34]; 
    assign hi = (~op)? (in0[65:34] >> 1) : in0[63:32]; 
    assign lo = (~op && neg)? (~in0[31:0]+ 1) : in0[31:0]; //take the inverse if its coming from a negated div operation

endmodule
