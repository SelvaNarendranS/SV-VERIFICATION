// single port ram -- TEST
`include "environment.sv"

program test #(WIDTH, DEPTH, MODE) (intf.tb intff);
  
  environment #(WIDTH, DEPTH, MODE) env;
  
  initial begin
    env = new(intff);
    
    if(!MODE)
      $display(" -------------------------- DUAL PORT RAM MODE0(read first) ------------------------------- ");
    else
      $display(" -------------------------- DUAL PORT RAM MODE1(write first) ------------------------------- ");
    
    env.run_test();
  end
  
endprogram