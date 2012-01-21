module matrix_multiplier (
  input reset,
  input clk,

  // Matrix A
  // TODO: use Verilog arrays
  input [18:0] mtx_a_r1c1,
  input [18:0] mtx_a_r1c2,
  input [18:0] mtx_a_r2c1,
  input [18:0] mtx_a_r2c2,
  input        mtx_a_ready,

  // Matrix B
  input [18:0] mtx_b_r1c1,
  input [18:0] mtx_b_r1c2,
  input [18:0] mtx_b_r2c1,
  input [18:0] mtx_b_r2c2,
  input        mtx_b_ready,

  // Result matrix
  output [18:0] mtx_r_r1c1,
  output [18:0] mtx_r_r1c2,
  output [18:0] mtx_r_r2c1,
  output [18:0] mtx_r_r2c2,

  // Goes high once calculation is complete.
  output reg completed
);

  // Intermediate multiplication results
  reg [18:0] mtx_a_r1c1_times_b_r1c1;
  reg [18:0] mtx_a_r1c2_times_b_r2c1;
  reg [18:0] mtx_a_r2c1_times_b_r1c1;
  reg [18:0] mtx_a_r2c2_times_b_r2c1;
  reg [18:0] mtx_a_r1c1_times_b_r1c2;
  reg [18:0] mtx_a_r1c2_times_b_r2c2;
  reg [18:0] mtx_a_r2c1_times_b_r1c2;
  reg [18:0] mtx_a_r2c2_times_b_r2c2;

  // Intermediate result wires
  wire [18:0] w_mtx_a_r1c1_times_b_r1c1;
  wire [18:0] w_mtx_a_r1c2_times_b_r2c1;
  wire [18:0] w_mtx_a_r2c1_times_b_r1c1;
  wire [18:0] w_mtx_a_r2c2_times_b_r2c1;
  wire [18:0] w_mtx_a_r1c1_times_b_r1c2;
  wire [18:0] w_mtx_a_r1c2_times_b_r2c2;
  wire [18:0] w_mtx_a_r2c1_times_b_r1c2;
  wire [18:0] w_mtx_a_r2c2_times_b_r2c2;

  // Calculate intermediate results
  fixmul(mtx_a_r1c1, mtx_b_r1c1, w_mtx_a_r1c1_times_b_r1c1);
  fixmul(mtx_a_r1c2, mtx_b_r2c1, w_mtx_a_r1c2_times_b_r2c1);
  fixmul(mtx_a_r2c1, mtx_b_r1c1, w_mtx_a_r2c1_times_b_r1c1);
  fixmul(mtx_a_r2c2, mtx_b_r2c1, w_mtx_a_r2c2_times_b_r2c1);
  fixmul(mtx_a_r1c1, mtx_b_r1c2, w_mtx_a_r1c1_times_b_r1c2);
  fixmul(mtx_a_r1c2, mtx_b_r2c2, w_mtx_a_r1c2_times_b_r2c2);
  fixmul(mtx_a_r2c1, mtx_b_r1c2, w_mtx_a_r2c1_times_b_r1c2);
  fixmul(mtx_a_r2c2, mtx_b_r2c2, w_mtx_a_r2c2_times_b_r2c2);

  // Assign multiplication results
  assign mtx_r_r1c1 = mtx_a_r1c1_times_b_r1c1 + mtx_a_r1c2_times_b_r2c1;
  assign mtx_r_r1c2 = mtx_a_r1c1_times_b_r1c2 + mtx_a_r1c2_times_b_r2c2;
  assign mtx_r_r2c1 = mtx_a_r2c1_times_b_r1c1 + mtx_a_r2c2_times_b_r2c1;
  assign mtx_r_r2c2 = mtx_a_r2c1_times_b_r1c2 + mtx_a_r2c2_times_b_r2c2;

  reg mult_completed;

  always @(posedge clk) begin
    if (reset) begin
      mult_completed <= 0;
      completed <= 0;
    end else begin
      completed <= mult_completed;
      mult_completed <= mtx_a_ready && mtx_b_ready;

      // Assign the multiplication results
      mtx_a_r1c1_times_b_r1c1 <= w_mtx_a_r1c1_times_b_r1c1;
      mtx_a_r1c2_times_b_r2c1 <= w_mtx_a_r1c2_times_b_r2c1;
      mtx_a_r2c1_times_b_r1c1 <= w_mtx_a_r2c1_times_b_r1c1;
      mtx_a_r2c2_times_b_r2c1 <= w_mtx_a_r2c2_times_b_r2c1;
      mtx_a_r1c1_times_b_r1c2 <= w_mtx_a_r1c1_times_b_r1c2;
      mtx_a_r1c2_times_b_r2c2 <= w_mtx_a_r1c2_times_b_r2c2;
      mtx_a_r2c1_times_b_r1c2 <= w_mtx_a_r2c1_times_b_r1c2;
      mtx_a_r2c2_times_b_r2c2 <= w_mtx_a_r2c2_times_b_r2c2;
    end
  end
endmodule // matrix_multiplier
