/* Multiplies 2x2 matrices containing complex numbers.
 *
 * The matrix entries are indexed like this:
 *
 *   matrix[row][column][complex_component]
 *
 * - row               = 0 or 1
 * - column            = 0 or 1
 * - complex_component = 1 for the imaginary component, or
 *                       0 for the real component of the complex number at the
 *                       desired matrix cell.
 */
`timescale 1ns / 1ns
// TODO: parameterize by number size
module complex_matrix_multiplier (
  input reset,
  input clk,

  // Matrices
  input signed [36:0] mtx_a[0:1][0:1][0:1],
  input signed [36:0] mtx_b[0:1][0:1][0:1],

  input ready,

  // Result matrix
  output signed [36:0] mtx_r[0:1][0:1][0:1],

  // Goes high once calculation is complete.
  output reg available
);

  // Intermediate multiplication results
  // TODO: we might want to remove this intermediate buffer.
  reg signed [37:0] mult_results [0:1][0:1][0:1][0:1];

  // Calculate intermediate results
  genvar r2, c2, i2;
  generate
    for (r2 = 0; r2 < 2; r2 = r2 + 1) begin:R
      for (c2 = 0; c2 < 2; c2 = c2 + 1) begin:C
        // Assign multiplication results
        for (i2 = 0; i2 < 2; i2 = i2 + 1) begin:I2
          // TODO: think carefully about the implications here...
          assign mtx_r[r2][c2][i2] = ({1'b0, mult_results[r2][c2][0][i2]} +
                                      {1'b0, mult_results[r2][c2][1][i2]});
        end
      end
    end
  endgenerate

  reg [2:0] index;
  wire r = index[2];
  wire c = index[1];
  wire i = index[0];

  // Intermediate result
  wire signed [37:0] mult_result[0:1];

  // Do calculation
  complex_fix_mul cell_mul(mtx_a[r][i],
                           mtx_b[i][c],
                           mult_result);

  always @(posedge clk) begin

    if (reset) begin
      available <= 1;
    end else begin
      if (available) begin
        if (ready) begin
          index <= 0;
          available <= 0;
        end
      end else begin
        // Copy over multiplication results
        mult_results[r][c][i] <= mult_result;
        index <= index + 1;
        if (index == 3'b111) begin
          available <= 1;
        end
      end
    end
  end
endmodule // complex_matrix_multiplier
