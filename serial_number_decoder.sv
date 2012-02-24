/**
 * Decodes a fixed-point number from a serial port byte pattern.
 *
 * The number must be sent over the serial port with the least-significant
 * bit first, meaning that the number must be little-endian (the least
 * significant BYTE is sent first too).
 */
`timescale 1ns / 1ns
module serial_number_decoder (
  clk,
  reset,

  received_byte,
  received_ready,

  num,
  done
);

  /** Number of bits in the number. */
  parameter NUMBER_BITS = 37;

  /** Number of bytes in the number. */
  parameter NUMBER_BYTES = 5;

  /** Number of bits used to count the current byte number. */
  parameter BYTE_INDEX_BITS = 3;

  input clk, reset;
  input [7:0] received_byte; // High if bit is valid
  input received_ready; // High if bit is valid
  output signed [NUMBER_BITS-1:0] num; // Current number
  output done; // High if number is ready

  reg [BYTE_INDEX_BITS-1:0] byte_index;
  reg [7:0] bytes[0:NUMBER_BYTES-1];

  assign done = byte_index == NUMBER_BYTES;

  genvar i;
  generate
    for (i = 0; i < NUMBER_BITS; i++) begin:I
      assign num[i] = bytes[i>>3][i[2:0]];
    end
  endgenerate

  always @(posedge clk) begin
    if (reset) begin
      byte_index <= 0;
    end else begin
      if (received_ready && !done) begin
        bytes[byte_index] <= received_byte;
        byte_index <= byte_index + 1;
      end else begin
        if (done) byte_index <= 0;
      end
    end
  end
endmodule
