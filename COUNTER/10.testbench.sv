// Counter verification - Testbench
`include "test.sv"
`include "interface.sv"

module testbench;
  parameter WIDTH = 4;				// counter size
  
  intf #(WIDTH) intff();			// interface handle
  test #(WIDTH) tst(intff);			// passing interface to the test
  
  // instantation
  counter #(.WIDTH(WIDTH)) 
  dut(
    .clk(intff.clk),
    .reset(intff.reset),
    .enable(intff.enable),
    .up_down(intff.up_down),
    .q(intff.q)
  );
  
  initial intff.clk = 1;
  initial forever #5 intff.clk = ~intff.clk;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    #10000 $finish;
  end
endmodule