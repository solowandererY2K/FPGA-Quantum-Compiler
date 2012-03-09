/* Test bench for distance module.
 */
`timescale 1ns / 1ns
module dist_tb();
`include "types.svi"

  wire clk, reset;

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

  wire signed [2*(NUMBER_BITS+3):0] dist2;
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
    #200
    if (dist2 < 81'd382989073500000000000 && dist2 > 81'd382989073400000000000) begin
      // TODO: improve accuracy.
      $display("Distance squared is %d, which is close enough to %d", dist2,
               81'd382989073463199000000);
    end else begin
      $display("FAILED: Distance squared is %d, should be near %d", dist2,
               81'd382989073463199000000);
    end
  end
endmodule
