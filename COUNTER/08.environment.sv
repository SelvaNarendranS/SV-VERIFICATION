// Counter verification - Environment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment #(parameter WIDTH);
  transaction #(WIDTH) trans;
  generator #(WIDTH) gen;
  driver #(WIDTH) drv;
  monitor #(WIDTH) mon;
  scoreboard #(WIDTH) scr;
  
  mailbox mon2scr;
  mailbox gen2drv;
  
  virtual intf #(WIDTH) vintf;
  
  // event 
  event next;
  
  function new( virtual intf #(WIDTH) vintf);
    this.vintf = vintf;
    
    mon2scr = new();
    gen2drv = new();
    gen = new(gen2drv);
    drv = new(vintf, gen2drv);
    mon = new(vintf, mon2scr);
    scr = new(mon2scr);
    
    gen.next = next;
    scr.next = next;
  endfunction
  
  task test_run();
    fork
      gen.gen_main();
      drv.drv_main();
      mon.mon_main();
      scr.scr_main();
    join
  endtask
endclass 