// Dual port ram

module dual_port_ram #(parameter WIDTH = 8,
                       parameter DEPTH = 256,
                       parameter MODE = 0) (		// mode0 - read first, mode1 - write first
  
  input 					clk,
  input 					en,
  
  // port A
  input 					a_wr,
  input [$clog2(DEPTH)-1:0] a_addr,
  input [WIDTH-1:0] 		a_data_in,
  output reg [WIDTH-1:0]	a_data_out,
  
  // port B
  input 					b_wr,
  input [$clog2(DEPTH)-1:0] b_addr,
  input [WIDTH-1:0] 		b_data_in,
  output reg [WIDTH-1:0]	b_data_out
);
  
  // memory
  reg [WIDTH-1:0] mem [DEPTH-1:0];
  
  // read first(read before write) -- mode0
  always @(posedge clk) begin
    if(MODE == 0) begin
      if(en) begin
        a_data_out <= mem[a_addr];		// port A read
        b_data_out <= mem[b_addr];		// port B read
      
        // priority setting
        if((a_wr && b_wr) && (a_addr == b_addr)) begin
          mem[a_addr] <= a_data_in;			// port A has highest priority
        end
      
        else begin
          if(a_wr)
            mem[a_addr] <= a_data_in;		// port A write
          if(b_wr)
            mem[b_addr] <= b_data_in;		// port B write
        end
      end
      else begin
        a_data_out <= 0;
        b_data_out <= 0;
      end
    end
    
    else begin
    // write first(write before read)
      if(en) begin      
        // priority setting
        if((a_wr && b_wr) && (a_addr == b_addr)) begin
          mem[a_addr] <= a_data_in;			// port A has highest priority
          a_data_out  <= a_data_in;
          b_data_out  <= a_data_in;
        end
      
        else begin
          // port A
          if(a_wr) begin
            mem[a_addr] <= a_data_in;		// port A write
            a_data_out  <= a_data_in;
          end
          else
            a_data_out  <= a_data_in;		// read only port A
        
          // port B
          if(b_wr) begin
            mem[b_addr] <= b_data_in;		// port B write
            b_data_out  <= b_data_in;
          end
          else
            b_data_out  <= b_data_in;		// read only port B
        end
      end
      else begin
        a_data_out <= 0;
        b_data_out <= 0;
      end
    end
  end
  
endmodule

// https://edaplayground.com/x/mwL5