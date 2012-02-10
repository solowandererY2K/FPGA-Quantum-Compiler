/* Multiplies a sequence of matrices to obtain a matrix product.
 */
module sequence_multiplier(
  clk,
  reset,

  seq_index,
  seq_gate,
  ready,
  most_significant,

  result_mtx,
  done,

  mtx_a,
  mtx_b,
  ready,
  multiplier_done,
  result
);
  ////////////////////////////// PARAMETERS /////////////////////////////////

  // Number of bits in the sequence index.
  // Increase this parameter to support more than 32 items in a sequence.
  parameter SEQ_INDEX_BITS = 5;

  // Number of bits in a number.
  // In the future, it will be changed to 36 for better precision.
  parameter NUMERIC_BITS = 18;

  // Highest sequence index to be cached in the matrix result cache.
  parameter HIGHEST_SEQ_INDEX = 4;

  //////////////////////////////// PORTS ////////////////////////////////////

  input clk, reset;

  // From the Sequence Generator
  // Sequence must be iterated over from most significant to lowest index.
  input [SEQ_INDEX_BITS-1:0] seq_index;
  input [4:0] seq_gate;
  input ready; // high when Sequence Generator is ready.
  output available; // high when Sequence Multiplier is done multiplying.

  // To the Solution Checker and the Duplicate Checker
  output [NUMERIC_BITS-1:0] result_mtx [1:0][1:0][1:0];
  output reg done;

  // To Multiplier
  output [NUMERIC_BITS-1:0] mtx_a [1:0][1:0][1:0];
  output [NUMERIC_BITS-1:0] mtx_b [1:0][1:0][1:0];
  output ready;
  input multiplier_done;
  input [NUMERIC_BITS-1:0] result [1:0][1:0][1:0];
endmodule
