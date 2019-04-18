module MultDivid_controller(op, signedOp, clk, rst, busy,  
			   WE_multiplicand_divider, WE_multiplier_dividen, multiplicand_divider, multiplier_dividen,

			   //feedback signals from result
			   answerMSB,  shift, shift_type	,

			   multiplicand_divider_out, multiplier_dividen_out,  op_out, neg,
			   signed_out, WE_sub, adder_ctr, adder_src,
			   /* negTwoMultiplicand,  negOneMultiplicand ,posTwoMultiplicand ,  */
						   
				productWrite, 
			   );

	//Victor: the Op and the signed signal have to be held constant throughout the entire operation
	input answerMSB;
	input signedOp; //indicating signed or insigned operation, 1 is signed and 0 if o.w.
	input op; //0 whe divid, 1 when mult
	input clk; //clk
	input rst; //after receiving a reset, set the initial values and begin multiplying
	
	input [31:0] multiplicand_divider, multiplier_dividen; 
//values to multiply. This will be an input to your multiplier_dividen. 
//You will hand supply these in your test benches. When you push onto board, these will
//come from the dip switches.

//NOTE: current_right_bits is unused
	
	//input answerMSB;
	
	output WE_multiplicand_divider, WE_multiplier_dividen; 
//initial write enable signals for storing the multiplicand_divider and multiplier_dividen values

	output [33:0] multiplicand_divider_out, multiplier_dividen_out;
//these are the same as the input signals multiplicand_divider and multiplier_dividen. Where do these connect to?

	output neg;				    //telling the result module to take the negative number, if necessary
	output productWrite;
	output  busy; //control signals to product/shift register

	output [1:0] shift_type;
	output shift;

	//output [5:0] count;
	output op_out;
	output signed_out;
	output WE_sub;
	output adder_ctr;
	output [1:0] adder_src; 

	/*
	output negTwoMultiplicand;
	output negOneMultiplicand;
	output posTwoMultiplicand; 
	*/


	/* Control signals
	for the shifting and subrcting of the result 
	register during the iterations */
	reg [1:0] shift_type;
	reg shift;
	reg [6:0] count; //used to count the number of iterations
	reg  neg;
	reg WE_sub;
	reg adder_ctr; 
	reg [1:0] adder_src; 
//Your code here

    	//control signals for: shift right two bits, shift left only, shift left and padd with a 0, .. with a 1
	parameter shiftRight = 2'b00, shiftLeftRestore = 2'b01,  shiftLeft0 = 2'b10, shiftLeft1 = 2'b11;
	parameter add = 1'b1, subtract = 1'b0;
	//parameter posOne = 2'b00, posTwo = 2'b01, negOne = 2'b10, negTwo = 2'b11; 
	parameter zero = 2'b0, one = 2'b01, two = 2'b10; // one times the dividen/mutiplier or two times it

reg [33:0] multiplicand_divider_out, multiplier_dividen_out;
reg WE_multiplicand_divider, WE_multiplier_dividen;



//assign negOneMultiplicand = (~multiplicand_divider + 1);

assign op_out = op;	
assign signed_out = signedOp;

