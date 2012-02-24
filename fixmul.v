// Module for doing a fixed-point multiply of two numbers.
`timescale 1ns / 1ns
module fixmul (a, b, result);
  parameter IN_BITS = 37, OUT_BITS = 37, RESULT_BITS = 72;
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
  wire [RESULT_BITS-1:0] full_result;
  // TODO: consider "restricting the output width" in the megafunction
  // TODO: consider adding additional output latency in the megafunction to
  // enable pipelining, improving performance.
  mult_unit mult(abs_a, abs_b, full_result);

  // Take the high-order bits
  // NOTE: We throw out the highest bit from the multiplication because the
  // number should never be >= 2 or <= -2.
  // TODO: get rid of some of this complex logic...
  wire [OUT_BITS-1:0] unrounded_result;
  assign unrounded_result[OUT_BITS-2:0] =
    (sign && full_result[RESULT_BITS-2:RESULT_BITS-OUT_BITS] != 0) ?
    -(full_result[RESULT_BITS-2:RESULT_BITS-OUT_BITS]) :
    full_result[RESULT_BITS-2:RESULT_BITS-OUT_BITS];
  // Don't assign a sign bit to a zero result.
  assign unrounded_result[OUT_BITS-1] = sign &&
    full_result[RESULT_BITS-2:RESULT_BITS-OUT_BITS] != 0;

  // TODO: Perform rounding
  assign result = unrounded_result;

endmodule // fixmul
