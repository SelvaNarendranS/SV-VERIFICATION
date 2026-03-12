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
  scoreboard #(WIDTH, DEPTH) scb;
  
  mailbox gen2drv;
  mailbox mon2scb_wr;
  mailbox mon2scb_rd;
  
  event over;
  event drive_done;
  
  virtual intf #(WIDTH, DEPTH) vintf;
  
  function new( virtual intf #(WIDTH, DEPTH) vintf);
    this.vintf = vintf;
    
    mon2scb_wr = new();
    mon2scb_rd = new();
    gen2drv = new();
    gen = new(gen2drv);
    drv = new(vintf, gen2drv);
    mon = new(vintf, mon2scb_wr, mon2scb_rd);
    scb = new(mon2scb_wr, mon2scb_rd);
    
    gen.over = over;
    scb.over = over;
    
    drv.drive_done = drive_done;
    mon.drive_done = drive_done;
  endfunction
  
  task test_run();
    
    fork
      gen.generator_main();
      drv.driver_main();
      mon.monitor_main();
      scb.scoreboard_main();
    join
    
    #200;
  endtask
endclass 
