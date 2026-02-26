// dual port ram -- interface

interface intf #(parameter WIDTH = 8,
                 parameter DEPTH = 256,
                 parameter MODE = 0) (input logic clk);
  
  logic 					en;
  
  // port A
  logic 					a_wr;
  logic [$clog2(DEPTH)-1:0] a_addr;
  logic [WIDTH-1:0] 		a_data_in;
  logic [WIDTH-1:0]			a_data_out;
  
  // port B
  logic 					b_wr;
  logic [$clog2(DEPTH)-1:0] b_addr;
  logic [WIDTH-1:0] 		b_data_in;
  logic [WIDTH-1:0]			b_data_out;
  
  // clocking block
  
  // stimuli driving
  clocking cb_drive @(negedge clk);
    default input #1 output #2;
    output en, a_wr, a_addr, a_data_in, b_wr, b_addr, b_data_in;
    input a_data_out, b_data_out;
  endclocking
  
  // sampling
  clocking cb_sample @(posedge clk);
    default input #0;
    input en, a_wr, a_addr, a_data_in, b_wr, b_addr, b_data_in, a_data_out, b_data_out;
  endclocking
  
  // modport
  modport tb( 
    clocking cb_drive, 
    clocking cb_sample, 			// access through clocking block
    input a_data_out, b_data_out);		// testbench
    
endinterface