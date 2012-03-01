/* Top-level module for testing the complex matrix multiplier.
 */
module complex_matrix_multiplier_top(
  input reset,
  input clk,

  input signed [18:0] matrix_in,

  input imag,    // high if imaginary, low if real
  input row,     // high for row 1,    low for row 0
  input col,     // high for column 1, low for column 0
  input operand, // 0 for left operand, 1 for right one.
  input in_ready,
  input in_finished,

  // TODO: create a matrix "decoder"
  //output [18:0] matrix_out,
  //output imag,    // high if imaginary, low if real
  //output row,     // high for row 1,    low for row 0
  //output col,     // high for column 1, low for column 0
  //output ready_out,

  output done // goes high once the transmit is done
);

  wire done_a, done_b;
  wire proceed = done_a && done_b;

  wire signed [18:0] operand_a [0:1][0:1][0:1];
  wire signed [18:0] operand_b [0:1][0:1][0:1];
  reg  signed [18:0] result    [0:1][0:1][0:1];

  mtx_decoder decoder_a (
    reset,
    clk,

    matrix_in,
    imag,    // high if imaginary, low if real
    row,     // high for row 1,    low for row 0
    col,     // high for column 1, low for column 0
    in_ready && !operand,

    operand_a
  );

  mtx_decoder decoder_b (
    reset,
    clk,

    matrix_in,
    imag,    // high if imaginary, low if real
    row,     // high for row 1,    low for row 0
    col,     // high for column 1, low for column 0
    in_ready && operand,

    operand_b
  );

  complex_matrix_multiplier cmm(
    reset,
    clk,
    operand_a,
    operand_b,
    proceed,
    result,
    done
  );
endmodule
