// single port ram -- SCOREBOARD

class scoreboard #(WIDTH, DEPTH);
  
  mailbox mon2scb;		// mailbox b/w generator and driver
  transaction #(WIDTH, DEPTH) trans;		// transaction handle
  coverage #(WIDTH, DEPTH) cov;				// coverage handle
  int count = 1;
  
  // event for next stimuli generation
  event next;
  
  // function new constructor
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
  endfunction
  
  // setting coverage to scoreboard
  function void set_coverage(coverage #(WIDTH, DEPTH) cov);
    this.cov = cov;
  endfunction
  
  // single port ram memory
  reg [WIDTH-1:0]mem[int];			// associative array for depth of spram memory locations
  
  task main();
    for(int i=0; i < ((DEPTH * 2) + 1); i++) begin
      mon2scb.get(trans);
      check(trans);
      
      if(cov != null)
        cov.coverage_report();			// calling function in coverage to print report of coverage
      
      if(count >= (DEPTH*2)+1) begin
        if(cov.sram_cg.get_coverage() > 95)
          $display("THE TOTAL FUNCTIONAL COVERAGE = 100.00%%" );
      end
      
      count++;
      ->next;		// event trigger
      
    end
  endtask
  
  function void check(transaction #(WIDTH, DEPTH) tr);
    
    bit 					enable;
    bit 					wr;
    bit [WIDTH-1:0]			datain;
    bit [$clog2(DEPTH)-1:0] address;
    bit [WIDTH-1:0]			dataout;

    // getting values from modport and storing to variable
    enable 	 = tr.en;
    wr 		 = tr.wr_en;
    datain 	 = tr.data_in;
    address  = tr.addr;
    dataout  = tr.data_out;
    
    tr.display("SCOREBOARD VALUE");
    $display("%0d", count);
    
    self_check(enable, wr, datain, address, dataout);	// calling self check function
    
  endfunction
  
  // self checking condition
  function void self_check( 
    input bit 					  en, 
    input bit 					  wr_en,
    input bit [WIDTH-1:0] 	 	  data_in,
    input bit [$clog2(DEPTH)-1:0] addr,
    input bit [WIDTH-1:0] 	 	  data_out
  );
    bit [WIDTH-1:0] expected_data_out = 0;
    
    //   read first(read before write)
    if(en) begin
      expected_data_out = mem[addr];	// read only
      if(wr_en)
        mem[addr] 	= data_in;		// write
    end
    else 
      expected_data_out = 0;
        
    
    // write first(write and read next) 
//     if(en) begin
//       if(wr_en) begin
//         mem[addr] = data_in;		// write
//         expected_data_out = data_in;		// read -- write first read next
//       end
//       else
//         expected_data_out = mem[addr];	// read only
//     end
//     else
//       expected_data_out = 0;
    
    // self checking evaluation comparison -- expected Vs dut output
    if(expected_data_out == data_out) begin
      $display("--------------------------------------------");
      $display("                    PASS");
      $display("--------------------------------------------");
    end
    else begin
      $display("--------------------------------------------");
      $display("                    FAIL                     expected = %0d", expected_data_out);
      $display("--------------------------------------------");
    end
    
  endfunction
  
endclass
