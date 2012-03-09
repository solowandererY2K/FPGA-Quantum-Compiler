// Multiplies two complex numbers.
// TODO: allow configurable return precision.
`timescale 1ns / 1ns
module complex_fix_mul_clocked (clk, reset, x, y, out, available, ready);
  parameter IN_BITS = 37, OUT_BITS = 38;
  input  signed [ IN_BITS-1:0] x   [0:1];
  input  signed [ IN_BITS-1:0] y   [0:1];
  output signed [OUT_BITS-1:0] out [0:1];

  parameter SIMULATE = 0;
  localparam REAL = 0, IMAG = 1;

  wire signed [IN_BITS-1:0] a = x[REAL];
  wire signed [IN_BITS-1:0] b = x[IMAG];

  wire signed [IN_BITS-1:0] c = y[REAL];
  wire signed [IN_BITS-1:0] d = y[IMAG];

  reg  signed [OUT_BITS-2:0] ac, bd, bc, ad;
  wire signed [OUT_BITS-2:0] aw, bw;

  input clk, reset, ready;

  output reg available;

  // Switches between the two sets of computations.
  reg switch;

  // The original circuit is replicated using a clocked form:
  // (a+bi)(c+di) = (ac-bd) + (bc-ad)i
  // fix_mul #(IN_BITS, OUT_BITS-1) mult_ac(a, c, ac_w);
  // fix_mul #(IN_BITS, OUT_BITS-1) mult_bd(b, d, bd_w);
  // fix_mul #(IN_BITS, OUT_BITS-1) mult_bc(b, c, bc_w);
  // fix_mul #(IN_BITS, OUT_BITS-1) mult_ad(a, d, ad_w);

  fix_mul #(IN_BITS, OUT_BITS-1) mult_a(switch ? b : a,
                                        switch ? d : c, aw);
  fix_mul #(IN_BITS, OUT_BITS-1) mult_b(switch ? a : b,
                                        switch ? d : c, bw);

  // TODO: try to get better precision via rounding.
  // TODO: watch out for ones!
  assign out[REAL] = {ac[OUT_BITS-2], ac} - {bd[OUT_BITS-2], bd};
  assign out[IMAG] = {bc[OUT_BITS-2], bc} + {ad[OUT_BITS-2], ad};

  always @(posedge clk) begin
    if (reset) begin
      available <= 1;
    end else begin
      if (available) begin
        if (ready) begin
          available <= 0;
          switch <= 0;
        end
      end else begin
        switch <= !switch;
        if (switch) begin
          available <= 1;
        end
      end
    end
    if (!switch) begin
      ac <= aw;
      bc <= bw;
    end else begin
      bd <= aw;
      ad <= bw;
    end
  end

endmodule
