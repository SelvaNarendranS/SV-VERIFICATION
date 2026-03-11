// Asynchronous FIFO verification - monitor

class monitor #(WIDTH, DEPTH);
  transaction #(WIDTH, DEPTH) trans_wr, trans_rd;			// transaction handle
  
  mailbox mon2scb_wr;						// created mailbox b/w monitor to scoreboard for transfer package of information
  mailbox mon2scb_rd;
  
  virtual intf #(WIDTH, DEPTH) vintf;			// virtual interface

  function new(virtual intf #(WIDTH, DEPTH) vintf, mailbox mon2scb_wr, mailbox mon2scb_rd);
    this.mon2scb_wr = mon2scb_wr;
    this.mon2scb_rd = mon2scb_rd;
    this.vintf   = vintf;
  endfunction
  
  task monitor_main();
    
      fork
        write_sample();		// write domain sampling
        read_sample();		// read domain sampling
      join_none
  endtask
  
  task write_sample();
    
    forever begin
      @(vintf.wr_cb_sample);

      trans_wr = new();
      trans_wr.wr_rst 	= vintf.wr_cb_sample.wr_rst;
      trans_wr.wr_en	= vintf.wr_cb_sample.wr_en;
      trans_wr.data_in	= vintf.wr_cb_sample.data_in;
      trans_wr.full		= vintf.wr_cb_sample.full;
      
      mon2scb_wr.put(trans_wr);		// passing transaction packet into write mailbox
      
      trans_wr.display("Value received to MONITOR WRITE DOMAIN ");
    end
  endtask
  
  task read_sample();
    
    forever begin
      @(vintf.rd_cb_sample);
      
      trans_rd = new();
      trans_rd.rd_rst 	= vintf.rd_cb_sample.rd_rst;
      trans_rd.rd_en	= vintf.rd_cb_sample.rd_en;
      trans_rd.data_out	= vintf.rd_cb_sample.data_out;
      trans_rd.empty	= vintf.rd_cb_sample.empty;
      
      mon2scb_rd.put(trans_rd);	// passing transaction packet into read mailbox
      
      trans_rd.display("Value received to MONITOR READ DOMAIN");
    end
  endtask

endclass
