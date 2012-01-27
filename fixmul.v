// Module for doing a fixed-point multiply of two numbers.

module fixmul (
  input  [18:0] a,
  input  [18:0] b,
  output [18:0] result
);

// TODO: Signed numbers have asymmetric ranges.  Thus, if you take the
// absolute value of the most negative number (all zeroes except for the
// sign bit), it cannot be represented as a positive number.
// This multiplication method does not handle the most negative number.

// Calculate absolute values so we can do unsigned calculations.
// This gets us an extra bit of precision without much extra effort.
wire [17:0] abs_a = a[18] ? -(a[17:0]) : a[17:0];
wire [17:0] abs_b = b[18] ? -(b[17:0]) : b[17:0];

// Calculate the sign
wire sign = (a[18] ^ b[18]);

// Calculate the full result
wire [35:0] full_result = abs_a * abs_b;

// Take the high-order bits
wire [18:0] unrounded_result;
assign unrounded_result[17:0] = sign ? -(full_result[35:18]) : full_result[35:18];
assign unrounded_result[18]   = sign;

// Perform rounding
// TODO: prevent this from overflowing!
assign result = full_result[17] ? unrounded_result + 18'd1 : unrounded_result;

endmodule // fixmul
