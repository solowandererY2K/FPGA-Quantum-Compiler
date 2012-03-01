/**
 * Encodes a fixed-point number to a serial port byte pattern.
 *
 * The number must be sent over the serial port with the least-significant
 * bit first, meaning that the number must be little-endian (the least
 * significant BYTE is sent first too).
 */
`timescale 1ns / 1ns
module serial_number_encoder (
  clk,
  reset,

  num,
  ready,
  available,

  transmit_byte,
  transmit_ready,
  transmit_available
);

  /** Number of bits in the number. */
  parameter NUMBER_BITS = 37;

  /** Number of bytes in the number. */
  parameter NUMBER_BYTES = 5;

  /** Number of bits used to count the current byte number. */
  parameter BYTE_INDEX_BITS = 3;

  input clk, reset;

  input signed [NUMBER_BITS-1:0] num; // Current number.
                                      // Must hold value between
                                      // available's peaks.
  input ready;
  output reg available; // High if the unit is available

  output [7:0] transmit_byte; // Byte to send.
  output reg transmit_ready;      // High if byte is valid.
  input transmit_available;   // High if transmitter isn't busy.

  reg [BYTE_INDEX_BITS-1:0] byte_index; // Current byte to send
  wire [7:0] bytes[0:NUMBER_BYTES-1];   // Bytes to send

  assign transmit_byte = bytes[byte_index];

  // Wire the output bytes to the number
  genvar i, j;
  generate
    for (i = 0; i < NUMBER_BYTES; i++) begin:I
      for (j = 0; j < 8; j++) begin:J
        assign bytes[i][j] = (i*8+j>=NUMBER_BITS) ? 1'b0 : num[i*8+j];
      end
    end
  endgenerate

  reg transmit_available_last;
  wire transmit_available_rising_edge =
    !transmit_available_last && transmit_available;
  wire transmit_available_falling_edge =
    transmit_available_last && !transmit_available;

  always @(posedge clk) begin
    if (reset) begin
      byte_index <= 0;
      available <= 1;
      transmit_available_last <= 0;
      transmit_ready <= 0;
    end else begin
      transmit_available_last <= transmit_available;
      if (available) begin
        // If we're ready to send the first byte, send it.
        if (ready && transmit_available) begin
          byte_index     <= 0;
          available      <= 0;
          transmit_ready <= 1;
        end
      end else begin
        // Transmit the next byte, or just stop transmitting.
        if (transmit_available_rising_edge) begin
          if (byte_index == NUMBER_BYTES - 1) begin
            available <= 1;
            transmit_ready <= 0;
          end else begin
            byte_index     <= byte_index + 1;
            transmit_ready <= 1;
          end
        end else begin
          // TODO: do we need this?
          if (transmit_available_falling_edge) transmit_ready <= 0;
        end
      end
    end
  end
endmodule
