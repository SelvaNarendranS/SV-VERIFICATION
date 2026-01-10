// Synchronous FIFO verification - design
module sync_fifo #(parameter WIDTH = 8, 
                   parameter DEPTH = 4) (
  // system
  input logic 				clk,
  input logic				reset,
  
  // input ports
  input logic				wr_enable,
  input logic 				rd_enable,
  input logic [WIDTH - 1:0] data_in,
  
  // output ports
  output logic [WIDTH -1:0]	data_out,
  output logic				full,
  output logic				empty
);
  
  // internal counter & memory
  logic [WIDTH - 1:0] mem[DEPTH - 1:0];
  logic [$clog2(DEPTH) - 1:0] wr_ptr;
  logic [$clog2(DEPTH) - 1:0] rd_ptr;
  
  // Write condition 
  always @(posedge clk) begin
    if(reset) begin			// reset condition
      wr_ptr   <= 0;
    end
    else if(wr_enable && !full) begin
      mem[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1'b1;
    end
  end
  
  // read condition 
  always @(posedge clk) begin
    if(reset) begin			// reset condition
      data_out <= 0;
      rd_ptr   <= 0;
    end
    else if(rd_enable && !empty) begin
      data_out <= mem[rd_ptr];
      rd_ptr   <= rd_ptr + 1'b1;
    end
  end
  
  // full & empty condition
  assign full  = (wr_ptr + 1'b1) == rd_ptr;
  assign empty = wr_ptr == rd_ptr;
endmodule  

// https://edaplayground.com/x/R4Uf