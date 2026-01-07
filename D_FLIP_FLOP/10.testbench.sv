// test bench

`include "test.sv"
`include "interface.sv"

module testbench;
  intf intff();			// interface instance
  test tst(intff);		// test
  
  // instantation
  d_flip_flop inst (.clk(intff.clk), 
                    .reset(intff.reset), 
                    .d(intff.d), 
                    .q(intff.q), 
                    .q_bar(intff.q_bar));
  
  // clock generation
  initial intff.clk = 1;
  always #5 intff.clk = ~intff.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    #10000 $finish;
  end
endmodule