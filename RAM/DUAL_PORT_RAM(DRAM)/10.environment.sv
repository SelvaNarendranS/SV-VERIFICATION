// dual port ram-- ENVIRONMENT

`include "transaction.sv"
`include "agent.sv"
`include "coverage.sv"
`include "scoreboard.sv"

class environment #(WIDTH, DEPTH, MODE);
  
  agent #(WIDTH, DEPTH, MODE)      agt;		// child class handles
  scoreboard #(WIDTH, DEPTH, MODE) scb;  
  coverage #(WIDTH, DEPTH, MODE)   cov;
  mailbox mon2scb;
  mailbox mon2cov;
  
  virtual intf #(WIDTH, DEPTH, MODE).tb vintf;
  
  event over;						// event for next stimuli
  event done_coverage;				// coverage done  -- procced
  event done_verify;				// overall done event 
  
  // function new constructor
  function new(virtual intf #(WIDTH, DEPTH, MODE).tb vintf);
    this.vintf = vintf;
    
    mon2scb = new();
    mon2cov = new();
    agt     = new(mon2scb, mon2cov, vintf, over, done_verify);
    scb 	= new(mon2scb);
    cov		= new(mon2cov);
    
    scb.done_coverage = done_coverage;
    cov.done_coverage = done_coverage;
    cov.over     = over;

  endfunction
  
  task run_test();
    fork
      agt.main();
      scb.main();
      cov.main();
    join_none
    @done_verify;
    $finish;
  endtask
  
endclass