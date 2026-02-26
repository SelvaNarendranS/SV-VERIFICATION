// dual port ram -- scoreboard

class scoreboard #(WIDTH, DEPTH, MODE);
  
  mailbox mon2scb;		// mailbox b/w monitor to scoreboard
  transaction #(WIDTH, DEPTH, MODE) trans;		// transaction handle
  
  event done_coverage;			// trigger coverage
  
  int count = -1;
  
  // function new constrctor
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  // dual port ram memory -- for self checking
  reg [WIDTH-1:0] mem[int];			// depth is set as associative array
  
  task main();
    
    forever begin
      mon2scb.get(trans);		// getting packets from mailbox
      
      check(trans);				// calling task -- for evaluation
      
      count++;
      ->done_coverage;			// trigger event to generate next stimuli
    end
    
  endtask
  
  task check(transaction #(WIDTH, DEPTH, MODE) tr);
    bit 					enable;
  
    // port A
    bit 					pt_a_wr;
    bit [$clog2(DEPTH)-1:0] pt_a_addr;
    bit [WIDTH-1:0] 		pt_a_data_in;
    bit [WIDTH-1:0]			pt_a_data_out;
        
    // port B
    bit 					pt_b_wr;
    bit [$clog2(DEPTH)-1:0] pt_b_addr;
    bit [WIDTH-1:0] 		pt_b_data_in;
    bit [WIDTH-1:0]			pt_b_data_out;
        
    // getting values from modport and storing to variable
    enable 			= tr.en;
    pt_a_wr			= tr.a_wr;
    pt_a_addr 		= tr.a_addr;
    pt_a_data_out 	= tr.a_data_out;
    pt_a_data_in 	= tr.a_data_in;
    pt_b_wr			= tr.b_wr;
    pt_b_addr 		= tr.b_addr;
    pt_b_data_in 	= tr.b_data_in;
    pt_b_data_out 	= tr.b_data_out;
        
    tr.display("SCOREBOARD VALUE");
    if(count > 0) $display("%0d", count);
    
    self_checking(enable, pt_a_wr, pt_a_addr, pt_a_data_in, pt_a_data_out, pt_b_wr, pt_b_addr, pt_b_data_in, pt_b_data_out);		// calling self check function to check expected output
        
  endtask
      
      
  function void self_checking(
    input 					  en,
  
    // port A
    input 					  a_wr,
    input [$clog2(DEPTH)-1:0] a_addr,
    input [WIDTH-1:0] 		  a_data_in,
    input [WIDTH-1:0]		  a_data_out,
        
    // port B
    input 					  b_wr,
    input [$clog2(DEPTH)-1:0] b_addr,
    input [WIDTH-1:0] 		  b_data_in,
    input [WIDTH-1:0]	      b_data_out
  );
    
    bit [WIDTH-1:0] a_dataout_expected;
    bit [WIDTH-1:0] b_dataout_expected;
        
    // read first(read before write)
    if(MODE == 0) begin
      if(en) begin
        a_dataout_expected = mem[a_addr];		// port A read
        b_dataout_expected = mem[b_addr];		// port B read
      
        // priority setting
        if((a_wr && b_wr) && (a_addr == b_addr)) begin
          mem[a_addr] = a_data_in;			// port A has highest priority
        end
        else begin
          if(a_wr)
            mem[a_addr] = a_data_in;		// port A write
          if(b_wr)
            mem[b_addr] = b_data_in;		// port B write
        end
      end
      else begin
        a_dataout_expected = 0;
        b_dataout_expected = 0;
      end
    end
    
    else begin       
    // write first(write before read)
      if(en) begin      
        // priority setting
        if((a_wr && b_wr) && (a_addr == b_addr)) begin
          mem[a_addr]		 = a_data_in;			// port A has highest priority
          a_dataout_expected = a_data_in;
          b_dataout_expected = a_data_in;
        end
      
        else begin
         // port A
          if(a_wr) begin
            mem[a_addr] 	   = a_data_in;		// port A write
            a_dataout_expected = a_data_in;
          end
         else
            a_dataout_expected = a_data_in;		// read only port A
        
          // port B
          if(b_wr) begin
            mem[b_addr] 	   = b_data_in;		// port B write
            b_dataout_expected = b_data_in;
          end
          else
            b_dataout_expected = b_data_in;		// read only port B
        end
      end
      else begin
        a_dataout_expected = 0;
        b_dataout_expected = 0;
      end
    end
        
    // self checking evaluation comparison -- expected Vs dut output
    if((a_dataout_expected == a_data_out) && (b_dataout_expected == b_data_out)) begin
      $display("--------------------------------------------");
      $display("                    PASS");
      $display("--------------------------------------------");
    end
    else begin
      $display("--------------------------------------------");
      $display("                    FAIL                     a_dataout_expected = %0d | b_dataout_expected = %0d", a_dataout_expected, b_dataout_expected);
      $display("--------------------------------------------");
    end
    ->done_coverage;		// trigger coverage event
    
  endfunction
  
endclass