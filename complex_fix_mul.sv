// Multiplies two complex numbers.
// TODO: allow configurable return precision.
`timescale 1ns / 1ns
module complex_fix_mul (x, y, out);
  parameter IN_BITS = 19, OUT_BITS = 20;
  input  signed [ IN_BITS-1:0] x   [0:1];
  input  signed [ IN_BITS-1:0] y   [0:1];
  output signed [OUT_BITS-1:0] out [0:1];

  parameter SIMULATE = 0;
  localparam REAL = 0, IMAG = 1;

  wire signed [IN_BITS-1:0] a = x[REAL];
  wire signed [IN_BITS-1:0] b = x[IMAG];

  wire signed [IN_BITS-1:0] c = y[REAL];
  wire signed [IN_BITS-1:0] d = y[IMAG];

  wire signed [OUT_BITS-2:0] ac, bd, bc, ad;

  // (a+bi)(c+di) = (ac-bd) + (bc-ad)i
  fixmul #(IN_BITS, OUT_BITS-1) mult_ac(a, c, ac);
  fixmul #(IN_BITS, OUT_BITS-1) mult_bd(b, d, bd);
  fixmul #(IN_BITS, OUT_BITS-1) mult_bc(b, c, bc);
  fixmul #(IN_BITS, OUT_BITS-1) mult_ad(a, d, ad);

  // TODO: try to get better precision via rounding.
  // TODO: watch out for ones!
  assign out[REAL] = {ac[OUT_BITS-2], ac} - {bd[OUT_BITS-2], bd};
  assign out[IMAG] = {bc[OUT_BITS-2], bc} + {ad[OUT_BITS-2], ad};
endmodule
