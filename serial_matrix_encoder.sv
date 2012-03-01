/**
 * Encodes a matrix into a serial list of numbers.
 *
 * TODO: provide a pulse right before we're finished to improve
 * pipelining performance.
 */
`timescale 1ns / 1ns
module serial_matrix_encoder (
  reset,
  clk,

  matrix,
  ready,
  available,

  matrix_cell,
  cell_ready,
  number_encoder_available
);

  /** Number of bits in our numbers. */
  parameter NUMBER_BITS = 37;

  input reset, clk;

  input signed [NUMBER_BITS-1:0] matrix[0:1][0:1][0:1];
  input ready;
  output reg available;

  output reg signed [NUMBER_BITS-1:0] matrix_cell;
  output reg cell_ready;
  input number_encoder_available;

  reg [2:0] index;
  wire r = index[2];
  wire c = index[1];
  wire i = index[0];

  reg number_encoder_available_last;
  wire number_encoder_available_pulse =
    !number_encoder_available_last && number_encoder_available;

  always @(posedge clk) begin
    number_encoder_available_last <= number_encoder_available;
    cell_ready <= 0;
    if (reset) begin
      index <= 0;
      available <= 1;
    end else begin
      if (ready && number_encoder_available) begin
        available <= 0;
        matrix_cell <= matrix[0][0][0];
        index <= 1;
        cell_ready <= 1;
      end else begin
        // If we're busy sending a number, and the sender just
        // became available, transmit a new number to it.
        if (!available && number_encoder_available_pulse) begin
          // If we're out of numbers, indicate we're done.
          if (index == 3'd0) begin
            available <= 1;
          end else begin
            matrix_cell <= matrix[r][c][i];
            index <= index + 1;
            cell_ready <= 1;
          end
        end
      end
    end
  end
endmodule
