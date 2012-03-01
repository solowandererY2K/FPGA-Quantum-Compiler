/**
 * Decodes a matrix from a serial list of numbers.
 */
`timescale 1ns / 1ns
module serial_matrix_decoder (
  reset,
  clk,

  matrix_cell,
  ready,
  needs_number,

  matrix,
  done
);

  localparam REAL=0, IMAG=1;

  /** Number of bits in our numbers. */
  parameter NUMBER_BITS = 37;

  input reset, clk;

  input signed [NUMBER_BITS-1:0] matrix_cell;
  input ready;

  output reg signed [NUMBER_BITS-1:0] matrix[0:1][0:1][0:1];
  output done;

  output reg needs_number;

  reg [3:0] index;
  assign done = index[3];
  wire r = index[2];
  wire c = index[1];
  wire i = index[0];

  always @(posedge clk) begin
    needs_number <= 0;
    if (reset) begin
      index <= 0;
      needs_number <= 1;
    end else begin
      if (ready) begin
        matrix[r][c][i] <= matrix_cell;
        index <= index + 1;
        if (index != 4'b0111) begin
          needs_number <= 1;
        end
      end
    end
  end
endmodule
