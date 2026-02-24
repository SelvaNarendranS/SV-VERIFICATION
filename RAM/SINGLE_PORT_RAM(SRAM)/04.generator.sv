// single port ram - generator

class generator #(WIDTH, DEPTH);
  
  mailbox gen2drv;		// mailbox b/w generator and driver
  transaction #(WIDTH, DEPTH) trans;		// transaction handle
  
  // event for next stimuli generation
  event next;
  
  // function new constructor
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  // task to generate stimuli according to constraint
  task main();
    int i;
    $display("----- GENERATOR STARTED ------");
    
    for(i=0; i < ((DEPTH * 2) + 1); i++) begin
      if(i == 0) begin
        $display("------------ Disable condition -----------");
        task_disable();
      end
      else if(i < DEPTH) begin
        $display("------------ write condition -----------");
        write();
      end
      else begin
        $display("------------ read condition -----------");
        read();
      end

      @(next);			// event capture
    end
    
  endtask
  
  // write condition
  task write();
    trans = new();
    trans.wr_en.rand_mode(0);
    trans.randomize();
    trans.wr_en = 1;
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("WRITE GENERATED VALUES ");
 
//     @next;		// capture event
  endtask
  
  // read condition
  task read();
    trans = new();
    trans.wr_en.rand_mode(0);
    trans.data_in.rand_mode(0);
    trans.randomize();
    trans.wr_en = 0;
    trans.en = 1;
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display("READ GENERATED VALUES ");
  endtask
    
  
  // disable condition
  task task_disable();
    trans = new();
    trans.en.rand_mode(0);
    trans.randomize();
    trans.en = 0;
    
    gen2drv.put(trans);				// putting transaction packets to mailbox
    trans.display(" DISABLE GENERATED VALUES ");
  endtask
  

endclass
