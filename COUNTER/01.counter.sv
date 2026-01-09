 // counter verification - design
module counter #(parameter WIDTH = 8) (
  input logic                clk, 
  input logic 			     reset,
  input logic 				 enable,
  input logic   			 up_down,	// up = 1, down = 0
  output logic [WIDTH - 1:0] q			// output 
);
  
  always @(posedge clk) begin
    if(reset) begin
      q <= 0;
    end
    else if(enable) begin
      if(up_down) 
        q <= q + 1;
      else
        q <= q - 1;
    end
  end
endmodule

// https://edaplayground.com/x/fFwG