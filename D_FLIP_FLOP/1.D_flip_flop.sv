// D Flip flop
module d_flip_flop(
  input logic clk, reset, d,
  output logic q, q_bar);
  
  always_ff @( posedge clk)
    begin
      if(reset)
        q <= 0;
      else 
        q <= d;
    end
  
  assign q_bar = ~q;
endmodule  

// https://edaplayground.com/x/HuWH