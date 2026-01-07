// generator class

class generator;
 
  mailbox gen2drv;			// mail box b/w genetator to driver
  
  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    transaction trans;		// handle for transaction
    
    repeat(10) begin
      trans = new();
      trans.randomize();
      trans.display("GENERATOR");
      gen2drv.put(trans);
    end
  endtask
endclass
      