// Asynchronous FIFO verification - transaction

class transaction #(WIDTH, DEPTH);
  
  // write domain
  rand bit 				wr_rst;
  rand bit 				wr_en;
  randc bit [WIDTH -1 :0]	data_in;
  bit 				full;

  // read domain
  rand bit 				rd_rst;
  rand bit 				rd_en;
  bit [WIDTH -1 :0] 	data_out;
  bit 				empty;
  
  static int		count = 1;
  
  // constraint for reset condition
  constraint rst_cnst{wr_en == 0;
                      rd_en == 0;
                      wr_rst  == 0;
                      rd_rst  == 0;
                      data_in == 0;
                     }
  
  constraint wr_cnst{wr_en == 1;
                      rd_en == 0;
                      wr_rst  == 1;
                      rd_rst  == 1;
                     }
  
  constraint rd_cnst{wr_en == 0;
                      rd_en == 1;
                      wr_rst  == 1;
                      rd_rst  == 1;
                     }  
   
//   function void post_randomize();
//     if(count == 1) begin
//       wr_rst  = 0;
//       wr_en   = 0;
//       rd_rst  = 0;
//       rd_en	 = 0;
//       data_in = 0;
//       count++;
//     end
//     else begin
      
      
      
  // function for display
  function void display(string name);
    $display("---------------- %s ------------------", name);
    $display("Time =%0t | wr_rst = %0d | rd_rst = %0d | wr_en = %0d | data_in = %0d(%0b) | rd_en = %0d | data_out = %0d(%0b) | full = %0d | empty = %0d", $time, wr_rst, rd_rst, wr_en, data_in, data_in, rd_en, data_out, data_out, full, empty);
  endfunction
endclass