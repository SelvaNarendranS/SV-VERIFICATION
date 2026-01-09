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
  
//   // getting values from mailbox to evaluate
//   task value(output bit rst, en, up_dn, output bit [WIDTH - 1:0]cnt);
    
//     mon2scr.get(trans);
//     rst   = trans.reset;
//     en    = trans.enable;
//     up_dn = trans.up_down;
//     cnt   = trans.q;
      
//     trans.display("Value received to SCOREBOARD");
//   endtask
    
//   // self checking
//   task selfcheck();
//     bit[WIDTH - 1:0] q;
//     bit reset, enable, up_down;
//     bit[WIDTH - 1:0] expected = 0;
    
// //     repeat((2**WIDTH)*3) begin
//     repeat(WIDTH) begin
      
//       value(reset, enable, up_down, q);				// calling value task 
//      if(reset)
//        expected = 0;
//       else if(enable) begin
//         if(up_down)
//           expected++;
//         else
//           expected--;
//       end
      
//       if(expected == q) begin
//         $display("--------------------------------------");
//         $display("                 PASS                 ");  
//         $display("--------------------------------------");
//       end
//       else begin
//         $display("--------------------------------------");
//         $display("                 FAIL                 ");  
//         $display("--------------------------------------");
//       end
//     end
//   endtask
  
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