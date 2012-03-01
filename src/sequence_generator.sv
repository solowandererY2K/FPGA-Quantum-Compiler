/* Generates gate sequences to multiply.
 *
 * [ States ]
 * State 0 - waits for the start signal
 * State 1 - transmits the current sequence, highest gate to lowest
 * State 2 - increments the current sequence
 */
`timescale 1ns / 1ns
module sequence_generator(
  clk,
  reset,

  // From the Coordinator
  max_length,
  start,
  complete,

  // To the Sequence Multiplier
  seq_index,
  seq_gate,
  ready,
  first,
  available
);

  ////////////////////////////// PARAMETERS /////////////////////////////////

  // Number of bits in the sequence index.
  // Increase this parameter to support more than 32 items in a sequence.
  parameter SEQ_INDEX_BITS = 5;

  // Number of bits in a number.
  // In the future, it will be changed to 36 for better precision.
  parameter NUMERIC_BITS = 19;

  // Highest possible sequence index.
  parameter HIGHEST_SEQ_INDEX = 4;

  // Highest gate number
  parameter HIGHEST_GATE = 24;

  ///////////////////////////// LOCALPARAMS /////////////////////////////////

  typedef enum reg [1:0] {
       WAITING,
       SENDING,
       ADVANCING
  } state_t;

  //////////////////////////////// PORTS ////////////////////////////////////

  input clk, reset;

  // From the Coordinator
  input [SEQ_INDEX_BITS-1:0] max_length; // max length of a sequence.
  input start;     // when a pulse arrives, the sequence generator starts.
  output reg complete; // goes high once the generator is done.

  // To the Sequence Multiplier
  // Sequence must be iterated over from most significant to lowest index.
  output reg [SEQ_INDEX_BITS-1:0] seq_index;
  output [4:0] seq_gate;
  output ready; // high when Sequence Generator is ready.
  output first; // high when this gate is the first in the sequence.
                // The gate will be loaded directly into the matrix cache,
                // instead of multiplying it with a prior gate.
  input available; // high when Sequence Multiplier is ready for the next
                   // gate.

  ///////////////////////////////// CODE ////////////////////////////////////

  state_t state;
  reg [4:0] gates [0:HIGHEST_SEQ_INDEX];

  assign ready = state == SENDING;
  assign first = seq_gate == max_length - 1;
  assign seq_gate = gates[seq_index];

  integer i;
  always @(posedge clk) begin
    if (reset) begin
      state <= WAITING;
      complete <= 0;
    end else begin
      case (state)
        WAITING:
          if (start) begin
            state <= SENDING;
            seq_index <= max_length - 1;
            complete <= 0;
            for (i = 0; i <= HIGHEST_SEQ_INDEX; i++) begin
              gates[i] <= 0;
            end
          end

        SENDING:
          if (seq_index == 0) begin
            state <= ADVANCING;
          end else begin
            if (available) begin
              seq_index <= seq_index - 1;
            end
          end

        ADVANCING:
          if (seq_gate == HIGHEST_GATE) begin
            if (seq_index == max_length) begin
              complete <= 1'b1;
              state <= WAITING;
            end else begin
              seq_index <= seq_index + 1;
              gates[seq_index] <= 0;
            end
          end else begin
            gates[seq_index] <= seq_gate + 1;

            state <= SENDING;
            // TODO: optimize by removing the following statement, so that
            // the Sequence Multiplier won't have to remultiply everything.
            seq_index <= max_length - 1;
          end

        default: // should never be here
          state <= WAITING;
      endcase
    end
  end
endmodule
