// Synchronous FIFO verification - monitor
class monitor #(WIDTH, DEPTH);
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  mailbox mon2scr;								// created mailbox b/w monitor to scoreboard for transfer package of information
  virtual intf #(WIDTH, DEPTH) vintf;			// virtual interface
  
  function new(virtual intf #(WIDTH, DEPTH) vintf, mailbox mon2scr);
    this.mon2scr = mon2scr;
    this.vintf   = vintf;
  endfunction
  
  task monitor_main();
    
//     forever begin
    for(int i = 0; i < (DEPTH * 2); i++) begin
      @(posedge vintf.clk); #1;
      trans = new();			// creating object to store values from (design)virtual interface
      
      trans.rst 		= vintf.reset;
      trans.wr_en		= vintf.wr_enable; 	 
      trans.rd_en		= vintf.rd_enable;
      trans.data_in		= vintf.data_in;
      trans.data_out	= vintf.data_out;
      trans.full		= vintf.full;
      trans.empty		= vintf.empty;
      
      // sending the package to mailbox
      mon2scr.put(trans);
      trans.display("Value received to MONITOR");
    end
  endtask
endclass