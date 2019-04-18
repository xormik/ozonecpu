module check_all_positions(issue_ptr, commit_ptr, lw_entry, entry_before_lw);

	input [4:0] issue_ptr;
	input [4:0] commit_ptr;
	input [4:0] lw_entry;
	output [31:0] entry_before_lw;

	assign entry_before_lw[0] = 0;

	check_position check_position1 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd1), .lw_entry(lw_entry), .before_lw(entry_before_lw[1]));
	check_position check_position2 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd2), .lw_entry(lw_entry), .before_lw(entry_before_lw[2]));
	check_position check_position3 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd3), .lw_entry(lw_entry), .before_lw(entry_before_lw[3]));
	check_position check_position4 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd4), .lw_entry(lw_entry), .before_lw(entry_before_lw[4]));
	check_position check_position5 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd5), .lw_entry(lw_entry), .before_lw(entry_before_lw[5]));
	check_position check_position6 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd6), .lw_entry(lw_entry), .before_lw(entry_before_lw[6]));
	check_position check_position7 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd7), .lw_entry(lw_entry), .before_lw(entry_before_lw[7]));
	check_position check_position8 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd8), .lw_entry(lw_entry), .before_lw(entry_before_lw[8]));
	check_position check_position9 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd9), .lw_entry(lw_entry), .before_lw(entry_before_lw[9]));
	check_position check_position10 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd10), .lw_entry(lw_entry), .before_lw(entry_before_lw[10]));
	check_position check_position11 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd11), .lw_entry(lw_entry), .before_lw(entry_before_lw[11]));
	check_position check_position12 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd12), .lw_entry(lw_entry), .before_lw(entry_before_lw[12]));
	check_position check_position13 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd13), .lw_entry(lw_entry), .before_lw(entry_before_lw[13]));
	check_position check_position14 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd14), .lw_entry(lw_entry), .before_lw(entry_before_lw[14]));
	check_position check_position15 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd15), .lw_entry(lw_entry), .before_lw(entry_before_lw[15]));
	check_position check_position16 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd16), .lw_entry(lw_entry), .before_lw(entry_before_lw[16]));
	check_position check_position17 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd17), .lw_entry(lw_entry), .before_lw(entry_before_lw[17]));
	check_position check_position18 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd18), .lw_entry(lw_entry), .before_lw(entry_before_lw[18]));
	check_position check_position19 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd19), .lw_entry(lw_entry), .before_lw(entry_before_lw[19]));
	check_position check_position20 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd20), .lw_entry(lw_entry), .before_lw(entry_before_lw[20]));
	check_position check_position21 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd21), .lw_entry(lw_entry), .before_lw(entry_before_lw[21]));
	check_position check_position22 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd22), .lw_entry(lw_entry), .before_lw(entry_before_lw[22]));
	check_position check_position23 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd23), .lw_entry(lw_entry), .before_lw(entry_before_lw[23]));
	check_position check_position24 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd24), .lw_entry(lw_entry), .before_lw(entry_before_lw[24]));
	check_position check_position25 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd25), .lw_entry(lw_entry), .before_lw(entry_before_lw[25]));
	check_position check_position26 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),
				.entry(5'd26), .lw_entry(lw_entry), .before_lw(entry_before_lw[26]));
	check_position check_position27 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd27), .lw_entry(lw_entry), .before_lw(entry_before_lw[27]));
	check_position check_position28 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd28), .lw_entry(lw_entry), .before_lw(entry_before_lw[28]));
	check_position check_position29 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr), 
				.entry(5'd29), .lw_entry(lw_entry), .before_lw(entry_before_lw[29]));
	check_position check_position30 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd30), .lw_entry(lw_entry), .before_lw(entry_before_lw[30]));
	check_position check_position31 (.issue_ptr(issue_ptr), .commit_ptr(commit_ptr),  
				.entry(5'd31), .lw_entry(lw_entry), .before_lw(entry_before_lw[31]));



endmodule
