// Multiplies two complex numbers.
// TODO: allow configurable return precision.
module complex_fix_mul (
  input  signed [18:0] x   [0:1],
  input  signed [18:0] y   [0:1],
  output signed [19:0] out [0:1]
);

  parameter SIMULATE = 0;
  localparam REAL = 0, IMAG = 1;

  wire signed [18:0] a = x[REAL];
  wire signed [18:0] b = x[IMAG];

  wire signed [18:0] c = y[REAL];
  wire signed [18:0] d = y[IMAG];

  wire signed [18:0] ac, bd, bc, ad;

  // (a+bi)(c+di) = (ac-bd) + (bc-ad)i
  fixmul mult_ac(a, c, ac);
  fixmul mult_bd(b, d, bd);
  fixmul mult_bc(b, c, bc);
  fixmul mult_ad(a, d, ad);

  // TODO: try to get better precision via rounding.
  // TODO: watch out for ones!
  assign out[REAL] = {ac[18], ac} - {bd[18], bd};
  assign out[IMAG] = {bc[18], bc} + {ad[18], ad};
endmodule
