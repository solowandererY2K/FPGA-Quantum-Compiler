// Module for doing a fixed-point multiply of two numbers.

module fixmul (a, b, result);
  parameter IN_BITS = 19, OUT_BITS = 19;
  input  signed [ IN_BITS-1:0] a;
  input  signed [ IN_BITS-1:0] b;
  output signed [OUT_BITS-1:0] result;

// TODO: Signed numbers have asymmetric ranges.  Thus, if you take the
// absolute value of the most negative number (all zeroes except for the
// sign bit), it cannot be represented as a positive number.
// This multiplication method does not handle the most negative number.

// Calculate absolute values so we can do unsigned calculations.
// This gets us an extra bit of precision without much extra effort.
wire [IN_BITS-2:0] abs_a = a[IN_BITS-1] ? -(a[IN_BITS-2:0]) : a[IN_BITS-2:0];
wire [IN_BITS-2:0] abs_b = b[IN_BITS-1] ? -(b[IN_BITS-2:0]) : b[IN_BITS-2:0];

// Calculate the sign
wire sign = (a[IN_BITS-1] ^ b[IN_BITS-1]);

// Calculate the full result
wire [35:0] full_result = abs_a * abs_b;

// Take the high-order bits
wire [OUT_BITS-1:0] unrounded_result;
assign unrounded_result[OUT_BITS-2:0] = sign ?
                                        -(full_result[35:37-OUT_BITS]) :
                                        full_result[35:37-OUT_BITS];
assign unrounded_result[OUT_BITS-1]   = sign;

// Perform rounding
// TODO: prevent this from overflowing!
assign result = full_result[35] ? unrounded_result + 1 : unrounded_result;

endmodule // fixmul
