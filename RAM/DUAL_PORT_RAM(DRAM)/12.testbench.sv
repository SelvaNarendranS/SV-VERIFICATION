// dual port ram testbench

`timescale 1ns/1ps

`include "interface.sv"
`include "test.sv"

module testbench;
  parameter WIDTH = 4;
  parameter DEPTH = 8;
  parameter MODE  = 0;		// mode0 - read first, mode1 - write first
  bit clk;
  
  intf #(WIDTH, DEPTH, MODE) intff(clk);				// interface handle 
  test #(WIDTH, DEPTH, MODE) tst(intff.tb);		// test handle and passing interface modport as arguments
  
  // instantation
  dual_port_ram #(.WIDTH(WIDTH),
                  .DEPTH(DEPTH),
                  .MODE(MODE))
  dut(.clk		  (clk),
      .en 		  (intff.en),
      
      // port A
      .a_wr		  (intff.a_wr),
      .a_addr	  (intff.a_addr),
      .a_data_in  (intff.a_data_in),
      .a_data_out (intff.a_data_out),
      
      // port B
      .b_wr		  (intff.b_wr),
      .b_addr	  (intff.b_addr),
      .b_data_in  (intff.b_data_in),
      .b_data_out (intff.b_data_out)
     );
  
  // clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial begin
    #200;
    $finish;
  end
  
endmodule