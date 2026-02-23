// single port ram TRANSACTION

class transaction #(WIDTH, DEPTH);
  
  // packet variables
  rand bit 							   en;
  rand bit 							   wr_en;
  rand bit [WIDTH-1:0] 				   data_in;
  static randc bit [$clog2(DEPTH)-1:0] addr;
  
  // output
  bit [WIDTH-1:0]		 		data_out;
  
  // constraint
  constraint ct_enable { 
    en dist { 0 := 5, 1 := 90};		// 10% chance of disable & 90% chance of enable
  }
  
  constraint ct_write_enable {
    wr_en dist { 0 := 30, 1 := 80};		// 80% chance of write disable & 30% chance of write enable
  }
  
  // function for display
  function void display(string name);
    $display("---------------- %s ------------------", name);
    $display("Time = %0t | en = %0d | wr_en = %0d | addr = %0h | data_in = %0h | data_out = %0h", $time, en, wr_en, addr, data_in, data_out);
  endfunction
  
endclass