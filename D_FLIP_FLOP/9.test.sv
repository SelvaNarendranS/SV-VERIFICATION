// test

`include "environment.sv"

program test(intf intff);
  environment envi;
  
  initial begin 
    envi = new(intff);
    envi.run_task();
  end
endprogram   