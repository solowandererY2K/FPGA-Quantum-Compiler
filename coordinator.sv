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
  /** Number of bits in our numbers. */
  parameter NUMBER_BITS = 37;

  input clk, reset;

  input [7:0] received_byte;
  input received_ready;

  output [7:0] transmit_byte;
  input  transmit_available;
  output transmit_ready;

  output reg [7:0] green_leds;

  typedef enum reg [2:0] {
    WAITING,
    READING_MATRIX,
    READING_DISTANCE,
    READING_GATE_LENGTH,
    CALCULATING,
    MATRIX_MULT,
    LEDS
  } state_t;

  state_t state, last_state;

  // Serial number decoder
  wire [NUMBER_BITS-1:0] snd_num;
  wire snd_done;
  wire snd_reset = reset ||
    (last_state == WAITING &&
    (state == READING_MATRIX || state == READING_DISTANCE)) ||
    (state == READING_MATRIX && snd_done);
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
    (last_state == WAITING && state == READING_MATRIX);
  serial_matrix_decoder smd(
    .clk(clk),
    .reset(smd_reset),

    .matrix_cell(snd_num),
    .ready(snd_done),

    .matrix(smd_mtx),
    .done(smd_done)
  );

  // Distance
  reg [NUMBER_BITS-1:0] dist_tolerance;

  // Max gate length
  reg [7:0] max_gate_length;

  always @(posedge clk) begin
    if (reset) begin
      last_state <= WAITING;
      state      <= WAITING;
    end else begin
      last_state <= state;
      case (state)
        WAITING:
          if (received_ready) begin
            case (received_byte)
              "B": state <= MATRIX_MULT;
              "C": state <= CALCULATING;
              "D": state <= READING_DISTANCE;
              "M": state <= READING_MATRIX;
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

        CALCULATING:
          // TODO: implement
          state <= WAITING;

        MATRIX_MULT:
          // TODO: implement
          state <= WAITING;

        LEDS:
          if (received_ready) begin
            green_leds  <= received_byte;
            state       <= WAITING;
          end

        default:
          state <= WAITING;
      endcase
    end
  end
endmodule;
