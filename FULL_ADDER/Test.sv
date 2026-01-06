// Program block for test 
// including environment class
`include "Environment.sv"

program test(intf intff);
  environment env;
  
  initial begin
    env = new(intff);
    env.run_task();
  end
endprogram