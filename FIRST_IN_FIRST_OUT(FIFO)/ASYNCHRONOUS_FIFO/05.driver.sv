// Asynchronous FIFO verification - driver

class driver #(WIDTH, DEPTH);
  
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  mailbox gen2drv;								// created mailbox b/w generator to driver for transfer package of information
  virtual intf #(WIDTH, DEPTH) vintf;			// virtual interface
  
  function new(virtual intf #(WIDTH, DEPTH) vintf, mailbox gen2drv);
    this.gen2drv = gen2drv;
    this.vintf   = vintf;
  endfunction
  
  task driver_main();
    
    forever begin
      gen2drv.get(trans);
      
      fork
        write_drive(trans);
        read_drive(trans);
      join
    end
  endtask
  
  // write domain
  task write_drive(transaction #(WIDTH, DEPTH) tr);
    @(vintf.wr_cb_drive);
    
    vintf.wr_cb_drive.wr_rst   <= trans.wr_rst;
    vintf.wr_cb_drive.wr_en    <= trans.wr_en;
    vintf.wr_cb_drive.data_in  <= trans.data_in;
    
    tr.display("Values received to WRITE DOMAIN driver");
       
  endtask
  
  // read domain
  task read_drive(transaction #(WIDTH, DEPTH) tr);
    @(vintf.rd_cb_drive);
    
    vintf.rd_cb_drive.rd_rst <= trans.rd_rst;
    vintf.rd_cb_drive.rd_en  <= trans.rd_en;
    
    tr.display("Values received to READ DOMAIN driver");
    
  endtask
endclass
      
