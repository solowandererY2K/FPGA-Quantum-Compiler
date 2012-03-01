`timescale 1ns / 1ns
module complex_matrix_multipler_top_tb();
  wire clk, reset;
  reg done, operand, row, col, imag, in_ready, in_finished;
  reg signed [18:0] matrix_in;

  clockGen clock(clk, reset);

  complex_matrix_multiplier_top cmmp(reset, clk,
    matrix_in,

    imag,    // high if imaginary, low if real
    row,     // high for row 1,    low for row 0
    col,     // high for column 1, low for column 0
    operand, // 0 for left operand, 1 for right one.
    in_ready,
    in_finished,

    done // goes high once the transmit is done
  );

  // Random operands to test
  const int signed operands[0:1][0:1][0:1][0:1] = {
    { // Matrix A
      {{ 52088,  79805}, { -24797,  58972}},
      {{118476,   8055}, {-114502,  49719}}
    },
    { // Matrix B
      {{  97716,  23084}, {-41710, 106908}},
      {{ -71729,  85556}, { -3769,  53804}}
    }
  };

  // Expected result
  // TODO: actually use these, and make them match what they're supposed to
  // be.
  // const int signed expected_result[1:0][1:0][1:0] = {
  //   {{  -293,   40422}, {-210325, 10428}},
  //   {{234230, -150155}, {-122778, 91277}}
  // };

  integer _operand, _row, _col, _imag;

  initial begin
    in_ready = 1;
    #20
    // TODO: wait for clock?
    for (_operand = 0; _operand < 2; _operand = _operand + 1) begin
      for (_row = 0; _row < 2; _row = _row + 1) begin
        for (_col = 0; _col < 2; _col = _col + 1) begin
          for (_imag = 0; _imag < 2; _imag = _imag + 1) begin
            #10
            operand   = _operand;
            row       = _row;
            col       = _col;
            imag      = _imag;
            matrix_in = operands[_operand][_row][_col][_imag];
            $display("Transmitting number %d", matrix_in);
          end
        end
      end
    end
    #10
    in_ready = 0;
    // TODO: check output values when done.
  end
endmodule
