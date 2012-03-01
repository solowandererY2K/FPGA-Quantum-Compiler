`timescale 1ns / 1ns
module complex_matrix_multiplier_tb();
  wire clk, reset, available;
  wire signed [36:0] result[0:1][0:1][0:1];
  clockGen clock(clk, reset);

  // Arbitrary operands to test
  const var signed [36:0] operands[0:1][0:1][0:1][0:1] = '{
    '{ // Matrix A
      '{'{37'd13654556672, 37'd20920401920}, '{ -37'd6500384768, 37'd15459287040}},
      '{'{37'd31057903616, 37'd2111700992}, '{-37'd30016012288, 37'd13033668608}}
    },
    '{ // Matrix B
      '{'{  37'd25615794176, 37'd6051463168}, '{-37'd10934026240, 37'd28025290752}},
      '{'{ -37'd18803458048, 37'd22427992064}, '{ -37'd988151808, 37'd14104526848}}
    }
  };

  // Expected result
  const var signed [36:0] expected_result[0:1][0:1][0:1] = '{
    '{'{-37'd38352538, 37'd5298181296}, '{ -37'd27567794009, 37'd1366940658}},
    '{'{37'd30701042779, -37'd19681123915}, '{-37'd16092739515, 37'd11963900486}}
  };

  complex_matrix_multiplier cmm (
    .reset(reset),
    .clk(clk),

    // Matrices
    .mtx_a(operands[0]),
    .mtx_b(operands[1]),

    .ready(1'b1),

    // Result matrix
    .mtx_r(result),

    // Goes high once calculation is complete.
    .available(available)
  );

  integer _row, _col, _imag;
  initial begin
    #120
    for (_row = 0; _row < 2; _row = _row + 1) begin
      for (_col = 0; _col < 2; _col = _col + 1) begin
        for (_imag = 0; _imag < 2; _imag = _imag + 1) begin
          if (result[_row][_col][_imag] == expected_result[_row][_col][_imag]) begin
            $display("PASSED: Got expected result for row %d, col %d, imag %d",
                     _row, _col, _imag);
          end else begin
            $display("FAILED: Got %d but expected %d for row %d, col %d, imag %d",
                     result[_row][_col][_imag],
                     expected_result[_row][_col][_imag],
                     _row, _col, _imag);
          end
        end
      end
    end
  end
endmodule

