class generator;
  transaction trans;	// created class handle
  mailbox gen2drv;      // creating mailbox bridge b/w generator to drive
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    trans = new(); 		// creating object
    repeat(3) begin
      trans.randomize();
      trans.display("Generation of values");
      assert(trans.randomize())
        else 
          trans.display("Generation failed");
      gen2drv.put(trans);		// Sending generated values to mailbox
      end
  endtask
endclass    