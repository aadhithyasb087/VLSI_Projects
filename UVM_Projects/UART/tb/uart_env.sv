// uart_env.sv
// UVM Environment that instantiates agent and scoreboard

class uart_env extends uvm_env;

  uart_agent      agent;
  uart_scoreboard scoreboard;

  `uvm_component_utils(uart_env)

  // Constructor
  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase: Create agent and scoreboard
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent      = uart_agent::type_id::create("agent", this);
    scoreboard = uart_scoreboard::type_id::create("scoreboard", this);
  endfunction

  // Connect phase: Connect monitor analysis port to scoreboard analysis export
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.send.connect(scoreboard.recv); 
  endfunction

endclass
