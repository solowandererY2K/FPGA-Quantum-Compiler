// Calculates the distance between two matrices, as a fixed-point fraction.
// Begins a calculation when mtx_a_ready and mtx_b_ready are high.
// Emits matrix value indices, and expects the resulting value to be available
// on the next clock cycle for multiplication.
`timescale 1ns / 1ns
module dist_calc(reset, clk, mtx_a, mtx_b, ready, dist2, finished);
`include "types.svi"

  input reset;
  input clk;

  // Matrices
  input signed [NUMBER_BITS-1:0] mtx_a[0:1][0:1][0:1];
  input signed [NUMBER_BITS-1:0] mtx_b[0:1][0:1][0:1];
  input ready;

  output reg [2*(NUMBER_BITS+3):0] dist2; // Positive fractional result
  output reg finished; // goes high when calculation is complete

  // Calculations
  // z11 = ca(cm(cc(M1.z11), M2.z11), cm(cc(M1.z21), M2.z21));
  // z22 = ca(cm(cc(M1.z12), M2.z12), cm(cc(M1.z22), M2.z22));
  // return my_cabs(ca(z11, z22));

  reg  signed [NUMBER_BITS:0]         mults  [0:1][0:1][0:1];
  wire signed [NUMBER_BITS:0]         mults_w[0:1];
  wire signed [NUMBER_BITS+1:0]       sums[0:1][0:1];
  wire signed [NUMBER_BITS+2:0]       final_sum[0:1];
  wire signed [2*(NUMBER_BITS+3)-1:0] squares[0:1];
  wire signed [2*(NUMBER_BITS+3):0]   result;

  reg [2:0] index;
  wire mtx_i = index[1];
  wire mtx_j = index[0];

  wire signed [NUMBER_BITS-1:0] ops[0:1][0:1][0:1];

  complex_fix_mul mul(ops    [mtx_j][mtx_i],
                      mtx_b  [mtx_j][mtx_i],
                      mults_w);

  genvar i, j, k;
  generate
    for (i = 0; i < 2; i++) begin:I
      for (j = 0; j < 2; j++) begin:J
        assign ops[j][i][REAL] =  mtx_a[j][i][REAL];
        assign ops[j][i][IMAG] = -mtx_a[j][i][IMAG];
      end
      add_ex #(NUMBER_BITS+1) addr(mults[0][i][REAL], mults[1][i][REAL],
                                   sums[i][REAL]);
      add_ex #(NUMBER_BITS+1) addi(mults[0][i][IMAG], mults[1][i][IMAG],
                                   sums[i][IMAG]);
    end
    add_ex #(NUMBER_BITS+2) final_adder_real(sums[0][REAL], sums[1][REAL],
                                             final_sum[REAL]);
    add_ex #(NUMBER_BITS+2) final_adder_imag(sums[0][IMAG], sums[1][IMAG],
                                             final_sum[IMAG]);

    // Square the real and imaginary parts.
    squarer sq1(final_sum[REAL], squares[REAL]);
    squarer sq2(final_sum[IMAG], squares[IMAG]);

    // Add the results
    add_ex #(80) result_adder(squares[REAL], squares[IMAG], result);
  endgenerate

  always @(posedge clk) begin
    if (reset) begin
      finished <= 1;
    end else begin
      // TODO: changed finished to available.
      if (finished) begin
        if (ready) begin
          index    <= 0;
          finished <= 0;
        end
      end else begin
        if (index == 3'b100) begin
          index <= 0;
          finished <= 1;
          dist2 <= result;
        end else begin
          index <= index + 1;
          mults[mtx_j][mtx_i][0] <= mults_w[0];
          mults[mtx_j][mtx_i][1] <= mults_w[1];
        end
      end
    end
  end
endmodule
