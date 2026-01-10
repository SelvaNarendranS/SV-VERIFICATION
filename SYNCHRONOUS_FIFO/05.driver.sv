// Synchronous FIFO verification - driver
class driver #(WIDTH, DEPTH);
  event done;
  transaction #(WIDTH, DEPTH) trans;			// transaction handle
  mailbox gen2drv;								// created mailbox b/w generator to driver for transfer package of information
  virtual intf #(WIDTH, DEPTH) vintf;			// virtual interface
  
  function new(virtual intf #(WIDTH, DEPTH) vintf, mailbox gen2drv);
    this.gen2drv = gen2drv;
    this.vintf   = vintf;
  endfunction
  
  task driver_main();
    
//     forever begin
     for(int i = 0; i < DEPTH * 2; i++) begin
      @(negedge vintf.clk);
      
      // getting packets of data from mailbox
      gen2drv.get(trans);
      
      // assigning values from transaction acket to virtual interface
      vintf.reset     = trans.rst;
      vintf.wr_enable = trans.wr_en;
      vintf.rd_enable = trans.rd_en;
      vintf.data_in   = trans.data_in;
      
      trans.display("Value received to DRIVER");
    end
  endtask
endclass
      