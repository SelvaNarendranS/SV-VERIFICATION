// Counter verification - interface
interface intf #(parameter WIDTH = 8);
  logic              clk;
  logic              reset;
  logic              enable;
  logic              up_down;
  logic [WIDTH -1:0] q;
endinterface