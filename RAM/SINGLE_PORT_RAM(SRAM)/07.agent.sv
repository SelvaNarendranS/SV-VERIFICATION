// single port ram-- AGENT

`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"

class agent #(WIDTH, DEPTH);
  
  generator #(WIDTH, DEPTH) gen;
  driver #(WIDTH, DEPTH)    drv;
  monitor #(WIDTH, DEPTH)   mon;		// child class handles
  
  mailbox gen2drv;
  mailbox mon2scb;
  
  virtual intf #(WIDTH, DEPTH) vintf;
  
  event next;
  
  // function new constructor
  function new(mailbox mon2scb, virtual intf #(WIDTH, DEPTH) vintf, event next);
    this.vintf   = vintf;
    this.mon2scb = mon2scb;
    
    gen2drv = new();
    gen     = new(gen2drv);
    drv		= new(gen2drv, vintf);
    mon		= new(mon2scb, vintf);
    
    gen.next = next;
  endfunction
  
  task main();
    fork
      gen.main();
      drv.main();
      mon.main();
    join
  endtask
  
endclass