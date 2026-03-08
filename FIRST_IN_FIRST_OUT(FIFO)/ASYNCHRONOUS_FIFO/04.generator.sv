// Asynchronous FIFO verification - generator

class generator #(WIDTH, DEPTH);
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  mailbox gen2drv;								// created mailbox b/w generator to driver for transfer package of information
  
  // event
  event over;
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task generator_main();
    $display("Start of GENERATION");
    
    for(int i = 0; i < (DEPTH * 2); i++) begin
      trans = new();				// object allocation for each inputs
     if(i == 0) begin
       $display("---- RESET condition ----");
       trans.rst_cnst.constraint_mode(1);			// constraint mode ON
       trans.wr_cnst.constraint_mode(0);
       trans.rd_cnst.constraint_mode(0);
       trans.randomize();							// value generation
      end
      
      // full condition satisfy
      else if(i < DEPTH + 1) begin
        $display("---- FULL condition ----");
        trans.rst_cnst.constraint_mode(0);			// constraint mode OFF
        trans.wr_cnst.constraint_mode(1);
        trans.rd_cnst.constraint_mode(0);
        trans.randomize(); 			
      end
      
      // read condition
      else if(i < (DEPTH*2)) begin
        $display("---- READ condition ----");
        trans.rst_cnst.constraint_mode(0);				// constraint mode OFF
        trans.wr_cnst.constraint_mode(0);
        trans.rd_cnst.constraint_mode(1);
        trans.randomize();						
      end
      // putting generated valued as a packet to mailbox
      gen2drv.put(trans);
      trans.display("VALUES HAS BEEN GENERATED");
      
      // capture event
      @over;
    end
  endtask
endclass