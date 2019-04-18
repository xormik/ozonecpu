module slt_block(NEG,OVF,SltType, signInput1, signInput2, result);
    input NEG;
    input OVF;
    input SltType;
    input signInput1, signInput2;
    output [31:0] result;
    reg   [31:0] result;
    // SltType
    // 0: slt/slti
    // 1: sltu/sltiu

	always @ (NEG or OVF or SltType or signInput1 or signInput2 or result)
	begin
	
	if (SltType)
    		begin

		if (signInput1 && ~signInput2)
			result = 32'd0;
		else if (~signInput1 && signInput2)
			result = 32'd1;
		else if (signInput1 && signInput2)
			result = {31'b0, NEG};
		else 
			result = {31'b0, NEG};
		end  
	else
		result = { 31'b0, NEG ^ OVF};
	end

//    assign result = {31'b0, ((SltType) ? NEG : (NEG ^ OVF))};
endmodule