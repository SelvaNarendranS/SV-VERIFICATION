// Asynchronous FIFO verification - interface

interface intf #(parameter WIDTH = 8, 
                 parameter DEPTH = 4);		// paramaterized interface
  // write domain
  logic 				wr_clk;
  logic 				wr_rst;
  logic 				wr_en;
  logic [WIDTH -1 :0]	data_in;
  logic 				full;

  // read domain
  logic 				rd_clk;
  logic 				rd_rst;
  logic 				rd_en;
  logic [WIDTH -1 :0] 	data_out;
  logic 				empty;
  
  // clocking block
  // write clocking block -- drive
  clocking wr_cb_drive @(negedge wr_clk);
    default input #1ns output #1ns;
    output  wr_rst, wr_en, data_in;
    input full;
  endclocking
  
  // read clocking block  -- drive
  clocking rd_cb_drive @(negedge rd_clk);
    default input #1ns output #1ns;
    output  rd_rst, rd_en;
    input data_out, empty;
  endclocking
  
  // write clocking block -- sample
  clocking wr_cb_sample @(posedge wr_clk);
    default input #0;
    input wr_rst, wr_en, data_in, full;
  endclocking
  
  // read clocking block -- sample
  clocking rd_cb_sample @(posedge rd_clk);
    default input #0;
    input rd_rst, rd_en, data_out, empty;
  endclocking  
  
  // modport
  
endinterface
