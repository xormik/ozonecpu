
module debouncer (I, O, C);
   
   input     I;
   output    O;
   input     C;

   
   reg Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10,
	    Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19, Q20,
		 Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30,
		 Q31, Q32;

   always @(posedge C) begin
      Q1 <= #1 I;
      Q2 <= #1 Q1;
      Q3 <= #1 Q2;
      Q4 <= #1 Q3;
		Q5 <= #1 Q4;
		Q6 <= #1 Q5;
		Q7 <= #1 Q6;
		Q8 <= #1 Q7;
		Q9 <= #1 Q8;
	   Q10 <= #1 Q9;
      Q11 <= #1 Q10;
      Q12 <= #1 Q11;
      Q13 <= #1 Q12;
      Q14 <= #1 Q13;
		Q15 <= #1 Q14;
		Q16 <= #1 Q15;
		Q17 <= #1 Q16;
		Q18 <= #1 Q17;
		Q19 <= #1 Q18;
	   Q20 <= #1 Q19;
      Q21 <= #1 Q20;
      Q22 <= #1 Q21;
      Q23 <= #1 Q22;
      Q24 <= #1 Q23;
		Q25 <= #1 Q24;
		Q26 <= #1 Q25;
		Q27 <= #1 Q26;
		Q28 <= #1 Q27;
		Q29 <= #1 Q28;
	   Q30 <= #1 Q29;
      Q31 <= #1 Q30;


		Q32 <= ((Q1==Q2)&&(Q2==Q3)&&(Q3==Q4)&&(Q4==Q5)&&(Q5==Q6)&&(Q6==Q7)&&(Q7==Q8)&&(Q8==Q9)&&(Q9==Q10)&&(Q10==Q11)&&
              (Q11==Q12)&&(Q12==Q13)&&(Q13==Q14)&&(Q14==Q15)&&(Q15==Q16)&&(Q16==Q17)&&(Q17==Q18)&&(Q18==Q19)&&(Q19==Q20)&&(Q20==Q21)&&
              (Q21==Q22)&&(Q22==Q23)&&(Q23==Q24)&&(Q24==Q25)&&(Q25==Q26)&&(Q26==Q27)&&(Q27==Q28)&&(Q28==Q29)&&(Q29==Q30)&&(Q30==Q31)) ? Q1 : Q32;
   end
   
   assign O = Q32;
   
endmodule

//////////////////////////////////////////////////////////////////////////
//variable length debouncer (untested)
// length = number of flip flops to use
// debounce period = 2 ^ (length - 1)
// (larger lenght)=(longer debounceing period)
module our_debouncer (I, O, C);
   parameter length = 16; // to be overwriten
   
   input     I;
   output    O;
   input     C;
   
   reg [length-1:0] cntr;
   initial cntr = 0;

   always @(posedge C) begin
      if (cntr[length-1] ^ I) begin
	 cntr <= cntr + 1;
      end
   end
   
   upedge dbnc(.I(cntr[length-1]), .O(O), .C(C));
   
endmodule // bin_debounce

//////////////////////////////////////////////////////////////////////////
//variable width rising edge catcher
module upedge (I, O, C);
   parameter width = 1; // to be overwriten
   
   input [width-1:0] I;
   output [width-1:0] O;
   input 	      C;
   
   reg [width-1:0]    D0;
   reg [width-1:0]    D1;
   
   always @(posedge C) begin
      D1 <= D0;
      D0 <= I;      
   end
   
   assign O =  ~D1 & D0;
endmodule // upedge

//////////////////////////////////////////////////////////////////////////
//variable width rising edge catcher
module upedge_A (I, O, C);
   parameter width = 1; // to be overwriten
   
   input [width-1:0] I;
   output [width-1:0] O;
   input 	      C;
   
   reg [width-1:0]    D;
   
   always @(posedge C) begin
      D <= I;      
   end
   
   assign O =  ~D & I;
endmodule // upedge

