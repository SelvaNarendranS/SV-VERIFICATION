// Counter verification - Generator
class generator #(parameter WIDTH);
  transaction #(WIDTH) trans;			// transaction class handle
  mailbox gen2drv;				// mailbox b/w genetator and driver
  
  // event
  event next;
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task gen_main();
    
    begin
      $display("------------ up count --------------");
      up();					// up count only
      
      $display("------------ down count --------------");
      down();				// down count only
      
      $display("------------ up & down count --------------");
      updown();				// up and down count random
    end
  endtask
  
  // up count only
  task up();			
    trans = new();			// object allocation to transaction handle
    trans.reset = 1;
    trans.display("GENERATION of reset");	#1;
    gen2drv.put(trans);
    
    // event capture
      @next;
    
    repeat((2**WIDTH) - 1) begin
      trans = new();			// object allocation to transaction handle
      trans.reset   = 0;
      trans.enable  = 1;
      trans.up_down = 1;	
      trans.display("GENERATION of up counting");	
      
      gen2drv.put(trans);	// putting assigned values to mailbox
      
      // event capture
      @next;
    end
  endtask
  
  // down count only
  task down();			
    trans = new();			// object allocation to transaction handle
    trans.reset = 1;
    trans.display("GENERATION of reset");	#1;
    gen2drv.put(trans);
    
    // event capture
      @next;
    
    repeat((2**WIDTH)) begin
      trans = new();			// object allocation to transaction handle
      trans.reset   = 0;
      trans.enable  = 1;
      trans.up_down = 0;	
      trans.display("GENERATION of values for down counting");	
      
      gen2drv.put(trans);	// putting assigned values to mailbox
      
      // event capture
      @next;
    end
  endtask
  
  // up count only
  task updown();			
    trans = new();			// object allocation to transaction handle
    trans.reset = 1;
    trans.display("GENERATION of reset");	#1;
    gen2drv.put(trans);
    
    // event capture
      @next;
    
    repeat((2**WIDTH)/2) begin
      trans = new();			// object allocation to transaction handle
      trans.reset   = 0;
      trans.enable  = 1;
      trans.up_down = 1;	
      trans.display("GENERATION of values for up_down counting");	
      
      gen2drv.put(trans);	// putting assigned values to mailbox
      
      // event capture
      @next;
    end
      
     repeat((2**WIDTH)/2) begin
      trans.reset   = 0;
      trans.enable  = 1;
      trans.up_down = 0;	
       trans.display("GENERATION of values for up_down counting");	
      
      gen2drv.put(trans);	// putting assigned values to mailbox
       
       // event capture
      @next;
     end
  endtask
endclass