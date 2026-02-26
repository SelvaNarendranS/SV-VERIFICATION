// dual port ram --- driver

class driver #(WIDTH, DEPTH, MODE);
  
  mailbox gen2drv;		// mailbox b/w generator and driver
  transaction #(WIDTH, DEPTH, MODE) trans;		// transaction handle
  
  virtual intf #(WIDTH, DEPTH, MODE).tb vintf;		// virtual interface handle
  
  // function new constructor
  function new(mailbox gen2drv, virtual intf #(WIDTH, DEPTH, MODE).tb vintf);
    this.gen2drv = gen2drv;
    this.vintf   = vintf;
  endfunction
  
  // task drive -- drive input signals to dut
  task main();
    
    forever begin
      @(vintf.cb_drive);
      gen2drv.get(trans);
      
      vintf.cb_drive.en 		<= trans.en;
      vintf.cb_drive.a_wr		<= trans.a_wr;
      vintf.cb_drive.a_addr 	<= trans.a_addr;
      vintf.cb_drive.a_data_in 	<= trans.a_data_in;
      vintf.cb_drive.b_wr		<= trans.b_wr;
      vintf.cb_drive.b_addr 	<= trans.b_addr;
      vintf.cb_drive.b_data_in 	<= trans.b_data_in;
      
      trans.display("RECEIVED VALUES TO DRIVER");
    end
  endtask
  
endclass