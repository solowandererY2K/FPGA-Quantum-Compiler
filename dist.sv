// Calculates the distance between two matrices, as a fixed-point fraction.
// Begins a calculation when mtx_a_ready and mtx_b_ready are high.
// Emits matrix value indices, and expects the resulting value to be available
// on the next clock cycle for multiplication.
module dist_calc (
  input reset,
  input clk,

  // Matrices
  input signed [18:0] mtx_a[0:1][0:1][0:1],
  input signed [18:0] mtx_b[0:1][0:1][0:1],
  input ready,

  output reg [37:0] dist2, // Positive fractional result
                           // TODO: sign bit left off because result can't be -
  output reg finished // goes high when calculation is complete
);

  localparam REAL = 0, IMAG = 1;

  // Calculations
  // z11 = ca(cm(cc(M1.z11), M2.z11), cm(cc(M1.z21), M2.z21));
  // z22 = ca(cm(cc(M1.z12), M2.z12), cm(cc(M1.z22), M2.z22));
  // return my_cabs(ca(z11, z22));

  wire signed [19:0] mults[0:1][0:1][0:1];
  wire signed [20:0] sums[0:1][0:1];
  wire signed [21:0] final_sum[0:1];
  wire signed [36:0] squares[0:1];
  wire signed [37:0] result;

  genvar i, j, k;
  generate
    for (i = 0; i < 2; i++) begin:I
      for (j = 0; j < 2; j++) begin:J
        wire signed [18:0] op [0:1];
        assign op[REAL] = mtx_a[j][i][REAL];
        assign op[IMAG] = -mtx_a[j][i][IMAG];
        complex_fix_mul mul(op, mtx_b[j][i], mults[j][i]);
      end
      add_ex #(20) addr(mults[0][i][REAL], mults[1][i][REAL], sums[i][REAL]);
      add_ex #(20) addi(mults[0][i][IMAG], mults[1][i][IMAG], sums[i][IMAG]);
    end
    add_ex #(21)    final_adder_real(sums[0][REAL], sums[1][REAL], final_sum[REAL]);
    add_ex #(21)    final_adder_imag(sums[0][IMAG], sums[1][IMAG], final_sum[IMAG]);

    // Square the real and imaginary parts, also dividing by 8 to make them
    // fit into our 19-bit limit.
    fixmul #(19,37) sq1(final_sum[REAL][21:3], final_sum[REAL][21:3], squares[REAL]);
    fixmul #(19,37) sq2(final_sum[IMAG][21:3], final_sum[IMAG][21:3], squares[IMAG]);

    // Add the results
    add_ex #(37)    result_adder(squares[REAL], squares[IMAG], result);
  endgenerate

  always @(posedge clk) begin
    if (reset) begin
      finished <= 0;
    end else begin
      finished <= ready;

      dist2 <= result;
    end
  end
endmodule
