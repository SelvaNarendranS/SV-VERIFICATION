// environment

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scr;
  
  mailbox gen2drv, mon2scr;
  virtual intf vintf;
  
  function new(virtual intf vintf);
    this.vintf 	= vintf;
    
    gen2drv   	= new();
    mon2scr 	= new();
    gen 		= new(gen2drv);
    scr 		= new(mon2scr);
    drv 		= new(vintf, gen2drv);
    mon 		= new(vintf, mon2scr);
    
  endfunction
  
  task run_task();
    fork
      gen.main();
      mon.main();
      drv.main();
      scr.main();
    join
  endtask
endclass