// Test bench that attempts to get the Hadamard gate from the gate table.
`timescale 1ns / 1ns
module gate_matrix_table_tb();
  wire clk, reset, done;
  wire signed [36:0] result[0:1][0:1][0:1];

  clockGen clock(clk, reset);

  gate_matrix_table gmt(
    .clk(clk),
    .reset(reset),
    .gate(5'd0),
    .result(result),
    .ready(1'b1),
    .done_pulse(done)
  );

  // Expected result
  const int signed expected_result[0:1][0:1][0:1] = '{
    '{'{185363, 0}, '{ 185363, 0}},
    '{'{185363, 0}, '{-185363, 0}}
  };

  integer _row, _col, _imag;

  initial begin
    // TODO: exhaustively test
    #125
    for (_row = 0; _row < 2; _row = _row + 1) begin
      for (_col = 0; _col < 2; _col = _col + 1) begin
        for (_imag = 0; _imag < 2; _imag = _imag + 1) begin
          if (result[_row][_col][_imag] ==
              expected_result[_row][_col][_imag]) begin
            $display("For row %d, col %d, imag %d, expected result obtained! %d %d",
              _row, _col, _imag,
              result[_row][_col][_imag],
              expected_result[_row][_col][_imag]);
          end else begin
            $display("ERROR: For row %d, col %d, imag %d, received result %d but expected %d",
              _row, _col, _imag,
              result[_row][_col][_imag],
              expected_result[_row][_col][_imag]);
          end
        end
      end
    end
  end
endmodule
