// module: check_position
// author: Thomas Yiu
// description: given issue_ptr, commit_ptr, lw_entry, and an entry number to 
//              check, returns a boolean value indicating if that entry
//              is issued before the lw entry

// IMPORTANT: this module assumes entry is valid!

module check_position(issue_ptr, commit_ptr, lw_entry, entry, before_lw);
	input [4:0] issue_ptr;
	input [4:0] commit_ptr;
	input [4:0] lw_entry;
	input [4:0] entry;

	output before_lw;

	reg before_lw;
	always @ (issue_ptr or commit_ptr or lw_entry or entry)
	  begin
		if (issue_ptr > commit_ptr)
			before_lw <= entry < lw_entry & entry >= commit_ptr;
		else if (lw_entry < commit_ptr)
			before_lw <= (entry < lw_entry & entry <= commit_ptr) |
					   (entry > lw_entry & entry >= commit_ptr);
		else
			before_lw <= entry < lw_entry & entry >= commit_ptr;
	  end

endmodule

