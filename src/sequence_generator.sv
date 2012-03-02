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
`include "types.svi"
  ///////////////////////////// LOCALPARAMS /////////////////////////////////

  typedef enum reg [1:0] {
       WAITING,
       WAITING_FOR_SEQ_MULT,
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
  output reg ready; // high when Sequence Generator is ready.
  output first; // high when this gate is the first in the sequence.
                // The gate will be loaded directly into the matrix cache,
                // instead of multiplying it with a prior gate.
  input available; // high when Sequence Multiplier is ready for the next
                   // gate.

  ///////////////////////////////// CODE ////////////////////////////////////

  state_t state;
  reg [4:0] gates [0:HIGHEST_SEQ_INDEX];

  assign first = seq_index == max_length - 1;
  assign seq_gate = gates[seq_index];

  reg available_last;
  wire available_rising_edge = !available_last && available;
  wire available_falling_edge = available_last && !available;

  // TODO: remove this reg...
  reg [1:0] available_timer;

  integer i;
  always @(posedge clk) begin
    available_last <= available;
    if (reset) begin
      state <= WAITING;
      complete <= 0;
      ready <= 0;
    end else begin
      case (state)
        WAITING:
          if (start) begin
            state <= available ? SENDING : WAITING_FOR_SEQ_MULT;
            available_timer <= 2'd3;
            ready <= 1'b1;
            seq_index <= max_length - 1;
            complete <= 0;
            for (i = 0; i <= HIGHEST_SEQ_INDEX; i++) begin
              gates[i] <= 0;
            end
          end

        WAITING_FOR_SEQ_MULT: begin
          if (available) state <= SENDING;
          available_timer <= 2'd3;
        end

        SENDING: begin
          // When the Sequence Multiplier becomes available,
          // change the sequence index.
          if (available_timer != 0) begin
            available_timer <= available_timer - 1;
          end
          if (available_rising_edge ||
              (available_timer == 0 && available)) begin
            if (seq_index == 0) begin
              state <= ADVANCING;
            end else begin
              seq_index <= seq_index - 1;
              ready     <= 1'b1;
              available_timer <= 2'd3;
            end
          end else begin
            // Once the Sequence Multiplier is busy, turn off the
            // ready signal.  This prevents the Sequence Multiplier
            // from continuing automatically when it finishes.
            // TODO: this problem could be fixed if the Sequence
            // Multiplier's available signal went HIGH a clock cycle
            // before it was actually available.
            if (available_falling_edge) begin
              ready <= 1'b0;
            end
          end
        end

        ADVANCING:
          if (seq_gate == HIGHEST_GATE) begin
            if (seq_index == max_length - 1) begin
              complete <= 1'b1;
              state    <= WAITING;
            end else begin
              seq_index        <= seq_index + 1;
              gates[seq_index] <= 0;
            end
          end else begin
            gates[seq_index] <= seq_gate + 1;

            state <= SENDING;
            available_timer <= 2'd3;

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
