// single port ram -- MONITOR

class monitor #(WIDTH, DEPTH);
  
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  virtual intf #(WIDTH, DEPTH) vintf;		// virtual interface
  mailbox mon2scb;				// mailbox b/w monitor to scoreboard
  
  function new(mailbox mon2scb, virtual intf #(WIDTH, DEPTH) vintf);
    this.mon2scb = mon2scb;
    this.vintf = vintf;
  endfunction
  
  // task sample - sample input and output from dut
  task main();
    
    for(int i=0; i < ((DEPTH * 2) + 1); i++) begin
      trans = new();
      
      @(vintf.cb_monitor);
      trans.en			= vintf.cb_monitor.en;
      trans.wr_en		= vintf.cb_monitor.wr_en;
      trans.data_in		= vintf.cb_monitor.data_in;
      trans.addr		= vintf.cb_monitor.addr;
      trans.data_out	= vintf.cb_monitor.data_out;
    
      mon2scb.put(trans);
      trans.display("MONITOR VALUES");
    end
  endtask
  
endclass
    