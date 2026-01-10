// Synchronous FIFO verification - scoreboard
class scoreboard #(WIDTH, DEPTH);
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  mailbox mon2scr;								// created mailbox b/w monitor to scoreboard for transfer package of information
  
  // selfcheck fifo memory
  longint                   fifo[$:DEPTH - 1];
  bit [$clog2(DEPTH) - 1:0] wr_ptr;
  bit [$clog2(DEPTH) - 1:0] rd_ptr;
  bit 					  	full;
  bit 					  	empty;
  bit [WIDTH - 1 : 0]		expected;
  int 						count;
  
  // event
  event over;
  
  function new(mailbox mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  task scoreboard_main();
    
//     forever begin
    for(int i = 0; i < (DEPTH * 2); i++) begin
      mon2scr.get(trans);			// getting packets of data from mailbox
     
      trans.display("Value received to SCOREBOARD");

      $display("%0d", count);
      
      if(trans.rst) begin			// reset condition
        wr_ptr   = 0;
        expected = 0;
        rd_ptr   = 0;
      end
      
      // Write condition
      else if(trans.wr_en && !full) begin
        fifo.push_back(trans.data_in);
      	wr_ptr = wr_ptr + 1'b1;
      end
      
      // read condition 
      else if(trans.rd_en && !empty) begin
        expected = fifo.pop_front();
        rd_ptr = rd_ptr + 1'b1;
      end
      
      // full & empty condition
      full  = (wr_ptr + 1'b1) == rd_ptr;
      empty = wr_ptr == rd_ptr;
      
      if(trans.rd_en)begin
        if(expected == trans.data_out) begin
          $display("--------------------------------------");
          $display("           data out - PASS");  
          $display("--------------------------------------");
        end
        else begin
          $display("--------------------------------------");
          $display("           data out - FAIL");  
          $display("--------------------------------------");
        end
      end
      
      if(full == trans.full) begin
        $display("--------------------------------------");
        $display("           full - PASS");  
        $display("--------------------------------------");
      end
      else begin
        $display("--------------------------------------");
        $display("           full - FAIL");  
        $display("--------------------------------------");
      end
      
      if(empty == trans.empty) begin
          $display("--------------------------------------");
        $display("           empty - PASS");  
          $display("--------------------------------------");
        end
        else begin
          $display("--------------------------------------");
          $display("         empty - FAIL");  
          $display("--------------------------------------");
        end
      
      count++;
      // event trigger 
      ->over;
    end
  endtask
  
endclass