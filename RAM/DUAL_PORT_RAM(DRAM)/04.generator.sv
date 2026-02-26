// dual port ram - generator

class generator #(WIDTH, DEPTH, MODE);
  
  mailbox gen2drv;		// mailbox b/w generator and driver
  transaction #(WIDTH, DEPTH, MODE) trans;		// transaction handle
  
  // event for next stimuli generation
  event over;
  event done_verify;		// overall done event 
  
  // function new constructor
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  // task to generate stimuli according to constraint
  task main();
    int i;
    #20;		// wait for the initial set up
    $display("----- GENERATOR STARTED ------");
    
    for(i=0; i < ((DEPTH * 2) + 2); i++) begin
      if(i == 0) begin
        $display("------------ Disable condition -----------");
        task_disable();
      end
      else if(i < (DEPTH/2)) begin
        $display("------------ PORT-A write condition -----------");
        port_a_write();
      end
      else if(i < DEPTH) begin
        $display("------------ PORT-B write condition -----------");
        port_b_write();
      end
      else if(i < ((DEPTH*2)/2)) begin
        $display("------------ PORT-A read condition -----------");
        port_a_read();
      end
      else if(i < (DEPTH*2)) begin
        $display("------------ PORT-B read condition -----------");
        port_b_read();
      end
      else if(i < (DEPTH*2) + 1) begin
        $display("------------ priority condition write -----------");
        priority_check_write();
      end
      else begin
        $display("------------ priority condition read -----------");
        priority_check_read();
      end

        @(over);			// event capture
    end
    ->done_verify;		// trigger overall finish event
    
  endtask
  
  // port-a write condition
  task port_a_write();
    trans = new();
    if (!trans.randomize() with {a_wr 	  == 1;
                                 b_wr 	  == 0;
                                en 		  == 1;})			// inline constraint
      $error("Randomization failed");
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("PORT-A WRITE GENERATED VALUES ");
 
  endtask
  
  // port-a read condition
  task port_a_read();
    trans = new();
    if (!trans.randomize() with {a_wr 	   == 0;
                                 a_data_in == 0;
                                 en 	   == 1;})			// inline constraint
      $error("Randomization failed");
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("PORT-A READ GENERATED VALUES ");
    
  endtask
  
  // port-b write condition
  task port_b_write();
    trans = new();
    if (!trans.randomize() with {b_wr 	  == 1;
                                 a_wr 	  == 0;
                                 en		  == 1;})			// inline constraint
      $error("Randomization failed");
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("PORT-B WRITE GENERATED VALUES ");
 
  endtask
  
  // port-b read condition
  task port_b_read();
    trans = new();
    if (!trans.randomize() with {b_wr 	   == 0;
                                 b_data_in == 0;
                                 en 	   == 1;})			// inline constraint
      $error("Randomization failed");
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("PORT-B READ GENERATED VALUES ");
    
  endtask    
  
  // disable condition
  task task_disable();
    trans = new();
    if(!trans.randomize() with {en == 0;})			// inline constraint
      $error("Randomization failed");
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display(" DISABLE GENERATED VALUES ");
    
  endtask
  
  int addr_temp;
  
  // priority checking
  task priority_check_write();
    
    // ------------ WRITE ------------
    trans = new();
    if(!trans.randomize() with {en 	  == 1; 
                               a_wr   == 1; 
                               b_wr   == 1;
                               a_addr == b_addr;
                              }) begin					// force randomize -- inline constraint
      $error("Randomization failed");
    end
    
    addr_temp = trans.a_addr;
    gen2drv.put(trans);
    trans.display(" PARITY CHECKING WRITE GENERATED VALUES ");
  endtask
    
  // priority checking
  task priority_check_read();
    // ------------ READ -------------
    trans = new();
    if(!trans.randomize() with {en 	  == 1; 
                               a_wr   == 0; 
                               b_wr   == 0;
                               a_addr == addr_temp;
                               b_addr == addr_temp;
                              }) begin					// force randomize -- inline constraint
      $error("Randomization failed");
    end
    
    gen2drv.put(trans);
    trans.display(" PARITY CHECKING READ GENERATED VALUES ");

  endtask
  
endclass