// Synchronous FIFO verification - testbench
`include "interface.sv"
`include "test.sv"

module tectbench;
  
  parameter WIDTH = 8;
  parameter DEPTH = 16;
  
  intf #(WIDTH, DEPTH) intff();				// interface handle
  test #(WIDTH, DEPTH) tst(intff);			// creating test handle and passing interface to the test
  
  // instantation
  sync_fifo #(WIDTH, DEPTH) 
  dut(
    .clk(intff.clk),
    .reset(intff.reset),
    .wr_enable(intff.wr_enable), 
    .rd_enable(intff.rd_enable),
    .data_in(intff.data_in), 
    .data_out(intff.data_out), 
    .full(intff.full), 
    .empty(intff.empty));		
  
  initial begin
    intff.clk = 1;
    forever #5 intff.clk = ~intff.clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    #400;
    $finish;
  end
endmodule
