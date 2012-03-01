/* Multiplies a sequence of matrices to obtain a matrix product.
 *
 */
`timescale 1ns / 1ns
module sequence_multiplier(
  clk,
  reset,

  seq_index,
  seq_gate,
  ready,
  first,
  available,

  result_mtx,
  done,

  multiplier_a,
  multiplier_b,
  multiplier_ready,
  multiplier_done,
  multiplier_result
);
  ////////////////////////////// PARAMETERS /////////////////////////////////

  // Number of bits in the sequence index.
  // Increase this parameter to support more than 32 items in a sequence.
  parameter SEQ_INDEX_BITS = 5;

  // Number of bits in a number.
  parameter NUMERIC_BITS = 37;

  // Highest sequence index to be cached in the matrix result cache.
  parameter HIGHEST_SEQ_INDEX = 4;

  //////////////////////////////// PORTS ////////////////////////////////////

  input clk, reset;

  // From the Sequence Generator
  // Sequence must be iterated over from most significant to lowest index.
  input [SEQ_INDEX_BITS-1:0] seq_index;
  input [4:0] seq_gate;
  input ready; // high when Sequence Generator is ready.
  input first; // high when this gate is the first in the sequence.
               // The gate will be loaded directly into the matrix cache,
               // instead of multiplying it with a prior gate.
  output reg available; // high when Sequence Multiplier is ready for the next
                    // gate.

  // To the Solution Checker and the Duplicate Checker
  output signed [NUMERIC_BITS-1:0] result_mtx [0:1][0:1][0:1];
  output reg done; // high when a result has been calculated for sequence
                   // item 0.

  // To Multiplier
  output signed [NUMERIC_BITS-1:0] multiplier_a [0:1][0:1][0:1];
  output signed [NUMERIC_BITS-1:0] multiplier_b [0:1][0:1][0:1];
  output reg multiplier_ready;
  input multiplier_done;
  input signed [NUMERIC_BITS-1:0] multiplier_result [0:1][0:1][0:1];

  ///////////////////////////////// CODE ////////////////////////////////////

  assign done = (available && seq_index == 0);

  // TODO: parameterize this module by number of bits in our fixed point
  // representation.
  wire signed [NUMERIC_BITS-1:0] gate_mtx[0:1][0:1][0:1];
  reg  gate_ready;
  wire gate_done;
  reg [SEQ_INDEX_BITS-1:0] gate_to_read;
  gate_matrix_table gmt (
    .clk(clk),
    .reset(reset),
    .gate(gate_to_read),
    .result(gate_mtx),
    .ready(gate_ready),
    .done_pulse(gate_done)
  );

  // Cached Results
  // The first index corresponds to the sequence index we multiplied a
  // previous matrix by to obtain the result stored in that location.
  // For example, cache_mtx[0] = cache_mtx[1] * gate_sequence[0]
  // TODO: use a memory block to store this huge cache.
  reg signed [NUMERIC_BITS-1:0] cache_mtx [HIGHEST_SEQ_INDEX:0][0:1][0:1][0:1];
  reg [SEQ_INDEX_BITS-1:0] cache_gates [HIGHEST_SEQ_INDEX:0];

  // Stores the index of the highest sequence index to have a result stored
  // in the cache.
  // This prevents the system from reloading a cached gate when it doesn't
  // have to.
  reg [SEQ_INDEX_BITS-1:0] cache_first;

  assign result_mtx = cache_mtx[0];

  // TODO: check for index out of bounds
  assign multiplier_a = cache_mtx[seq_index + 1];
  assign multiplier_b = gate_mtx;

  // Multiplier state
  reg [1:0] state;
  localparam WAITING = 2'd0,
             READING_GATE = 2'd1,
             MULTIPLYING = 2'd2;


  // On reset, indicate that all cache contents are invalid.
  genvar i;
  generate
    for (i = 0; i < HIGHEST_SEQ_INDEX; i = i + 1) begin:I
      always @(posedge clk) begin
        if (reset) cache_gates[i] <= HIGHEST_SEQ_INDEX + 1;
      end
    end
  endgenerate

  always @(posedge clk) begin
    if (reset) begin
      cache_first      <= HIGHEST_SEQ_INDEX + 1;
      gate_to_read     <= HIGHEST_SEQ_INDEX + 1;
      multiplier_ready <= 1'b0;
      gate_ready       <= 1'b0;
      state            <= WAITING;
      available        <= 1'b1;
    end else begin
      case (state)
        WAITING: begin
          if (ready) begin
            // Check for a cached value
            if (cache_gates[seq_index] == seq_gate &&
              (!first || first && cache_first == seq_index)) begin

              // Skip because we have this result already.
              available <= 1'b1;
            end else begin
              // Update the cache gate
              cache_gates[seq_index] <= seq_gate;

              // Increase cache_first if possible.
              // TODO: think about the implications of a non-decreasing
              // cache_first.
              if (first && cache_first < seq_index) begin
                cache_first <= seq_index;
              end

              // See if we need to load a gate.
              if (gate_to_read != seq_gate) begin
                state        <= READING_GATE;
                gate_ready   <= 1'b1;
                gate_to_read <= seq_index;
              end else begin
                // Skip multiplying if this matrix is the first.
                if (first) begin
                  state                <= WAITING;
                  available            <= 1'b1;
                  cache_mtx[seq_index] <= gate_mtx;
                end else begin
                  // We've already loaded the gate, so start multiplying.
                  state            <= MULTIPLYING;
                  multiplier_ready <= 1'b1;
                end
              end
            end
          end
        end

        READING_GATE: begin
          gate_ready <= 1'b0;
          if (gate_done) begin
            // Skip multiplying if this matrix is the first.
            if (first) begin
              state                <= WAITING;
              available            <= 1'b1;
              cache_mtx[seq_index] <= gate_mtx;
            end else begin
              state            <= MULTIPLYING;
              multiplier_ready <= 1'b1;
            end
          end
        end

        MULTIPLYING: begin
          multiplier_ready <= 1'b0;
          if (multiplier_done) begin
            // Store the multiplier result in the sequence cache.
            state                <= WAITING;
            available            <= 1'b1;
            cache_mtx[seq_index] <= multiplier_result;
          end
        end
      endcase
    end
  end
endmodule
