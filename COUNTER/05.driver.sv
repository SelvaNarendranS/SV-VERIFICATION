// Counter verification - Driver
class driver #(parameter WIDTH);
  transaction #(WIDTH) trans;        // transaction handle 
  virtual intf #(WIDTH) vintf;		// created virtual interface
  mailbox gen2drv;					// created mailbox mailbox b/w genetator and driver
  
  function new(virtual intf #(WIDTH) vintf, mailbox gen2drv);
    this.gen2drv = gen2drv;
    this.vintf   = vintf;
  endfunction
  
  task drv_main();
    
    forever begin
      @(negedge vintf.clk);
      
      gen2drv.get(trans);			// getting value from mailbox
      
      vintf.reset   <= trans.reset;
      vintf.enable  <= trans.enable;
      vintf.up_down <= trans.up_down;		// passing generated values to virtual interface      
      trans.display("Received value to DRIVER");
    end
  endtask
endclass