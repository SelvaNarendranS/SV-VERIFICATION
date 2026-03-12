// Synchronous FIFO verification - scoreboard

class scoreboard #(WIDTH, DEPTH);
 
  mailbox mon2scb_wr;	   // created mailbox b/w monitor to scoreboard for transfer package of information
  mailbox mon2scb_rd;
  
  // event
  event over;
  
  function new(mailbox mon2scb_wr, mailbox mon2scb_rd);
    this.mon2scb_wr = mon2scb_wr;
    this.mon2scb_rd = mon2scb_rd;
  endfunction
  
  // selfcheck fifo memory
  bit [WIDTH-1:0]       expected_fifo[$];		// bounded queue -- fifo memory
  bit wr_rst;
  bit wr_en;
  bit rd_rst;
  bit rd_en;
  static bit [$clog2(DEPTH):0]	count_ptr = 0;
  bit 					expected_full;
  bit 					expected_empty;
  bit [WIDTH - 1 : 0]	data_in;
  bit [WIDTH - 1 : 0]	data_out;
  bit 					full;
  bit 					empty;
  bit [WIDTH - 1 : 0]	expected_data_out;
  
  
  int 					count;
  
  task scoreboard_main();
      fork
        write_evaluate();
        read_evaluate();
      join_none
      wait fork;
//       compare_data();
    
  endtask
  
  // write domain sampled data receiving 
  task write_evaluate();
    forever begin
      transaction #(WIDTH, DEPTH) trans_wr; // transaction handle
    
      mon2scb_wr.get(trans_wr);
      wr_rst  = trans_wr.wr_rst;
      wr_en   = trans_wr.wr_en;
      data_in = trans_wr.data_in;
      full = trans_wr.full;
      
      trans_wr.display("Values received to WRITE DOMAIN scoreboard");
    
    if(!wr_rst)
      expected_fifo.delete();
    
    if(wr_en && !full)
      expected_fifo.push_back(data_in);
    end
  endtask
  
  // read domain sampled data receiving 
  task read_evaluate();
    forever begin
      transaction #(WIDTH, DEPTH) trans_rd; // transaction handle
    
      mon2scb_rd.get(trans_rd);
      rd_rst  = trans_rd.rd_rst;
      rd_en   = trans_rd.rd_en;
      data_out = trans_rd.data_out;
      empty = trans_rd.empty;
      
      trans_rd.display("Values received to READ DOMAIN scoreboard");
      
      if(rd_en && !empty)
        wait(expected_fifo.size() > 0);
      
      compare_data();
      
      ->over;
    end
  endtask
  
  // compare data
  function void compare_data();
    
    if(rd_en && !empty)
      expected_data_out = expected_fifo.pop_front();
    
    if(rd_en)begin
      if(expected_data_out == data_out) begin
        $display("--------------------------------------");
        $display("           data out - PASS");  
        $display("--------------------------------------");
      end
      else begin
        $display("--------------------------------------");
        $display("           data out - FAIL --- expected_data_out = %0d | data_out = %0d", expected_data_out, data_out);  
        $display("--------------------------------------");
      end
    end
    
    $display("----------------------------------------------%0d", count);
    count++;
    
  endfunction
  
endclass
