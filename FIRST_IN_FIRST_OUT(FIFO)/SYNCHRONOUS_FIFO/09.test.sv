// Synchronous FIFO verification - test
`include "environment.sv"

program test #(WIDTH, DEPTH) (intf intff);
  environment #(WIDTH, DEPTH) env;
  
  initial begin
    env = new(intff);
    env.test_run();
  end
endprogram
