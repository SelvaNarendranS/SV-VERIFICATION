// Single port ram - interface
interface intf #(parameter WIDTH = 8, 
                 parameter DEPTH = 4);		// paramaterized interface

  // system
  logic						clk;
  
  // input ports
  logic 					en;
  logic  				    wr_en;			// write enable
  logic [WIDTH-1:0]			data_in;
  logic [$clog2(DEPTH)-1:0] addr;
  
  // output ports
  logic [WIDTH-1:0]			data_out;
  
  // clocking block
  
  // clocking for driving stimuli to dut
  clocking cb_driver @(negedge clk);		
    output #2 en, wr_en, data_in, addr;
    input #1 data_out;
  endclocking
  
  // clocking for sampling result from dut
  clocking cb_monitor @(posedge clk);
    default input #0;						// #0 to sample the input exactly at posedge to get imediate 
    input en, wr_en, data_in, addr, data_out;
  endclocking
  
endinterface