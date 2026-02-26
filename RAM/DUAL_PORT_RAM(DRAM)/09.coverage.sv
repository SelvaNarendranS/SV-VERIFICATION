// dual port ram -- coverage

class coverage #(WIDTH, DEPTH, MODE);
  
  transaction #(WIDTH, DEPTH, MODE) trans;   	// transaction handle
  mailbox mon2cov;		// mailbox b/w monitor to coverage
  
  event done_coverage;
  event over;
  
  covergroup cg_dram;
    
    // overall enable
    ENABLE : coverpoint trans.en{
      bins active_high = {1};
      bins active_low = {0};
    }
    
    // write/ read Port A
    prt_a : coverpoint trans.a_wr {
      bins awr_write = {1};
      bins awr_read = {0};
    }
    
    // write/ read Port B
    prt_b : coverpoint trans.b_wr {
      bins bwr_write = {1};
      bins bwr_read = {0};
    }
    
    // Port A address coverage
    prta_addr : coverpoint trans.a_addr {
      bins corner = {0, [DEPTH-2:DEPTH-1]};			// boundary condition
      bins middle = {[1:DEPTH-3]};				// other conditions
    }
    
    // Port B address coverage
    prtb_addr : coverpoint trans.b_addr {
      bins corner = {0, [DEPTH-2:DEPTH-1]};			// boundary condition
      bins middle = {[1:DEPTH-3]};				// other conditions
    }
    
    // cross each other 
    prt_crossing : cross prt_a, prt_b;
    
    // cross collision coverage checking
    collision : cross prt_a, prt_b, prta_addr, prtb_addr {
      bins addr_same = collision with (trans.a_addr == trans.b_addr);
     
      ignore_bins ignore_others = collision with (trans.a_addr != trans.b_addr);
    }
    
    // cross avoid global enable at disable condition
    ignore_disable : cross ENABLE, prt_a, prt_b, prta_addr, prtb_addr {
      bins ignore_enable_low = binsof( ENABLE.active_low);
    }
        
  endgroup
  
  function new(mailbox mon2cov);
    this.mon2cov = mon2cov;
    cg_dram = new();		// covergroup object allocation
  endfunction
  
  // sampling coverage -- stimuli
  task sample();
    forever begin
      mon2cov.get(trans);
      cg_dram.sample();
    end
  endtask
  
  task main();
    fork
      sample();			// calling sample task
       forever begin
        @done_coverage;
        $display("The Functional coverage = %0.2f%%\n", cg_dram.get_coverage());
         
         if(cg_dram.get_coverage() > 95)  
           $display("The TOTAL Functional coverage = 100.00%%\n");
        ->over;
      end
    join
  endtask
  
endclass