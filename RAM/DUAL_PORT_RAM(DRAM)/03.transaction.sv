// dual port ram -- transaction

class transaction #(WIDTH, DEPTH, MODE);
  
  rand bit 							   en;
  
  // port A
  rand bit 							   a_wr;
  static randc bit [$clog2(DEPTH)-1:0] a_addr;
  rand bit [WIDTH-1:0] 				   a_data_in;
  bit [WIDTH-1:0]					   a_data_out;
  
  // port B
  rand bit 							   b_wr;
  static randc bit [$clog2(DEPTH)-1:0] b_addr;
  rand bit [WIDTH-1:0] 				   b_data_in;
  bit [WIDTH-1:0]					   b_data_out;
  
  // constraint
  constraint enable {
    en dist {0 := 5, 1 := 95}; 			// 5% chance of disable & 95% chance of enable
  }
  
  constraint ct_write_enable {
    a_wr dist { 0 := 30, 1 := 80};		// 80% chance of write disable & 30% chance of write enable
    b_wr dist { 0 := 30, 1 := 80};
  }
  
  function void display(string name);
    $display("---------------- %s ------------------", name);
    $display("Time = %0t | en = %0d | a_wr = %0d | a_addr = %0d | a_data_in = %0d | b_wr = %0d | b_addr = %0d | b_data_in = %0d | a_data_out = %0d | b_data_out = %0d", $time, en, a_wr, a_addr, a_data_in, b_wr, b_addr, b_data_in, a_data_out, b_data_out);
  endfunction
  
endclass