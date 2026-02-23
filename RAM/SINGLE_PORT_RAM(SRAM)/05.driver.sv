// single port ram -- DRIVER

class driver #(WIDTH, DEPTH);
  
  mailbox gen2drv;		// mailbox b/w generator and driver
  transaction #(WIDTH, DEPTH) trans;		// transaction handle
  
  virtual intf #(WIDTH, DEPTH) vintf;
  
  // function new constructor
  function new(mailbox gen2drv, virtual intf #(WIDTH, DEPTH) vintf);
    this.gen2drv = gen2drv;
    this.vintf = vintf;
  endfunction
  
  // task drive -- drive input signals to dut
  task main();
    
    for(int i=0; i < ((DEPTH * 2) + 1); i++) begin
      @(vintf.cb_driver);
      gen2drv.get(trans);
      
      vintf.cb_driver.en 		<= trans.en;
      vintf.cb_driver.wr_en 	<= trans.wr_en;
      vintf.cb_driver.data_in 	<= trans.data_in;
      vintf.cb_driver.addr 		<= trans.addr;
    
      trans.display(" DRIVER VALUES ");
    end
    
  endtask
  
endclass