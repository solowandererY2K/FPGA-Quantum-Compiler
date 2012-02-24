/* Tests the coordinator.
 *
 */
`timescale 1ns / 1ns
module coordinator_tb();
  wire clk, reset;

  reg [7:0] received_byte;
  reg received_ready;

  wire [7:0] transmit_byte;
  reg  transmit_available;
  wire transmit_ready;

  wire [7:0] green_leds;

  // Clock generator
  clockGen clk_gen(clk, reset);

  // Coordinator (DUT)
  coordinator coord(
    clk,
    reset,

    // From the UART receiver
    received_byte,
    received_ready,

    // To the UART transmitter
    transmit_byte,
    transmit_available,
    transmit_ready,

    // To the LEDs
    green_leds
  );

  // Test matrix to send
  const var signed [36:0] test_mtx[0:1][0:1][0:1] = '{
    '{'{ 37'd24296004000, 0}, '{37'd24296004001, 0}},
    '{'{ 37'd24296004002, 0}, '{-37'd24296004003, 0}}
  };

  // Start the enumeration
  // This should yield the unsigned number 92210483850
  integer row, col, imag, byte_index;
  var signed [36:0] num;
  initial begin
    received_ready <= 0;
    #40

    // Test the LEDs.
    received_byte  <= "L";
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte  <= 8'b10010101;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    if (green_leds == 8'b10010101) begin
      $display("PASSED: Green LEDs.");
    end else begin
      $display("FAILED: Green LEDs.");
    end

    // Test the distance decoder.
    received_byte  <= "D";
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte <= 8'b10001010;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte <= 8'b01010010;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte <= 8'b00101100;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte <= 8'b01111000;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    #10
    received_byte <= 8'b01110101;
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    // TODO: verify here.

    // Now, we'll test the matrix decoder.
    #10
    received_byte  <= "M";
    received_ready <= 1'b1;
    #10
    received_ready <= 1'b0;
    for (row = 0; row < 2; row++) begin
      for (col = 0; col < 2; col++) begin
        for (imag = 0; imag < 2; imag++) begin
          num <= test_mtx[row][col][imag];
          for (byte_index = 0; byte_index < 5; byte_index++) begin
            #10
            received_byte <= num[7:0];
            received_ready <= 1'b1;
            num <= num >> 8;
            #10
            received_ready <= 1'b0;
          end
        end
      end
    end
    // TODO: verify here.
  end
endmodule

