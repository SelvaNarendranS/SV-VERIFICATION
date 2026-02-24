// single port ram-- ENVIRONMENT

`include "transaction.sv"
`include "agent.sv"
`include "coverage.sv"
`include "scoreboard.sv"

class environment #(WIDTH, DEPTH);
  
  agent #(WIDTH, DEPTH)      agt;		// child class handles
  scoreboard #(WIDTH, DEPTH) scb;  
  coverage #(WIDTH, DEPTH) cov;  
  
  mailbox mon2scb;
  mailbox mon2cov;
  
  virtual intf #(WIDTH, DEPTH) vintf;
  
  event next;
  
  // function new constructor
  function new(virtual intf #(WIDTH, DEPTH) vintf);
    this.vintf = vintf;
    
    mon2scb = new();
    mon2cov = new();
    agt     = new(mon2scb, mon2cov, vintf, next);
    scb 	= new(mon2scb);
    cov		= new(mon2cov);
    
    scb.set_coverage(cov);			// setting coverage to the scorboard
    agt.gen.next = next;
    scb.next = next;
  endfunction
  
  task run_test();
    fork
      agt.main();
      scb.main();
      cov.main();
    join
//     $display("%0d",scb.count);
//     if(scb.count == ((DEPTH * 2) + 1)+1)
//       cov.report;
    
  endtask
  
endclass