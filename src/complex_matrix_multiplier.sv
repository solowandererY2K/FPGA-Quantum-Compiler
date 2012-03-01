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
  output reg completed
);

  // Intermediate multiplication results
  // TODO: we might want to remove this intermediate buffer.
  reg signed [37:0] mult_results [0:1][0:1][0:1][0:1];

  // Intermediate result wires
  wire signed [37:0] w_mult_results [0:1][0:1][0:1][0:1];

  // Buffers for the input matrices
  reg signed [36:0] mtx_a_buf[0:1][0:1][0:1];
  reg signed [36:0] mtx_b_buf[0:1][0:1][0:1];

  // Calculate intermediate results
  genvar r, c, i;
  generate
    for (r = 0; r < 2; r = r + 1) begin:R
      for (c = 0; c < 2; c = c + 1) begin:C
        for (i = 0; i < 2; i = i + 1) begin:I
          // Do calculation
          complex_fix_mul cell_mul(mtx_a_buf[r][i], mtx_b_buf[i][c],
                                   w_mult_results[r][c][i]);
        end

        // Assign multiplication results
        for (i = 0; i < 2; i = i + 1) begin:I2
          // TODO: think carefully about the implications here...
          assign mtx_r[r][c][i] = ({1'b0, mult_results[r][c][0][i]} +
                                   {1'b0, mult_results[r][c][1][i]});
        end
      end
    end
  endgenerate

  reg mult_completed;

  integer r2, c2, i2;

  always @(posedge clk) begin
    // Do register transfers
    for (r2 = 0; r2 < 2; r2 = r2 + 1) begin
      for (c2 = 0; c2 < 2; c2 = c2 + 1) begin
        for (i2 = 0; i2 < 2; i2 = i2 + 1) begin
          // Copy over multiplication results
          mult_results[r2][c2][i2] <= w_mult_results[r2][c2][i2];
        end

        // Copy over buffers
        mtx_a_buf[r2][c2] <= mtx_a[r2][c2];
        mtx_b_buf[r2][c2] <= mtx_b[r2][c2];
      end
    end

    if (reset) begin
      mult_completed <= 0;
      completed      <= 0;
    end else begin
      completed      <= mult_completed;
      mult_completed <= ready;
      mtx_a_buf      <= mtx_a;
      mtx_b_buf      <= mtx_b;
    end
  end
endmodule // complex_matrix_multiplier
