// Counter verification - Test
`include "environment.sv"

program test #(parameter WIDTH)(intf intff);
  environment #(WIDTH) env;
  
  initial begin
    env = new(intff);
    env.test_run();
  end
endprogram