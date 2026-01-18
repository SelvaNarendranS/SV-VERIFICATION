// Asynchronous FIFO verification - testbench
`include "interface.sv"
`include "test.sv"

module tectbench;
  
  parameter WIDTH = 8;
  parameter DEPTH = 16;
  
  intf #(WIDTH, DEPTH) intff();				// interface handle
  test #(WIDTH, DEPTH) tst(intff);			// creating test handle and passing interface to the test
  
  // instantation
  async_fifo #(.WIDTH(WIDTH),
               .DEPTH(DEPTH)) 
  dut (.wr_clk	(intff.wr_clk), 
       .wr_rst	(intff.wr_rst), 
       .wr_en	(intff.wr_en), 
       .data_in	(intff.data_in),
       .full	(intff.full),
       .rd_clk	(intff.rd_clk),
       .rd_rst	(intff.rd_rst), 
       .rd_en	(intff.rd_en), 
       .data_out(intff.data_out),
       .empty	(intff.empty));
		
  
  // write domain clock generation
  initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;
  end
  
  // read domain clock generation
  initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    #400;
    $finish;
  end
endmodule
