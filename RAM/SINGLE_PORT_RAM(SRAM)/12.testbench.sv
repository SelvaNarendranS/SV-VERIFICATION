// Single port ram - testbench

`include "interface.sv"
`include "test.sv"

module tectbench;
  
  parameter WIDTH = 4;
  parameter DEPTH = 8;
  bit clk;
  
  intf #(WIDTH, DEPTH) tb_intff(clk);				// interface handle
  test #(WIDTH, DEPTH) tst(tb_intff);			// creating test handle and passing interface to the test
  
  // instantation
  single_port_ram #(.WIDTH(WIDTH),
                    .DEPTH(DEPTH)) 
  spram (.clk	   (clk),
         .en	   (tb_intff.en),
         .wr_en	   (tb_intff.wr_en),
         .data_in  (tb_intff.data_in),
         .addr	   (tb_intff.addr),
         .data_out (tb_intff.data_out)
        );
  
  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
    #400;
    $finish;
  end
endmodule