// single port ram -- TEST
`include "environment.sv"

program test #(WIDTH, DEPTH) (intf intff);
  
  environment #(WIDTH, DEPTH) env;
  
  initial begin
    env = new(intff);
    env.run_test();
  end
  
endprogram