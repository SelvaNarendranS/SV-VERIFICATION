// dual port ram -- agent

`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent #(WIDTH, DEPTH, MODE);
  
  generator #(WIDTH, DEPTH, MODE) gen;
  driver #(WIDTH, DEPTH, MODE)    drv;
  monitor #(WIDTH, DEPTH, MODE)   mon;		// child class handles
  
  mailbox gen2drv;
  mailbox mon2scb;
  mailbox mon2cov;
  
  virtual intf #(WIDTH, DEPTH, MODE).tb vintf;
  
  event over;
  event done_verify;				// overall done event 
  
  // function new constructor
  function new(mailbox mon2scb, mailbox mon2cov, virtual intf #(WIDTH, DEPTH, MODE).tb vintf, event over, event done_verify);
    this.vintf   = vintf;
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
    
    gen2drv = new();
    gen     = new(gen2drv);
    drv		= new(gen2drv, vintf);
    mon		= new(mon2scb, mon2cov, vintf);
    
    gen.over = over;
    gen.done_verify = done_verify;
  endfunction
  
  task main();
    fork
      gen.main();
      drv.main();
      mon.main();
    join
  endtask
  
endclass