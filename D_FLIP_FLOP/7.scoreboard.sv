// score board

class scoreboard;
  mailbox mon2scr;
  
  function new(mailbox mon2scr);
    this.mon2scr =mon2scr;
  endfunction
  
  task main();
    transaction trans;
    
    repeat(10) begin
    	mon2scr.get(trans);
    	trans.display("SCOREBOARD");
    
    	evaluate(trans);
    end
  endtask
  
  task evaluate(transaction trans);
    logic clk, reset, d, q, q_bar;
      d     = trans.d;
      reset = trans.reset;
      q     = trans.q;
      q_bar = trans.q_bar;
    self_checking(d, reset, q, q_bar, clk);
  endtask
  
  task self_checking(input logic d, reset, q, q_bar, clk);
    if(((d == q) && (reset == 0) )|| ((reset) && (q == 0))) 
       begin
         $display("******************************");
      	 $display("            PASS              ");
      	 $display("******************************");
       end
       else 
         begin
         $display("******************************");
         $display("            FAIL              ");
      	 $display("******************************");
       end
  endtask
endclass