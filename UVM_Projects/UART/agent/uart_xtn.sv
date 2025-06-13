// uart_xtn.sv
// UART Transaction Class for UVM

class uart_xtn extends uvm_sequence_item;

  // Factory registration macro
  `uvm_object_utils(uart_xtn)

  //==================================================
  // Data Members (Inputs to DUT)
  //==================================================
  logic tx_start;        // Start signal for transmitter
  logic rx_start;        // Start signal for receiver
  logic rst;                  // Reset signal
  rand logic [7:0] tx_data;   // Data to be transmitted
  rand logic [16:0] baud;     // Baud rate for transmission
  rand logic parity_type;     // 0 - even, 1 - odd
  rand logic parity_en;       // Enable parity bit
  rand logic [3:0] length;    // Data length: 5 to 8 bits
  logic stop2;           // 0 - 1 stop bit, 1 - 2 stop bits

  //==================================================
  // Data Members (Outputs from DUT)
  //==================================================
  logic tx_err;               // Transmit error flag
  logic rx_err;               // Receive error flag
  logic tx_done;              // Transmit done signal
  logic rx_done;              // Receive done signal
  logic [7:0] rx_out;         // Received data output

  //==================================================
  // Constraints
  //==================================================
  constraint c1 { baud inside {4800, 9600, 14400, 19200, 38400, 57600}; } // Common baud rates
  constraint c2 { length inside {5, 6, 7, 8}; }                           // Valid UART word lengths

  //==================================================
  // Constructor
  //==================================================
  function new(string name = "uart_xtn");
    super.new(name);
  endfunction

endclass
