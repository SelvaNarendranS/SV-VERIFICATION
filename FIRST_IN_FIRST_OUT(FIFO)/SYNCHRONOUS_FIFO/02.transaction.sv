// Synchronous FIFO verification - transaction
class transaction #(WIDTH, DEPTH);
  randc bit [WIDTH - 1:0] 	data_in;
  randc bit					rst;
  bit 						wr_en;
  bit 						rd_en;
  
  // output
  bit 					[WIDTH-1:0]	data_out;
  bit 						full;
  bit 						empty;
  
  // constraint for reset condition
  constraint rst_rand {rst == 1; data_in == 0;}
  
  // function for display
  function void display(string name);
    $display("---------------- %s ------------------", name);
    $display("Time =%0t | rst = %0d | wr_en = %0d | data_in = %0d(%0b) | rd_en = %0d | data_out = %0d(%0b) | full = %0d | empty = %0d", $time, rst, wr_en, data_in, data_in, rd_en, data_out, data_out, full, empty);
  endfunction
endclass
