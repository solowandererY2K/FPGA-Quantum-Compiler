`timescale 1ns / 1ns
module complex_fix_mul_clocked_tb();
`include "types.svi"
  wire clk, reset;

  clockGen clock(clk, reset);

  integer i;
  localparam TEST_COUNT = 2;

  // Operands to try
  const var signed [NUMBER_BITS-1:0] operands[TEST_COUNT][2][2] = '{
    '{'{37'd13654556672, 37'd20920401920},
      '{  37'd25615794176, 37'd6051463168}},

    '{'{ -37'd18803458048, 37'd22427992064},
      '{ -37'd988151808, 37'd14104526848}}
  };

  const var signed [NUMBER_BITS-1:0] results[TEST_COUNT][2] = '{
    '{37'd6495197059,   37'd18001381437},
    '{-37'd8665826904 ,  -37'd8363746450}
  };

  reg signed [NUMBER_BITS-1:0] x[0:1], y[0:1];
  wire signed [NUMBER_BITS:0] out[0:1];

  wire available;
  reg ready;
  complex_fix_mul_clocked cfm(clk, reset, x, y, out, available, ready);

  integer signed real_diff, imag_diff;
  integer errors;

  initial begin
    errors = 0;
    ready = 0;
    #20
    for (i = 0; i < TEST_COUNT; i = i + 1) begin
      x = operands[i][0];
      y = operands[i][1];
      ready = 1;

      #40

      if (!(available == 1)) begin
        // TODO: fix
        $display("Results should be available, but available isn't high.");
      end

      real_diff = results[i][REAL] - out[REAL];
      real_diff = (real_diff < 0) ? -real_diff : real_diff;

      imag_diff = results[i][IMAG] - out[IMAG];
      imag_diff = (imag_diff < 0) ? -imag_diff : imag_diff;

      $display("(%d + I*%d)(%d + I*%d) should be (%d + I*%d)",
        operands[i][0][REAL], operands[i][0][IMAG],
        operands[i][1][REAL], operands[i][1][IMAG],
        results[i][REAL], results[i][IMAG]);

      $display("calculated (%d + I*%d), real diff %d, imag diff %d",
        out[REAL], out[IMAG], real_diff, imag_diff);

      if (real_diff > 6 || imag_diff > 6) begin
        errors = errors + 1;
        // TODO: improve calculation accuracy.
        $display("FAILED: off by more than 6.");
      end
    end
    if (errors == 0) begin
      $display("ALL TESTS PASSED");
    end
  end
endmodule

