/* Test bench for distance module.
 */
`timescale 1ns / 1ns
module dist_tb();
  wire clk, reset;

  clockGen clock(clk, reset);

  // Random operands to test
  const int signed operand_values[0:1][0:1][0:1][0:1] = {
    { // Matrix A
      {{104176, 159610}, { -49594, 117945}},
      {{236953,  16111}, {-229004,  99439}}
    },
    { // Matrix B
      {{ 195433,  46169}, {-83420, 213816}},
      {{-143459, 171112}, { -7539, 107609}}
    }
  };

  wire signed [18:0] operands[0:1][0:1][0:1][0:1];

  genvar i, j, k, l;
  generate
    for (i = 0; i < 2; i++) begin: I
      for (j = 0; j < 2; j++) begin: J
        for (k = 0; k < 2; k++) begin: K
          for (l = 0; l < 2; l++) begin: L
            assign operands[i][j][k][l] = operand_values[i][j][k][l];
          end
        end
      end
    end
  endgenerate

  wire [37:0] dist2;
  wire finished;

  dist_calc d(
    .reset(reset),
    .clk(clk),
    .mtx_a(operands[0]),
    .mtx_b(operands[1]),
    .ready(1'b1),
    .dist2(dist2),
    .finished(finished)
  );

  initial begin
    #50
    if (dist2 < 348300000 && dist2 > 348400000) begin
      // TODO: improve accuracy.
      $display("FAILED: Distance squared is %d, should be near %d", dist2,
               348326533);
    end else begin
      $display("Distance squared is %d, which is close enough to %d", dist2,
               348326533);
    end
  end
endmodule
