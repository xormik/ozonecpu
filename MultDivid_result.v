
module MultDivid_result(op, signedOp,  multiplierDividen, resultOfAdd, clk, init_we,
			productOut, WE, WE_sub,  shift, shift_type, answer); 

	input signedOp, op;
	
	input [33:0] multiplierDividen; 	//initial value to put into right side of register
	input [33:0] resultOfAdd; 			//value coming from the adder...why 33 bits?
	input init_we; 						//initial write enable--used to put multiplicand into right side of register
	input clk; 								//clock
	input WE; 								//write enable signal for register

	input WE_sub; 							//writing the result of subtraction into 
	input [1:0] shift_type; 			//signal to indicate a need to shift right for two bits 
	input shift; 							//signal to indicate a need to shift
	
	output [33:0] productOut; 			//top 34 bits to be sent to the adder
	output [67:0] answer; 				//final answer



	//control signals for: shift right two bits, shift left only, shift left and padd with a 0, .. with a 1
	parameter shiftRight = 2'b00, shiftLeftRestore = 2'b01,  shiftLeft0 = 2'b10, shiftLeft1 = 2'b11;


   

   //My code goese and everywhere
   reg [67:0] answer; //two top bits




   assign productOut = answer[67:34];
 
   always @ (posedge clk)
	begin
		if (init_we)
			begin
				//right_bit_store <= 0;
				if (op && signedOp) 
				begin		  //signedOp mult
					if (multiplierDividen[31] == 0) //
						answer <= {34'h000000000, multiplierDividen};
					else		  				  //	changed this, used to be 32'h0, 2'b11
						answer <= {34'h000000000, multiplierDividen};
				end
				else
					answer <= {34 'h000000000, multiplierDividen};
			end
		else if (shift && ~WE_sub &&WE) 
		begin
			//$display("SHIFTING");
			if (shift_type == shiftRight)	begin
				answer <= {resultOfAdd[33],resultOfAdd[33], resultOfAdd[33:0], answer[33:2]};
			//	$display("Shifting right: ");
			end
			else if (shift_type == shiftLeft0 )
				answer <= {answer[66:0], 1'b0};
			else if (shift_type == shiftLeftRestore)	begin
				answer <= {resultOfAdd[32:0], answer[33:0], 1'b0};
				//$display("padding with 0");
				end
			else if (shift_type == shiftLeft1)	begin
				answer <= {answer[66:0], 1'b1};
				//$display("=====padding with 1");
				end
		end
		else if (WE_sub && ~shift && WE)	  begin
			//isplay("just subtracting, no shifting");
			answer <= {resultOfAdd[33:0], answer[33:0]};
			end
		else begin
			answer <= answer;
			//$display("else case not doing shit");
			//right_bit_store <= answer[1]; 
			end
	end
  
endmodule

			/*
			else if (shift_one && WE)
			answer <= {resultOfAdd, answer[31:1]};
		else if (shift_one) // Note this covers two cases: WE = 0 and WE = x (initial loop)
			answer <= answer  1; 
			*/