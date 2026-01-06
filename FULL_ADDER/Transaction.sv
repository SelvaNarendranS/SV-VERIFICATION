class transaction;
  randc bit a; 
  randc bit b;
  randc bit c;
  
  bit sum;
  bit carry;
  
  //print input values
  function void display(string name);
    $display("------------%s------------", name);
    $display("a = %b | b = %b | c = %b | sum = %b | carry = %b", a, b, c, sum, carry);
  endfunction
  
endclass    