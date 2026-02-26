// dual port ram -- monitor

class monitor #(WIDTH, DEPTH, MODE);
  
  mailbox mon2scb;		// mailbox b/w monitor to scoreboard
  mailbox mon2cov;		// mailbox b/w monitor to coverage
  
  transaction #(WIDTH, DEPTH, MODE) trans;		// transaction handle
  
  virtual intf #(WIDTH, DEPTH, MODE).tb vintf;		// virtual interface handle
  
  // function new constructor
  function new(mailbox mon2scb, mailbox mon2cov, virtual intf #(WIDTH, DEPTH, MODE).tb vintf);
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
    this.vintf   = vintf;
  endfunction
  
  // task sample outputs from dut
  task main();
    
    forever begin
      @(vintf.cb_sample);
      
      trans = new();			// creating object to transaction to store packet of sampled datas
      trans.en			= vintf.cb_sample.en;
      trans.a_wr		= vintf.cb_sample.a_wr;
      trans.a_addr		= vintf.cb_sample.a_addr;
      trans.a_data_in	= vintf.cb_sample.a_data_in;
      trans.a_data_out	= vintf.cb_sample.a_data_out;
      trans.b_wr		= vintf.cb_sample.b_wr;
      trans.b_addr		= vintf.cb_sample.b_addr;
      trans.b_data_in	= vintf.cb_sample.b_data_in;
      trans.b_data_out	= vintf.cb_sample.b_data_out;
      
      mon2scb.put(trans);		
      mon2cov.put(trans);			// passing values to the mailbox
      trans.display("SAMPLED VALUES IN MONITOR");
      
    end
  endtask
  
endclass