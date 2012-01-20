// Calculates the distance between two matrices, as a fixed-point fraction.
// Begins a calculation when mtx_a_ready and mtx_b_ready are high.
// Emits matrix value indices, and expects the resulting value to be available
// on the next clock cycle for multiplication.
module dist (
  input reset,
  input clk,

  // Matrix A stuff
  input  [18:0] mtx_a_real,
  input  [18:0] mtx_a_imag,
  output        mtx_a_row,
  output        mtx_a_col,
  wire          mtx_a_ready,

  // Matrix B stuff
  input  [18:0] mtx_b_real,
  input  [18:0] mtx_b_imag,
  output        mtx_b_row,
  output        mtx_b_col,
  wire          mtx_b_ready,

  output reg [15:0] dist2, // 16 bit positive fractional result
  output finished // goes high when calculation is complete
);

  parameter SIMULATE=0;

  reg [3:0] calc_state; // Stores calculation state

  // z11 = ca(cm(cc(M1.z11), M2.z11), cm(cc(M1.z21), M2.z21));
  // z22 = ca(cm(cc(M1.z12), M2.z12), cm(cc(M1.z22), M2.z22));
  // return my_cabs(ca(z11, z22));

  // Your circuit goes here
  always @(posedge clk) begin
    if (reset) begin
    end else begin
      case (calc_state)
        4'd0: begin // see if both matrices are ready.
          end
        4'd1: begin // cm(cc(M1.z11), M2.z11)
          end
        4'd2: begin // cm(cc(M1.z21), M2.z21)
          end
        4'd3: begin // z11 = ca(cm(cc(M1.z11), M2.z11), cm(cc(M1.z21), M2.z21));
          end
        4'd4: begin // cm(cc(M1.z12), M2.z12)
          end
        4'd5: begin // cm(cc(M1.z22), M2.z22)
          end
        4'd6: begin // z22 = ca(cm(cc(M1.z12), M2.z12), cm(cc(M1.z22), M2.z22));
          end
        4'd7: begin // tr = ca(z11/2, z22/2)
          end
        4'd8: begin // tr.real * tr.real, tr.imag * tr.imag, mark finished
          end
      endcase
    end
  end

endmodule
