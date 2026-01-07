// transaction class

class transaction;
  rand bit d;
  rand bit reset;
  bit q;
  bit q_bar;
  
  function void display(string name);
    $display("----------- DATA FROM %0s -------------", name);
    $display("reset = %0d | d = %0d | q = %0d | q_bar = %0d", reset, d, q, q_bar);
    $display("Time = %0t", $time);
  endfunction
endclass