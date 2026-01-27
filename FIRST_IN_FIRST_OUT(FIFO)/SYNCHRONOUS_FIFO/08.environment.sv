// Synchronous FIFO verification - envirnment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment #(WIDTH, DEPTH);
  
  transaction #(WIDTH, DEPTH) trans;
  generator #(WIDTH, DEPTH) gen;
  driver #(WIDTH, DEPTH) drv;
  monitor #(WIDTH, DEPTH) mon;
  scoreboard #(WIDTH, DEPTH) scr;
  
  mailbox gen2drv;
  mailbox mon2scr;
  
  event over;
  
  virtual intf #(WIDTH, DEPTH) vintf;
  
  function new( virtual intf #(WIDTH, DEPTH) vintf);
    this.vintf = vintf;
    
    mon2scr = new();
    gen2drv = new();
    gen = new(gen2drv);
    drv = new(vintf, gen2drv);
    mon = new(vintf, mon2scr);
    scr = new(mon2scr);
    
    gen.over = over;
    scr.over = over;
  endfunction
  
  task test_run();
    
    fork
      gen.generator_main();
      drv.driver_main();
      mon.monitor_main();
      scr.scoreboard_main();
    join
    
  endtask
endclass 
