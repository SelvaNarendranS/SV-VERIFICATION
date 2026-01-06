// Including all necessary class
`include "Transaction.sv"
`include "Generator.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Scoreboard.sv"

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2drv;
  mailbox mon2scb;
  
  virtual intf vint;
  
  function new(virtual intf vint);
    this. vint = vint;
    
    gen2drv = new();
    mon2scb = new();
    gen     = new(gen2drv);
    drv     = new(vint, gen2drv);
    mon     = new(vint, mon2scb);
    scb     = new(mon2scb); 
    
  endfunction
  
  task run_task();
      fork
        gen.main();
        drv.main();
        mon.main();
        scb.main();
      join
  endtask
endclass    