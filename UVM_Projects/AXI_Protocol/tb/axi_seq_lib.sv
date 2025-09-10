class axi_seq_base extends uvm_sequence#(axi_xtn);
  `uvm_object_utils(axi_seq_base)
  //axi_xtn h_trans;
  axi_env_cfg m_cfg;
  extern function new(string name="axi_seq_base");
  extern task body();

endclass

function axi_seq_base::new(string name="axi_seq_base");
  super.new(name);
endfunction

task axi_seq_base::body();
  if(!uvm_config_db#(axi_env_cfg)::get(null,get_full_name(),"axi_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get properly")

endtask
//-----------------------------------------------------------------------

class axi_master_seq extends axi_seq_base;
  `uvm_object_utils(axi_master_seq)

  extern function new(string name="axi_master_seq");
  extern task body();

endclass

function axi_master_seq::new(string name="axi_master_seq");
  super.new(name);
endfunction

task axi_master_seq::body();
  super.body();
  repeat(1)begin
    req=axi_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize());
    finish_item(req);
  end
endtask
