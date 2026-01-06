class driver;
  virtual intf vint;		// creating vritual interface and handle name
 
  mailbox gen2drv;
  
  function new(virtual intf vint,mailbox gen2drv);
    this.vint    = vint;
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    repeat(3) begin
      transaction trans;
      gen2drv.get(trans);		// getting values from mailbox
      
      vint.a <= trans.a;
      vint.b <= trans.b;
      vint.c <= trans.c;
      #1;
      
      trans.display("Received values to driver");
    end
  endtask
endclass  