class host_mem extends uvm_component;
`uvm_component_utils(host_mem)

  
  logic [511:0] mem [0:1023];
  
  function new(string name="host_mem", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task wr_cmd(input logic [63:0] prp1, input logic [511:0] wr_cmd);
    mem[prp1[11:0]] = wr_cmd;
  endtask  

  task rd_cmd(input logic [63:0] prp1, output logic [511:0] rd_cmd);
    rd_cmd = mem[prp1[11:0]];
  endtask  

endclass
