// Decodes a matrix from a serial matrix transmission.

module mtx_decoder (
  input reset,
  input clk,

  input signed [18:0] matrix_cell,
  input imag,    // high if imaginary, low if real
  input row,     // high for row 1,    low for row 0
  input col,     // high for column 1, low for column 0
  input ready,

  output reg signed [18:0] matrix[0:1][0:1][0:1]
);

  parameter SIMULATE=0;
  localparam REAL=0, IMAG=1;

  genvar i, r, c;
  generate
    for (i = 0; i < 2; i = i + 1) begin : I
      for (r = 0; r < 2; r = r + 1) begin : R
        for (c = 0; c < 2; c = c + 1) begin : C
          always @(posedge clk) begin
            if (imag == i && row == r && col == c && ready) begin
              matrix[r][c][i] <= matrix_cell;
            end
          end
        end
      end
    end
  endgenerate
endmodule
