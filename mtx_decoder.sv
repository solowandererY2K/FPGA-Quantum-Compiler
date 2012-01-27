// Decodes a matrix from a serial matrix transmission.

module mtx_decoder (
  input reset,
  input clk,

  input [18:0] matrix_cell,
  input imag,    // high if imaginary, low if real
  input row,     // high for row 1,    low for row 0
  input col,     // high for column 1, low for column 0
  input ready,
  input new_mtx,  // high if a new matrix is being loaded.

  output reg [18:0] matrix[1:0][1:0][1:0],
  output done // goes high once the new matrix is filled.
);

  parameter SIMULATE=0;
  localparam REAL=0, IMAG=1;

  reg [7:0] completed_cells;

  assign done = (completed_cells == 8'b11111111);

  genvar i, r, c;
  generate
    for (i = 0; i < 2; i = i + 1) begin : I
      for (r = 0; r < 2; r = r + 1) begin : R
        for (c = 0; c < 2; c = c + 1) begin : C
          always @(posedge clk) begin
            if (imag == i && row == r && col == c && ready) begin
              matrix[i][r][c] <= matrix_cell;
              completed_cells[4*i + 2*r + c] <= 1;
            end else begin
              if (reset || new_mtx) begin
                completed_cells[4*i + 2*r + c] <= 0;
              end
            end
          end
        end
      end
    end
  endgenerate
endmodule
