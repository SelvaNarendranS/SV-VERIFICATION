`include "Test.sv"
`include "Interface.sv"

module testbench;
  
  intf intff(); 			// interface
  test tst(intff);			// Test
  
  // instantiation
  full_adder fadder(.a(intff.a),
                    .b(intff.b),
                    .c(intff.c),
                    .sum(intff.sum),
                    .carry(intff.carry));
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule