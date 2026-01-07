// monitor

class monitor;
  virtual intf vintf;
  mailbox mon2scr;
  
  function new(virtual intf vintf, mailbox mon2scr);
    this.vintf = vintf;
    this.mon2scr = mon2scr;
  endfunction
  
  task main();
    transaction trans;
    repeat(10) begin
      @(posedge vintf.clk);
      #1;
      trans = new();
      trans.d 	<= vintf.d;
      trans.reset <= vintf.reset;
      trans.q     <= vintf.q;
      trans.q_bar <= vintf.q_bar;
      trans.display("MONITOR");
      mon2scr.put(trans);
      
    end    
    
  endtask
endclass