// driver
class driver;
  
  virtual intf vintf;
  mailbox gen2drv;
  
  function new(virtual intf vintf, mailbox gen2drv);
    this.gen2drv = gen2drv;
    this.vintf   = vintf;
  endfunction
  
  task main();
    transaction trans;
    
    repeat(10) begin
      @(negedge vintf.clk)
      gen2drv.get(trans);
      
      vintf.d     = trans.d;
      vintf.reset = trans.reset;
      trans.display("DRIVER");
    end
    endtask
endclass