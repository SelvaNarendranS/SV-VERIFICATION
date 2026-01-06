class monitor;
  virtual intf vint;		// creating vritual interface and handle name
  mailbox mon2scb;
  
  function new(virtual intf vint, mailbox mon2scb);
    this.vint    = vint;
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
    repeat(3) begin
      transaction trans;
      trans = new();
      
      #1;
      trans.a     = vint.a;
      trans.b     = vint.b;
      trans.c     = vint.c;
      trans.sum   = vint.sum;
      trans.carry = vint.carry;
      
      mon2scb.put(trans);
      trans.display("Monitor Received");
    end
  endtask
endclass