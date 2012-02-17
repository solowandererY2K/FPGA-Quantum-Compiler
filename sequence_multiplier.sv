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
  output [NUMERIC_BITS-1:0] multiplier_a [1:0][1:0][1:0];
  output [NUMERIC_BITS-1:0] multiplier_b [1:0][1:0][1:0];
  output reg ready;
  input multiplier_done;
  input [NUMERIC_BITS-1:0] multiplier_result [1:0][1:0][1:0];

  ///////////////////////////////// CODE ////////////////////////////////////

  wire [18:0] dataout;

  gate_table (
    .clock(clk),
    .init(reset),
    .dataout,
    .init_busy,
    .ram_address,
    .ram_wren);

  // Cached Results
  // The first index corresponds to the sequence index we multiplied a
  // previous matrix by to obtain the result stored in that location.
  // TODO: use a memory block to store this huge cache
  reg [NUMERIC_BITS-1:0] cache_mtx [HIGHEST_SEQ_INDEX:0][1:0][1:0][1:0];
  reg [SEQ_INDEX_BITS-1:0] cache_gates [HIGHEST_SEQ_INDEX:0];

  assign result_mtx = cache_mtx[0];
  assign available = multiplier_done;

  genvar i;
  generate
    always @(posedge clk) begin
      if (reset) begin
        for (i = 0; i < HIGHEST_SEQ_INDEX; i = i + 1) begin:I
          cache_gates[i] <= HIGHEST_SEQ_INDEX + 1;
        end
      end else begin
        if (cache_gates[seq_index] == seq_gate):
          // Skip because we have this already.
          done <= 1;
        end else begin
          // Begin reading matrix from memory.
          // We'll also send data to the Multiplier.
        end

        if (multiplier_done) begin
          // Store the multiplier result in the sequence cache.
          cache_mtx[seq_index] <= multiplier_result;
          done <= 1;
        end
      end

      // Default assignment for done.
      done <= 0;
    end
  endgenerate
endmodule
