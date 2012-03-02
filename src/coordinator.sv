/**
 * Decodes command data and coordinates calculations.
 * Each command is preceded by a command byte indicating the data that will
 * follow.
 *
 * M - 2x2 marix, sent as 8 complex numbers in row-major order, with the
 *     real part sent first for each number.
 * D - Distance threshold.
 * G - Gate length.
 * C - Begin calculation.
 * B - Matrix benchmark.
 * L - show next byte on LEDs (for testing)
 *
 * Future:
 *
 * N - number of unique products to find
 * W - max length of a sequence to put into product check tree?
 */
`timescale 1ns / 1ns
//`define MATRIX_BENCHMARK
module coordinator(
  clk,
  reset,

  // From the UART receiver
  received_byte,
  received_ready,

  // To the UART transmitter
  transmit_byte,
  transmit_available,
  transmit_ready,

  // To the LEDs
  green_leds
);
`include "types.svi"

  input clk, reset;

  input [7:0] received_byte;
  input received_ready;

`ifdef MATRIX_BENCHMARK
  output [7:0] transmit_byte;
  output transmit_ready;
`else
  output reg [7:0] transmit_byte;
  output reg transmit_ready;
`endif
  input  transmit_available;

  output reg [7:0] green_leds;

  typedef enum reg [3:0] {
    WAITING,
    READING_MATRIX,
    READING_DISTANCE,
    READING_GATE_LENGTH,
    LEDS,
`ifdef MATRIX_BENCHMARK
    // Matrix multiplication test
    MT_READING_A,
    MT_READING_B,
    MT_CALC,
    MT_SENDING_RESULT
`else
    // Calculation!
    CALCULATING,
    SENDING_RESULT,
    SENDING_FAILURE
`endif
  } state_t;

  state_t state, last_state;

`ifdef MATRIX_BENCHMARK
  // Matrices for the matrix benchmark
  reg signed [NUMBER_BITS-1:0] mtx_a[0:1][0:1][0:1];
  reg signed [NUMBER_BITS-1:0] mtx_b[0:1][0:1][0:1];
  reg signed [NUMBER_BITS-1:0] mtx_r[0:1][0:1][0:1];
`else
  wire signed [NUMBER_BITS-1:0] mtx_a[0:1][0:1][0:1];
  wire signed [NUMBER_BITS-1:0] mtx_b[0:1][0:1][0:1];
`endif

  // Serial number decoder
  wire [NUMBER_BITS-1:0] snd_num;
  wire snd_done;
  wire smd_needs_number;
  wire snd_reset = reset || smd_needs_number ||
    (last_state == WAITING && (state == READING_DISTANCE ||
       state == READING_GATE_LENGTH));
  serial_number_decoder snd(
    .clk(clk),
    .reset(snd_reset),

    .received_byte(received_byte),
    .received_ready(received_ready),

    .num(snd_num),
    .done(snd_done)
  );

  // Serial matrix decoder
  wire signed [NUMBER_BITS-1:0] smd_mtx[0:1][0:1][0:1];
  wire smd_done;
  wire smd_reset = reset ||
    (last_state == WAITING && (
`ifdef MATRIX_BENCHMARK
      state == MT_READING_A ||
`endif
      state == READING_MATRIX))
`ifdef MATRIX_BENCHMARK
    || (last_state == MT_READING_A && state == MT_READING_B)
`endif
    ;
  serial_matrix_decoder smd(
    .clk(clk),
    .reset(smd_reset),

    .matrix_cell(snd_num),
    .ready(snd_done),
    .needs_number(smd_needs_number),

    .matrix(smd_mtx),
    .done(smd_done)
  );

`ifdef MATRIX_BENCHMARK
  // Serial number encoder
  wire [NUMBER_BITS-1:0] sne_num;
  wire sne_ready;
  wire sne_done;
  wire sne_available;
  serial_number_encoder sne(
    .clk(clk),
    .reset(reset),

    // To the serial matrix encoder
    .num(sne_num),
    .ready(sne_ready),
    .available(sne_available),

    // To the serial transmitter
    .transmit_byte(transmit_byte),
    .transmit_ready(transmit_ready),
    .transmit_available(transmit_available)
  );

  // Serial matrix encoder
  wire sme_done;
  serial_matrix_encoder sme(
    .clk(clk),
    .reset(reset),

    // From the matrix multiplier
    .matrix(mtx_r),

    // From the state machine
    .ready(last_state == MT_CALC && state == MT_SENDING_RESULT),

    // To the state machine
    .available(sme_done),

    // To the serial number encoder
    .matrix_cell(sne_num),
    .cell_ready(sne_ready),
    .number_encoder_available(sne_available)
  );
`endif

  // Distance
  reg [NUMBER_BITS-1:0] dist_tolerance;

  // Max gate length
  reg [7:0] max_gate_length;

  // Matrix multiplier
`ifdef MATRIX_BENCHMARK
  wire cmm_ready = (last_state == MT_READING_B && state == MT_CALC);
`endif
  wire cmm_done;
  wire signed [NUMBER_BITS-1:0] cmm_result[0:1][0:1][0:1];
  complex_matrix_multiplier cmm(
    .clk(clk),
    .reset(reset),

    .mtx_a(mtx_a),
    .mtx_b(mtx_b),
    .mtx_r(cmm_result),

    .ready(cmm_ready),
    .available(cmm_done)
  );

`ifndef MATRIX_BENCHMARK
  // Sequence generator

  wire seq_gen_start = (last_state == WAITING && state == CALCULATING);
  wire seq_gen_complete;

  wire [SEQ_INDEX_BITS-1:0] seq_gen_seq_index;
  wire [4:0] seq_gen_seq_gate;
  wire seq_gen_ready;
  wire seq_gen_first;
  wire seq_gen_available;

  sequence_generator seq_gen(
    .clk(clk),
    .reset(reset),

    // From the Coordinator
    .max_length(max_gate_length),
    .start(seq_gen_start),
    .complete(seq_gen_complete),

    // To the Sequence Multiplier
    .seq_index(seq_gen_seq_index),
    .seq_gate(seq_gen_seq_gate),
    .ready(seq_gen_ready),
    .first(seq_gen_first),
    .available(seq_gen_available)
  );

  // Sequence multiplier
  wire [NUMBER_BITS-1:0] seq_mult_result[0:1][0:1][0:1];
  wire seq_mult_done;

  sequence_multiplier seq_mult(
    .clk(clk),
    .reset(reset),

    .seq_index(seq_gen_seq_index),
    .seq_gate(seq_gen_seq_gate),
    .ready(seq_gen_ready),
    .first(seq_gen_first),
    .available(seq_gen_available),

    .result_mtx(seq_mult_result),
    .done(seq_mult_done),

    .multiplier_a(mtx_a),
    .multiplier_b(mtx_b),
    .multiplier_ready(cmm_ready),
    .multiplier_done(cmm_done),
    .multiplier_result(cmm_result)
  );

  // Distance checker
  wire [(NUMBER_BITS+3)*2:0] dist2;
  wire dst_finished;
  dist_calc dst(
    .reset(reset),
    .clk(clk),

    .mtx_a(seq_mult_result),
    .mtx_b(smd_mtx),

    .ready(seq_mult_done),
    .dist2(dist2),
    .finished(dst_finished)
  );
  wire seq_found = (dist2[(NUMBER_BITS)*2:NUMBER_BITS+1] > dist_tolerance)
                   && dst_finished;
`endif

  always @(posedge clk) begin
    if (reset) begin
      last_state <= WAITING;
      state      <= WAITING;
    end else begin
      transmit_ready <= 1'b1;
      // Light up LEDs depending on state
      if (last_state != state) begin
        green_leds <= {4'd0, state};
      end
      last_state <= state;
      case (state)
        WAITING:
          if (received_ready) begin
            case (received_byte)
`ifdef MATRIX_BENCHMARK
              "B": begin
                state <= MT_READING_A;
              end
`else
              "C": state <= CALCULATING;
`endif

              "D": begin
                state <= READING_DISTANCE;
              end

              "M": begin
                state <= READING_MATRIX;
              end

              "G": begin
                state <= READING_GATE_LENGTH;
              end

              "L": state <= LEDS;
            endcase
          end

        READING_MATRIX:
          if (smd_done) state <= WAITING;

        READING_DISTANCE:
          if (snd_done) begin
            dist_tolerance <= snd_num;
            state          <= WAITING;
          end

        READING_GATE_LENGTH:
          if (received_ready) begin
            max_gate_length <= received_byte;
            state           <= WAITING;
          end

`ifndef MATRIX_BENCHMARK
        CALCULATING:
          // TODO: implement
          if (seq_found) begin
            state <= SENDING_RESULT;
            transmit_byte <= "R";
            transmit_ready <= 1'b1;
          end else begin
            if (seq_gen_complete) begin
              transmit_byte <= "F";
              transmit_ready <= 1'b1;
              state <= SENDING_FAILURE;
            end
          end

        // Send the list of gates in the result.
        SENDING_RESULT: begin
          // TODO: rethink...
          if (transmit_available) begin
            transmit_ready <= 1'b0;
            // TODO: send sequence
            state <= WAITING;
          end
        end

        // Send a failure message, meaning no gate of length max_length
        // could be found.
        SENDING_FAILURE: begin
          // TODO: rethink...
          if (transmit_available) begin
            transmit_ready <= 1'b0;
            state <= WAITING;
          end
        end

`endif

        LEDS:
          if (received_ready) begin
            green_leds  <= received_byte;
            state       <= WAITING;
          end

`ifdef MATRIX_BENCHMARK
        MT_READING_A:
          if (smd_done && last_state != WAITING) begin
            mtx_a <= smd_mtx;
            state <= MT_READING_B;
          end

        MT_READING_B:
          if (smd_done && last_state != MT_READING_A) begin
            mtx_b <= smd_mtx;
            state <= MT_CALC;
          end

        MT_CALC:
          if (cmm_done && last_state != MT_READING_B) begin
            mtx_r <= cmm_result;
            state <= MT_SENDING_RESULT;
          end

        MT_SENDING_RESULT:
          // Only advance if we're done sending, and we didn't just
          // transition from calculation (sme_done is still high
          // for 1 clock cycle after starting a matrix encoding).
          if (sme_done && last_state != MT_CALC) state <= WAITING;
`endif

        default:
          state <= WAITING;
      endcase
    end
  end
endmodule
