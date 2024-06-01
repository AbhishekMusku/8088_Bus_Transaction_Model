
class rst_seq extends uvm_sequence#(transaction);
	`uvm_object_utils(rst_seq)
	transaction rst_txn;

	function new (string path = "rst_seq");
		super.new(path);
		`uvm_info("RESET_SEQUENCE", "Inside Constructor!", UVM_HIGH)
	endfunction

	task body();
		`uvm_info("RESET_SEQUENCE", "Inside Body Task!", UVM_HIGH)
		
		rst_txn = transaction::type_id::create("rst_txn");
		start_item(rst_txn);
		assert(rst_txn.randomize() with {wrst_n == 1'b1; rrst_n == 1'b1;}); 
		`uvm_info("RESET_SEQUENCE", "RESET FIFO!", UVM_HIGH)	
		finish_item(rst_txn);
	endtask

endclass: rst_seq


class wr_full_seq extends uvm_sequence#(transaction);
	`uvm_object_utils(wr_full_seq)
	transaction txn;

	function new (string path = "wr_full_seq");
		super.new(path);
		`uvm_info("WR_FULL_SEQUENCE", "Inside Constructor!", UVM_HIGH)
		
	endfunction

	task body();
		`uvm_info("WR_FULL_SEQUENCE", "Inside Body Task!", UVM_HIGH)
		
		repeat(512) begin
			txn = transaction::type_id::create("txn");
			start_item(txn);
			assert(txn.randomize() with {wrst_n == 1'b0; wr_en == 1'b1; rd_en == 1'b0;});
			`uvm_info("WR_FULL_SEQUENCE", "WRITING DATA", UVM_HIGH)
			finish_item(txn);
		end
	endtask

endclass: wr_full_seq

class full_empty_seq extends uvm_sequence#(transaction);
	`uvm_object_utils(full_empty_seq)
	transaction txn;

	function new (string path = "full_empty_seq");
		super.new(path);
		`uvm_info("RD_EMPTY_SEQUENCE", "Inside Constructor!", UVM_HIGH)
		
	endfunction

	task body();
		`uvm_info("RD_EMPTY_SEQUENCE", "Inside Body Task!", UVM_HIGH)
		
		repeat(280) begin
			txn = transaction::type_id::create("txn");
			start_item(txn);
			assert(txn.randomize() with {wrst_n == 1'b0; wr_en == 1'b1; rd_en == 1'b0;});
			`uvm_info("WR_FULL_SEQUENCE", "WRITING DATA", UVM_HIGH)
			finish_item(txn);
		
			end
		repeat(280) begin
			txn = transaction::type_id::create("txn");
			start_item(txn);
			assert(txn.randomize() with {rrst_n == 1'b0; wr_en == 1'b0; rd_en == 1'b1;});
			`uvm_info("RD_EMPTY_SEQUENCE", "READING DATA", UVM_HIGH)	
			finish_item(txn);
			end
	endtask

endclass: full_empty_seq


class random_seq extends uvm_sequence#(transaction);
	`uvm_object_utils(random_seq)
	transaction txn;

	function new (string path = "random_seq");
		super.new(path);
		`uvm_info("RANDOM_SEQUENCE", "Inside Constructor!", UVM_HIGH)
		
	endfunction

	task body();
		`uvm_info("RANDOM_SEQUENCE", "Inside Body Task!", UVM_HIGH)
		
		repeat(512)begin
			txn = transaction::type_id::create("txn");
			start_item(txn);
			assert(txn.randomize()); 
			`uvm_info("RANDOM_SEQUENCE", "RANDOM OPERATION", UVM_HIGH)
			finish_item(txn);
		end
	endtask

endclass: random_seq

