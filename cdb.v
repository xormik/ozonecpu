// Common data bus

// currently a daisy chain, with mult_din having the highest priority
// current daisy chain order from highest priority to lowest:
// - mult/div
// - load_buffer
// - branch
// - alu
// - store_buffer

module cdb(mult_din, mult_req, load_din, load_req, branch_din, branch_req, alu_din, alu_req,
		store_din, store_req,
		clk, rst, dout, dout_en,
		mult_granted, load_granted, branch_granted, alu_granted, store_granted);
	input [132:0] mult_din;	// this is the multiplier port
	input [68:0] load_din, store_din; // this is the load buffer and store buffer
	input [100:0] branch_din, alu_din;
	input mult_req, load_req, branch_req, alu_req, store_req;
	input clk, rst;
	output mult_granted, load_granted, branch_granted, alu_granted, store_granted;
	output [132:0] dout;
	output dout_en;

	reg [5:1] granted;
	reg [132:0] dout;
	reg dout_en;

	always @ (mult_req or load_req or branch_req or alu_req or store_req)
	  begin
		if (mult_req)
			granted <= 5'b00001;
		else if (load_req)
			granted <= 5'b00010;
		else if (branch_req)
			granted <= 5'b00100;
		else if (alu_req)
			granted <= 5'b01000;
		else if (store_req)
			granted <= 5'b10000;
		else
			granted <= 5'b00000;
	  end

	assign mult_granted = granted[1];
	assign load_granted = granted[2];
	assign branch_granted = granted[3];
	assign alu_granted = granted[4];
	assign store_granted = granted[5];


	always @ (posedge clk)
	  begin
	  	if (rst)
		  begin
		  	dout <= 0;
			dout_en <= 0;
		  end
		else if (mult_granted)
		  begin
			dout <= mult_din;
			dout_en <= 1;
		  end
		else if (load_granted)
		  begin
			dout[132:101] <= load_din[68:37]; // Vj
			dout[100:37] <= 0;
			dout[36:0] <= load_din[36:0];
			dout_en <= 1;
		  end
		else if (branch_granted)
		  begin
			dout[132:69] <= branch_din[100:37]; // Vj, Vk
			dout[68:37] <= 0;
			dout[36:0] <= branch_din[36:0];
			dout_en <= 1;
		  end		
		else if (alu_granted)
		  begin
			dout[132:69] <= alu_din[100:37]; // Vj, Vk
			dout[68:37] <= 0;
			dout[36:0] <= alu_din[36:0];
			dout_en <= 1;
		  end
		else if (store_granted)
		  begin
			dout[132:101] <= store_din[68:37]; // Vj
			dout[100:37] <= 0;
			dout[36:0] <= store_din[36:0];
			dout_en <= 1;
		  end
		else
		  begin
			dout <= 0;
			dout_en <= 0;
		  end
	  end



endmodule
