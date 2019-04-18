module readBuffer(RESET, WE, DRAMCLK,  dOut, dIn);

input RESET, WE, DRAMCLK;
input [31:0] dIn;

output [255:0] dOut;


wire [31:0] word0, word1, word2, word3, word4, word5, word6, word7;




register #(32) block1(.DIN(word1), 
  					    .DOUT(word0), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block2(.DIN(word2), 
  					    .DOUT(word1), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block3(.DIN(word3), 
  					    .DOUT(word2), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block4(.DIN(word4), 
  					    .DOUT(word3), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block5(.DIN(word5), 
  					    .DOUT(word4), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block6(.DIN(word6), 
  					    .DOUT(word5), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block7(.DIN(word7), 
  					    .DOUT(word6), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));

register #(32) block8(.DIN(dIn), 
  					    .DOUT(word7), 
					    .WE(WE), 
					    .CLK(DRAMCLK), 
					    .RST(RESET));



assign dOut = {word7, word6, word5, word4, word3, word2, word1, word0 }; 

endmodule
