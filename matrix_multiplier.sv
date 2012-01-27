module matrix_multiplier (
  input reset,
  input clk,

  // Matrix A
  input [18:0] mtx_a[0:1][0:1],

  // Matrix B
  input [18:0] mtx_b[0:1][0:1],

  // True once both matrices are ready
  input        ready,

  // Result matrix
  output [18:0] mtx_r[0:1][0:1],

  // Goes high once calculation is complete.
  output reg completed
);

  // Intermediate multiplication results
  reg [18:0] mult_results [0:1][0:1][0:1];

  // Intermediate result wires
  wire [18:0] w_mult_results [0:1][0:1][0:1];

  // Buffers for the input matrices
  reg [18:0] mtx_a_buf[0:1][0:1];
  reg [18:0] mtx_b_buf[0:1][0:1];

  // Calculate intermediate results
  genvar r, c, i;
  generate
    for (r = 0; r < 2; r = r + 1) begin:R
      for (c = 0; c < 2; c = c + 1) begin:C
        for (i = 0; i < 2; i = i + 1) begin:I
          // Do calculation
          fixmul(mtx_a_buf[r][i], mtx_b_buf[i][c], w_mult_results[r][c][i]);

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
        assign mtx_r[r][c] = mult_results[r][c][0] + mult_results[r][c][1];
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
endmodule // matrix_multiplier
