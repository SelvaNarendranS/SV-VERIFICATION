// Synchronous FIFO verification - interface
interface intf #(parameter WIDTH = 8, 
                 parameter DEPTH = 4);		// paramaterized interface
  // system
  logic 				clk;
  logic					reset;
  
  // input ports
  logic					wr_enable;
  logic 				rd_enable;
  logic [WIDTH - 1:0] 	data_in;
  
  // output ports
  logic [WIDTH -1:0]	data_out;
  logic					full;
  logic					empty;
  
  // driver clocking block
//   clocking 
endinterface