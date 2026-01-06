class scoreboard;
  monitor mon; 		// created monitor class handle
  mailbox mon2scb;
  
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
    repeat(3) begin
      transaction trans;
      mon2scb.get(trans);
      trans.display("Score board received");
      self_checking(trans);
      
    end
  endtask
  
  // self checking
  task self_checking(transaction trans);
    logic a, b, c, sum, carry;
    logic exp_sum, exp_carry;
    begin
      a         = trans.a;
      b         = trans.b;
      c         = trans.c;
      exp_sum   = trans.sum;
      exp_carry = trans.carry;
      
      {carry, sum} = (a + b + c);
      
      // checking and display
      $display("~~~~~~~~~~~~~~~~~~~%s~~~~~~~~~~~~~~~~~~~", 
               ((exp_sum == sum) && (exp_carry == carry)) ? "PASS" : "FAIL");
      $display("-------%s----------\n","Transaction done");
    end
  endtask
endclass      