`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////
//Rising Edge detector w/ reset signal
//By Jack Kang (modififed updege module from cs150, sp03)
//

module upedge_detector (I, O, C, RST);
   
   input I;
   input C;
	input RST;

   output O;
   
   reg D0;
   reg D1;
   
   always @(negedge C) begin
      D1 <= D0;
      D0 <= I;      
   end
   
   assign O =  RST ? 0 : (~D1 & D0);

endmodule // upedge_detectore

