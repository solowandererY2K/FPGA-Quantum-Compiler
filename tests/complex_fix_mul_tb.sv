`timescale 1ns / 1ns
module complex_fix_mul_tb ();
  wire clk, reset;

  clockGen clock(clk, reset);

  integer i;
  localparam TEST_COUNT = 5;
  localparam REAL = 0, IMAG = 1;

  // Operands to try
  const var signed [18:0] operands[TEST_COUNT][2][2] = {
    {{ 104176 , 159610},
     { -49594 , 117945}},

    {{ 236953 ,  16111},
     {-229004 ,  99439}},

    {{ 195433 ,  46169},
     { -83420 , 213816}},

    {{-143459 , 171112},
     {  -7539 , 107609}},

    {{ 104176 , 159610},
     { 195443 ,  46169}}
  };

  const var signed [18:0] results[TEST_COUNT][2] = {
    { -91521 ,  16675},
    {-213109 ,  75809},
    { -99849 , 144712},
    { -66115 , -63810},
    {  49554 , 137340}
  };

  reg signed [18:0] x[0:1], y[0:1];
  wire signed [19:0] out[0:1];

  complex_fix_mul cfm(x, y, out);

  integer signed real_diff, imag_diff;
  integer errors;

  initial begin
    errors = 0;
    #20
    for (i = 0; i < TEST_COUNT; i = i + 1) begin
      x = operands[i][0];
      y = operands[i][1];

      #20

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
