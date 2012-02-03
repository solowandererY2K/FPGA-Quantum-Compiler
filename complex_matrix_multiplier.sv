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
module complex_matrix_multiplier (
  input reset,
  input clk,

  // Matrices
  input signed [18:0] mtx_a[0:1][0:1][0:1],
  input signed [18:0] mtx_b[0:1][0:1][0:1],

  input ready,

  // Result matrix
  output signed [18:0] mtx_r[0:1][0:1][0:1],

  // Goes high once calculation is complete.
  output reg completed
);

  // Intermediate multiplication results
  // TODO: we might want to remove this intermediate buffer.
  reg signed [19:0] mult_results [0:1][0:1][0:1][0:1];

  // Intermediate result wires
  wire signed [19:0] w_mult_results [0:1][0:1][0:1][0:1];

  // Buffers for the input matrices
  reg signed [18:0] mtx_a_buf[0:1][0:1][0:1];
  reg signed [18:0] mtx_b_buf[0:1][0:1][0:1];

  // Calculate intermediate results
  genvar r, c, i;
  generate
    for (r = 0; r < 2; r = r + 1) begin:R
      for (c = 0; c < 2; c = c + 1) begin:C
        for (i = 0; i < 2; i = i + 1) begin:I
          // Do calculation
          complex_fix_mul mul_$r$c$i(mtx_a_buf[r][i], mtx_b_buf[i][c],
                                     w_mult_results[r][c][i]);

          // Copy over multiplication results
          always @(posedge clk) begin
            mult_results[r][c][i] <= w_mult_results[r][c][i];
          end
        end

        // Copy over buffers
        always @(posedge clk) begin
          mtx_a_buf[r][c] <= mtx_a[r][c];
          mtx_b_buf[r][c] <= mtx_b[r][c];
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

  always @(posedge clk) begin
    if (reset) begin
      mult_completed <= 0;
      completed <= 0;
    end else begin
      completed <= mult_completed;
      mult_completed <= ready;
    end
  end
endmodule // complex_matrix_multiplier
