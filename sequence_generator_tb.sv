/* Tests the sequence generator.
 *
 */
`timescale 1ns / 1ns
module sequence_generator_tb();
  wire clk, reset, complete;
  wire [4:0] seq_index;
  wire [4:0] seq_gate;
  wire ready;
  wire first;
  reg start, available;

  // Clock generator
  clockGen clk_gen(clk, reset);

  // Sequence generator (DUT)
  sequence_generator sg(
    .clk(clk),
    .reset(reset),

    // From the Coordinator
    .max_length(5'd3),
    .start(start),
    .complete(complete),

    // To the Sequence Multiplier
    .seq_index(seq_index),
    .seq_gate(seq_gate),
    .ready(ready),
    .first(first),
    .available(available)
  );

  // Emulate the Sequence Multiplier
  always @(posedge clk) begin
    available <= ready;
  end

  // Start the enumeration
  initial begin
    #40
    start = 1;
    #10
    start = 0;
  end
endmodule

