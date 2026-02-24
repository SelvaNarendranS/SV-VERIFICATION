//  single port ram -- COVERAGE

class coverage #(WIDTH, DEPTH);
  
  transaction #(WIDTH, DEPTH) trans;   	// transaction handle
  mailbox mon2cov;		// mailbox b/w monitor to coverage
   
  // coverage
  covergroup sram_cg;
    option.per_instance = 1;
    option.comment = "SRAM coverage";
    
    // covering enable and write 
    ENABLE : coverpoint trans.en{
      bins active = {1};
    }
    
    WRITE  : coverpoint trans.wr_en;
    
    // covering address
    ADDRESS : coverpoint trans.addr;
    
    // merging all conditions
    MRG : cross ENABLE, WRITE, ADDRESS;
    
  endgroup
  
  // function new constructor
  function new(mailbox mon2scb);
    this.mon2cov = mon2scb;
    sram_cg = new();
  endfunction
  
  task main();
    forever begin
      mon2cov.get(trans);		// sampling data from mailbox
      sram_cg.sample();		  	// coverage sampling
    end
  endtask
  
  function void coverage_report();
    $display("The Functional coverage = %0.2f%%\n", sram_cg.get_inst_coverage());
  endfunction
  
endclass