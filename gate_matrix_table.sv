/* Table for storing gate matrices.
 * On each clock cycle, it loads a real or an imaginary component.
 *
 * TODO: consider using multiple M4K blocks to parallelize the load process.
 */
`timescale 1ns / 1ns
module gate_matrix_table(clk, reset, gate, result, ready, done_pulse);

  input clk, reset;

  // From client
  input [4:0] gate;
  input ready;

  // To client
  // TODO: register needed?
  output reg signed [36:0] result[0:1][0:1][0:1];
  reg done;

  // Result index
  reg [2:0] index;
  reg [2:0] last_index;

  // Result index broken out by bits for convenience
  wire row = last_index[2], column = last_index[1], imag = last_index[0];

  // Current number
  wire [39:0] dataout_sig;
  wire init_busy_sig;
  wire [7:0] address_sig = {gate, index};

  gate_rom gate_rom_inst (
    .address ( address_sig ),
    .clock ( clk ),
    .q ( dataout_sig )
  );

  output reg done_pulse;

  always @(posedge clk) begin
    done_pulse <= 0;
    if (reset || init_busy_sig) begin
      index <= 0;
      last_index <= 0;
      done <= 1;
    end else begin
      if (done) begin
        index <= 0;
        last_index <= 0;
        if (ready) begin
          done <= 0;
        end
      end else begin
        result[row][column][imag] <= dataout_sig[36:0];
        index                     <= index + 1;
        last_index                <= index;
        done                      <= (last_index == 3'b111);
        done_pulse                <= (last_index == 3'b111);
      end
    end
  end
endmodule
