class router_read_base_seq extends uvm_sequence#(op_xtn);
  `uvm_object_utils(router_read_base_seq)
 
  extern function new(string name="router_read_base_seq");
  extern task body();


endclass
//--------------------------------------------------------------------------------
function router_read_base_seq::new(string name="router_read_base_seq");
  super.new(name);
endfunction
//--------------------------------------------------------------------------------
task router_read_base_seq::body();
//  if(!uvm_config_db#(router_env_cfg)::get(null,get_full_name(),"router_env_cfg",m_cfg))
//    `uvm_fatal("dst seq","config not get properly")
endtask
//--------------------------------------------------------------------------------

class router_dst_normal_seq extends router_read_base_seq;
 `uvm_object_utils(router_dst_normal_seq)

  extern function new(string name="router_dst_normal_seq");
  extern task body();


endclass
//--------------------------------------------------------------------------------
function router_dst_normal_seq::new(string name="router_dst_normal_seq");
  super.new(name);
endfunction
//--------------------------------------------------------------------------------
task router_dst_normal_seq::body();
  req=op_xtn::type_id::create("req");
  start_item(req);
  `uvm_info("read_seq","in read seq",UVM_LOW)
    assert(req.randomize() with {no_of_cycles inside{[1:28]};});
   req.print();

  finish_item(req);
endtask




class router_dst_soft_reset_seq extends router_read_base_seq;
 `uvm_object_utils(router_dst_soft_reset_seq)

  extern function new(string name="router_dst_soft_reset_seq");
  extern task body();


endclass
//--------------------------------------------------------------------------------
function router_dst_soft_reset_seq::new(string name="router_dst_soft_reset_seq");
  super.new(name);
endfunction
//--------------------------------------------------------------------------------
task router_dst_soft_reset_seq::body();
  req=op_xtn::type_id::create("req");
  start_item(req);
  `uvm_info("read_seq","in read seq",UVM_LOW)
    assert(req.randomize() with {no_of_cycles inside{[30:50]};});
  // req.print();

  finish_item(req);
endtask