assign productWrite = (count <= 7'd69 && ~op) || (count <= 17 && op) ;
//assign busy = (count <= 69 && ~op ) || (count <= 17 && op);
assign busy = (count <= 7'd69 && ~op ) || (count <= 20 && op);

	//
	//input [3:0] current_right_bits;
wire [2:0] current_right ;
reg [34:0] multiplier_dividen_copy	  ;
assign current_right = multiplier_dividen_copy[2:0]; 

always @ (posedge clk)
	begin
		if (rst == 1)
			begin
				
				count <= 0;
				if (signedOp && ~op) begin  //signed dividing
					//$display("A");
					if (multiplicand_divider[31] && ~multiplier_dividen[31]) 
						begin
							multiplicand_divider_out <= {2'b0, (~multiplicand_divider + 1)} ;//inverting
							multiplier_dividen_out <= {2'b0, multiplier_dividen } ;
							multiplier_dividen_copy <= {2'b0, multiplier_dividen, 1'b0};
							neg <= 1;
						end
					else if  (~multiplicand_divider[31] && multiplier_dividen[31]) 
						begin
							multiplicand_divider_out <={2'b0,  multiplicand_divider};
							multiplier_dividen_out <= {2'b0, (~multiplier_dividen + 1)};
							multiplier_dividen_copy <= {2'b0, (~multiplier_dividen + 1), 1'b0}; //inverting
							neg <=1;
				   	end
					else if  (multiplicand_divider[31] && multiplier_dividen[31]) 
						begin
							multiplicand_divider_out <= {2'b0, (~multiplicand_divider + 1)};
							multiplier_dividen_out   <= {2'b0, (~multiplier_dividen   + 1)}; 
							multiplier_dividen_copy <= {2'b0, (~multiplier_dividen + 1), 1'b0}; 
							//inverting
							$display("multiplicand_divider out = %h",
							{2'b0, (~multiplicand_divider + 1)} );
							$display("multiplier_dividen_out = %h", 
							{2'b0, (~multiplier_dividen   + 1)} );
							 
							neg <=0;
				   	end
					else //either both positive , so ddun matter
						begin
							multiplicand_divider_out <= {2'b0, multiplicand_divider};
							multiplier_dividen_out <=   {2'b0, multiplier_dividen};
							multiplier_dividen_copy <= {2'b0, multiplier_dividen, 1'b0};
							neg <=0;
						end
				end
				else begin	
					//$display("B");		   
					if (signedOp) begin	//normal signed multip
					//	$display("B1");
						multiplicand_divider_out <= {multiplicand_divider[31], //sign extends for mult
											multiplicand_divider[31], multiplicand_divider} ;
						multiplier_dividen_out <= {multiplier_dividen[31], 
											multiplier_dividen[31], multiplier_dividen};
											multiplier_dividen_copy <= {multiplier_dividen[31], 
											multiplier_dividen[31],  multiplier_dividen, 1'b0};
						neg <= 0;
						end
					else begin //unsigned operations
					//	$display("B2");
						multiplicand_divider_out <= {2'b00, multiplicand_divider};
						multiplier_dividen_out <=   {2'b00, multiplier_dividen};
						multiplier_dividen_copy <= {2'b0, multiplier_dividen, 1'b0};
						end						
						neg <=0;
					end

				WE_multiplicand_divider <= 1;
				WE_multiplier_dividen <= 1;
						
			end
		
		else if (((count <= 69) && ~op) || ((count <= 17)&& op))
			begin

				//routine for all cycles falling within the range
				WE_multiplier_dividen <= 0;
				WE_multiplicand_divider <= 0;
				count <= count +1;	

				if (~op) begin		/*********************DIVISION***************/ 

					//initial shifting for division
				   if (count == 0)  begin //asuming the setting is done simontaenously
						shift <=1;
						shift_type <=	shiftLeft0;	
						WE_sub <= 0;
						adder_ctr <= 1'bx; //dun care		
						adder_src <= 1'bx; 			  	
					end
					
					// odd cycles where we are subtracting the divisoir reg from the left half of Remainder Reg	  	
					else if (count[0] == 1'b1) begin
						shift<= 0;
						shift_type  <= 2'bx; 
						WE_sub  <= 1;
						adder_src  <= one; 
						adder_ctr  <= subtract;								
				  	end //end of odd cycles

					else begin //count[0] == 1'b0
						if (answerMSB) begin// Remainder < 0
							shift<=1;
							shift_type <= shiftLeftRestore;
							WE_sub <= 0;
							adder_src <= one;
							adder_ctr <= add;
						end
						else begin
							shift<=1;
							shift_type <= shiftLeft1;
							WE_sub <= 0; 
							adder_src <= 1'bx;
							adder_ctr <= 1'bx; 						
						end				
					end //end of even cycles

				end//end of division
				
				else begin//if (count > 1) begin 		/************************MULTIPLICATION************/
					shift <= 1; //keep shifting every cycle. 
					WE_sub<= 0; // never need to subtract but not shifting 
					shift_type <= shiftRight; 

					multiplier_dividen_copy <= (multiplier_dividen_copy >>2); 

					//case(current_right_bits) 
					case(current_right)

					3'b000: begin
					adder_src <= zero; 
					adder_ctr <= add;
					end

					3'b001: begin
					adder_src <= one;
					adder_ctr <= add;
					end

					3'b010: begin
					adder_src <= one;
					adder_ctr <= add; 
					end

					3'b011: begin
					adder_src <= two;
					adder_ctr <= add;
					end

					3'b100: begin
					adder_src <= two;
					adder_ctr <= subtract;
					end

					3'b101: begin
					adder_src <= one;
					adder_ctr <= subtract; 
					end

					3'b110: begin
					adder_src <= one;
					adder_ctr <= subtract; 
					end

					3'b111: begin
					adder_src <= zero;
					adder_ctr <= add;
					end
					
					default: begin
					$display("shouldn't run here?");
					end
					endcase

					
				end //end of multiplication									  									
			end //end of ((count =< 69) && ~op) || ((count =< 17)&& op)

		else
			begin
				WE_multiplier_dividen <= 0;
				WE_multiplicand_divider <= 0;
				count <= 100; //just to hold the value there until the next rst
			end	
				
 	end
endmodule



