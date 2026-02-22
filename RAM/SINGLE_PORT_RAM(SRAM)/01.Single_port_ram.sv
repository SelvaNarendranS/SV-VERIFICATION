// SINGLE PORT RAM 

//  read first mode (read before write)

module single_port_ram #(parameter WIDTH = 8,
                         parameter DEPTH = 256) (
  input logic  				    	clk,			// system clock
  input logic 						en,
  input logic  				    	wr_en,			// write enable
  input logic [WIDTH-1:0]			data_in,
  input logic [$clog2(DEPTH)-1:0] 	addr,
  output logic [WIDTH-1:0]			data_out
);
  
  // memory
  reg [WIDTH-1:0]mem[DEPTH-1:0];	
  
//   read first(read before write)
  always_ff @(posedge clk) begin
    if(en) begin
      data_out <= mem[addr];	// read only 
      if(wr_en)
        mem[addr] <= data_in;		// write only
    end
    else
      data_out <= 0;
  end
  
  // write first(write and read next) 
//   always_ff @(posedge clk) begin
//     if(en) begin
//       if(wr_en) begin
//         mem[addr] <= data_in;		// write
//         data_out  = data_in;		// read -- write first read next
//       end
//       else
//         data_out <= mem[addr];	// read only
//     end
//     else
//       data_out <= 0;
//   end
  
endmodule