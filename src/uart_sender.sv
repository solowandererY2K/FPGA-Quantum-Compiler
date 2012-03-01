/* A really basic UART (so we can avoid having to instantiate Altera
 * SOPC megafunctions!)
 */
module uart_sender(
  input  clk, reset,
  input  [7:0] data_to_send, // Data to send, LSB first
  input  data_to_send_ready, // Raise high when data_to_send contains valid data
  output ready_to_send, // Goes high once UART is ready to send.
  output txd // Connected to the board's TxD pin
);

  parameter UART_PERIOD = 868, UART_PERIOD_BITS = 10;

  // Clock divider
  reg [UART_PERIOD_BITS-1:0] timer;

  // Bits to send.
  reg [10:0] send_buffer;

  assign ready_to_send = (send_buffer == 0);

  // Hold the line high while waiting to send, otherwise send data.
  assign txd = ready_to_send ? 1'b1 : send_buffer[0];

  always @(posedge clk) begin
    if (reset) begin
      send_buffer <= 0;
      timer <= 0;
    end else begin
      if (timer == 0) begin
        timer <= UART_PERIOD - 1;
        if (ready_to_send) begin
          if (data_to_send_ready) begin
            // Copy new bits to send buffer
            send_buffer <= {2'b1, data_to_send, 1'b0};
          end else begin
            send_buffer <= send_buffer;
          end
        end else begin
          // Shift bits
          send_buffer <= {1'b0, send_buffer[10:1]};
        end
      end else begin
        send_buffer <= send_buffer;
        timer <= timer - 1;
      end
    end
  end
endmodule
