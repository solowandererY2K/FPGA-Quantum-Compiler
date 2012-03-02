`timescale 1ns / 1ns
module add_ex(a, b, out);
  parameter BITS_IN = 19;
  input  signed [BITS_IN-1:0] a;
  input  signed [BITS_IN-1:0] b;
  output signed [BITS_IN  :0] out;
  assign out = {a[BITS_IN-1], a} + {b[BITS_IN-1], b};
endmodule
