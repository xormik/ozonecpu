/*

make sure dataCache, instCache, and writeBuffer don't kill each other when they all access
ram at the same time.

if writeBuffer is full, it has the highest priority
else alternates between inst req and data req.
if nothing is waiting, try to empty write buffer.

state won't change untill its current req is finished.  

also, arbiter will sent out stall signal to the hazard unit to stall on data miss and inst miss.
inst stall will only stall the ID stage  whereas
data stall will stall the whole pipeline



chak 10/21

updated 10/24 by chak, thomas
- new 9-state FSM


*/

module arbiter(inst_req, inst_addr, data_req, data_addr, WB_req, WB_addr, WB_data, WB_full, 
			waitForMem, WB_granted, addr, dataOut, request, r_w, CLK, RESET,
			inst_we_gate, data_we_gate,
			CurState, NextState);

input [22:0] inst_addr, data_addr, WB_addr;
input [31:0] WB_data;
input inst_req, data_req, WB_req, WB_full;

// input from memory controller telling that it finishes a req and waiting for a new req.
//  1 = not done yet
//  0 = done or no request

input waitForMem;  
input CLK, RESET;

// output to memory control
output [22:0] addr;
output [31:0] dataOut;
output request, r_w;


// output to writeBuffer to tell that its write back request had been granted
output WB_granted;

// output to caches, gates the WE port so both caches won't be written to at the same time
output inst_we_gate;
output data_we_gate;

// debug signals
output [3:0] CurState, NextState;


reg [3:0]  CurState, NextState;
reg [22:0] addr;

wire inst_req_reg, data_req_reg, WB_req_reg;

// upedge detector for req signals
register #(1) inst_edge (.DIN(inst_req), .DOUT(inst_req_reg), .CLK(CLK), .WE(1'b1), .RST(1'b0));
register #(1) data_edge (.DIN(data_req), .DOUT(data_req_reg), .CLK(CLK), .WE(1'b1), .RST(1'b0));
register #(1) WB_edge (.DIN(WB_req), .DOUT(WB_req_reg), .CLK(CLK), .WE(1'b1), .RST(1'b0));


parameter idle = 4'b0000, 
		preInstReq = 4'b0001, instReq = 4'b0011, instMemAccess = 4'b0010,
		preDataReq = 4'b0110, dataReq = 4'b0111, dataMemAccess = 4'b0101,
		preWBReq = 4'b0100, WBReq = 4'b1100;

always @ (posedge CLK)
begin
	if (RESET)
		begin 
		CurState <= idle;
		// NextState <= idle; 
		end
	else
		CurState <= NextState;
end


// NextState logic

//wire alternator_we;
reg [3:0] NextReq;


//register #(1) alternator(.DIN(~cache_sel), .DOUT(cache_sel), .WE(alternator_we), .CLK(CLK), .RST(RESET));

always @ (WB_full or WB_req or inst_req or data_req /*or cache_sel*/ or waitForMem or
		data_addr or inst_addr or WB_addr)
  begin
	if (WB_req & WB_full)
		NextReq <= (waitForMem) ? preWBReq : WBReq;
/* Now data cache always has priority over inst cache
	else if (inst_req & data_req) 
	  begin
		if (cache_sel)
			NextReq <= (waitForMem) ? preInstReq : instReq;
		else
			NextReq <= (waitForMem) ? preDataReq : dataReq;
	  end
*/
	else if (data_req)
		NextReq <= (waitForMem) ? preDataReq : dataReq;
	else if (inst_req)
		NextReq <= (waitForMem) ? preInstReq : instReq;
	else if (WB_req)
		NextReq <= (waitForMem) ? preWBReq : WBReq;
	else NextReq <= idle;
  end


always @ (waitForMem or CurState or WB_full or WB_req or inst_req or data_req or NextReq)
  begin	
	case (CurState)

	idle:  		NextState <= NextReq;
	preInstReq:	NextState <= (waitForMem) ? NextReq : instReq;
	instReq:		NextState <= instMemAccess;
	instMemAccess:	NextState <= (waitForMem) ? instMemAccess : NextReq;
	preDataReq:	NextState <= (waitForMem) ? NextReq : dataReq;
	dataReq:		NextState <= dataMemAccess;
	dataMemAccess:	NextState <= (waitForMem) ? dataMemAccess : NextReq;
	preWBReq:		NextState <= (WB_req) ? ((waitForMem) ? NextReq : WBReq) : idle;
	WBReq:		NextState <= NextReq;
	default:		NextState <= idle;

	endcase	
  end

// Output Logic

wire [22:0] inst_addr_reg, data_addr_reg, WB_addr_reg;
wire [31:0] WB_data_reg;
register #(23) inst_addr_register (.DIN(inst_addr), .DOUT(inst_addr_reg), .CLK(CLK), 
							.WE(inst_req & ~inst_req_reg), .RST(1'b0));
register #(23) data_addr_register (.DIN(data_addr), .DOUT(data_addr_reg), .CLK(CLK), 
							.WE(data_req & ~data_req_reg), .RST(1'b0));


register #(23) WB_addr_register (.DIN(WB_addr), .DOUT(WB_addr_reg), .CLK(CLK), 
							.WE(WB_req & ~WB_req_reg), .RST(1'b0));
register #(32) WB_data_register (.DIN(WB_data), .DOUT(WB_data_reg), .CLK(CLK),
							.WE(WB_req & ~WB_req_reg), .RST(1'b0));


always @ (CurState or inst_addr_reg or data_addr_reg or WB_addr_reg)
  begin
	if (CurState == instReq)
		addr <= inst_addr_reg;
	else if (CurState == dataReq)
		addr <= data_addr_reg;
	else if (CurState == WBReq)
		addr <= WB_addr_reg;
	else
		addr <= 23'bx;
  end
	    

assign request = ((CurState == instReq) /*& inst_req*/)| 
			  ((CurState == dataReq) /*& data_req*/) | 
			  ((CurState == WBReq) /*& WB_req*/);
assign r_w = (CurState == WBReq);
assign dataOut = WB_data_reg;
assign WB_granted = (CurState == WBReq);
//assign alternator_we = (CurState == instReq) | (CurState == dataReq);
assign inst_we_gate = (CurState == instMemAccess);
assign data_we_gate = (CurState == dataMemAccess);


endmodule
