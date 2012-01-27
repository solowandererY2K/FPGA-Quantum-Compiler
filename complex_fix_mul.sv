// Multiplies two complex numbers.
module complex_fix_mul (
  input  [18:0] x   [0:1],
  input  [18:0] y   [0:1],
  output [18:0] out [0:1]
);

  parameter SIMULATE = 0;
  localparam REAL = 0, IMAG = 1;

  wire [18:0] a = x[REAL];
  wire [18:0] b = x[IMAG];

  wire [18:0] c = y[REAL];
  wire [18:0] d = y[IMAG];

  wire [18:0] ac, bd, bc, ad;

  // (a+bi)(c+di) = (ac-bd) + (bc-ad)i
  fixmul mult_ac(a, c, ac);
  fixmul mult_bd(b, d, bd);
  fixmul mult_bc(b, c, bc);
  fixmul mult_ad(a, d, ad);

  // TODO: try to get better precision via rounding.
  assign out[REAL] = ac - bd;
  assign out[IMAG] = bc + ad;
endmodule
