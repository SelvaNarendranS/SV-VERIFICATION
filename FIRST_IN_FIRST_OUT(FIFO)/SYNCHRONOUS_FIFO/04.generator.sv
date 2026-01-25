// Synchronous FIFO verification - generator
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
       $display("---- RESET condition | write en = 1 ----");
        trans.rst_rand.constraint_mode(1);			// constraint mode ON
        trans.randomize();							// value generation
        trans.wr_en = 1;
        trans.rd_en = 0;
      end
      
      // full condition satisfy
      else if(i < DEPTH + 1) begin
        $display("---- FULL condition ----");
        trans.rst_rand.constraint_mode(0);			// constraint mode OFF
        trans.randomize() with {rst == 0;};			// force randomize
        trans.wr_en = 1;
      end
      
      // read condition
      else if(i < (DEPTH*2)) begin
        $display("---- READ condition ----");
        trans.rst_rand.constraint_mode(0);				// constraint mode OFF
        trans.randomize() with {rst == 0; data_in == 0;};			// force randomize
        trans.rd_en = 1;
      end
      // putting generated valued as a packet to mailbox
      gen2drv.put(trans);
      trans.display("VLALUES HAS BEEN GENERATED");
      
      // capture event
      @over;
    end
  endtask
endclass
