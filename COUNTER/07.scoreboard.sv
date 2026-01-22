// Counter verification - Scoreboard
class scoreboard #(parameter WIDTH);
  transaction #(WIDTH) trans;		// transaction handle
  mailbox mon2scr;			// created mailbox b/w monitor and scoreboard
  
  bit[WIDTH - 1:0] expected = 0;
  
  // event
  event next;
  
  function new(mailbox mon2scr);
    this.mon2scr = mon2scr;
  endfunction
  
  // task main 
  task scr_main();
    
//     selfcheck();		// calling selfcheck task
    repeat(((2**WIDTH)*3) +2) begin
      mon2scr.get(trans);
      
      trans.display("Value received to SCOREBOARD");
    // selfcheck
      if(trans.reset)
        expected = 0;
      else if(trans.enable) begin
        if(trans.up_down)
          expected++;
        else
          expected--;
      end
      
      if(expected == trans.q) begin
        $display("--------------------------------------");
        $display("                 PASS                 ");  
        $display("--------------------------------------");
      end
      else begin
        $display("--------------------------------------");
        $display("                 FAIL                 ");  
        $display("--------------------------------------");
      end
      
      // event trigger
      ->next;
    end
      
  endtask

endclass
