// Counter verification - Transaction
class transaction #(parameter WIDTH);				// or called package
  bit 				reset;
  bit 				enable;
  bit 				up_down;
  bit [WIDTH - 1:0] q;
  
  function void display(string name);
    $display("------------- %s -------------", name);
    $display("Time = %0t, reset = %0d, enable = %0d, up_down = %0d, q = %0d(%b)", $time, reset, enable, up_down, q, q);
  endfunction
endclass