/* Multiplies a sequence of matrices to obtain a matrix product.
 *
 */
`timescale 1ns / 1ns
module sequence_multiplier_tb();
  // Clock and reset signal
  wire clk, reset;
  clockGen clock(clk, reset);

  // Input from the sequence generator
  reg  [4:0] seq_index;
  reg  [4:0] seq_gate;
  reg  ready;
  reg  first;
  wire available;

  // Output to later stages
  wire signed [18:0] result_mtx[0:1][0:1][0:1];
  wire done;

  // Matrix multiplier
  wire signed [18:0] mtx_a[0:1][0:1][0:1];
  wire signed [18:0] mtx_b[0:1][0:1][0:1];
  wire signed [18:0] multiplier_result[0:1][0:1][0:1];

  wire multiplier_ready;
  reg  multiplier_done;

  complex_matrix_multiplier cmm(
    .clk(clk),
    .reset(reset),

    .mtx_a(mtx_a),
    .mtx_b(mtx_b),
    .mtx_r(multiplier_result),

    .ready(multiplier_ready),
    .completed(multiplier_done)
  );

  // Sequence multiplier
  sequence_multiplier sm(
    .clk(clk),
    .reset(reset),

    .seq_index(seq_index),
    .seq_gate(seq_gate),
    .ready(ready),
    .first(first),
    .available(available),

    .result_mtx(result_mtx),
    .done(done),

    .multiplier_a(mtx_a),
    .multiplier_b(mtx_b),
    .multiplier_result(multiplier_result),
    .multiplier_ready(multiplier_ready),
    .multiplier_done(multiplier_done)
  );

  // Test the multiplier by iterating over a sample sequence.
  // TODO: test two or three sequences to verify cache behavior.

  initial begin
    #40
    seq_index = 2;
    seq_gate = 2;
    ready = 1'b1;
    first = 1'b1;
    #20
    ready = 1'b0;
    #1000
    seq_index = 1;
    seq_gate = 1;
    ready = 1'b1;
    first = 1'b0;
    #20
    ready = 1'b0;
    #1000
    seq_index = 0;
    seq_gate = 0;
    ready = 1'b1;
    #20
    ready = 1'b0;
  end
endmodule
