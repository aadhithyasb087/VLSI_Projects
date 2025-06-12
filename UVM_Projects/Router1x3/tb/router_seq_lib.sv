class router_seq_base extends uvm_sequence#(ip_xtn);
  `uvm_object_utils(router_seq_base)
  router_env_cfg m_cfg;
  extern function new(string name="router_seq_base");
  extern task body(); 
endclass
//----------------------------------------------------------------------
function router_seq_base::new(string name="router_seq_base");
  super.new(name);
endfunction
//----------------------------------------------------------------------
task router_seq_base::body();
  if(!uvm_config_db#(router_env_cfg)::get(null,get_full_name(),"router_env_cfg",m_cfg))
    `uvm_fatal("router seq","env config not get properly")
endtask
//----------------------------------------------------------------------
class router_small_pkt_seq extends router_seq_base;
  `uvm_object_utils(router_small_pkt_seq)

  extern function new(string name="router_small_pkt_seq");
  extern task body();

endclass
//----------------------------------------------------------------------
function router_small_pkt_seq::new(string name="router_small_pkt_seq");
  super.new(name);
endfunction
//----------------------------------------------------------------------
task router_small_pkt_seq::body();
  super.body();
  req=ip_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize with{header[1:0]==m_cfg.addr;header[7:2] inside {[1:14]};parity==0;});
    finish_item(req);
endtask






class router_medium_pkt_seq extends router_seq_base;
  `uvm_object_utils(router_medium_pkt_seq)

  extern function new(string name="router_medium_pkt_seq");
  extern task body();

endclass
//----------------------------------------------------------------------
function router_medium_pkt_seq::new(string name="router_medium_pkt_seq");
  super.new(name);
endfunction
//----------------------------------------------------------------------
task router_medium_pkt_seq::body();
  super.body();
  req=ip_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize with{header[1:0]==m_cfg.addr;header[7:2] inside {[16:30]};parity==0;});
    finish_item(req);
endtask






class router_large_pkt_seq extends router_seq_base;
  `uvm_object_utils(router_large_pkt_seq)

  extern function new(string name="router_large_pkt_seq");
  extern task body();

endclass
//----------------------------------------------------------------------
function router_large_pkt_seq::new(string name="router_large_pkt_seq");
  super.new(name);
endfunction
//----------------------------------------------------------------------
task router_large_pkt_seq::body();
  super.body();
  req=ip_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize with{header[1:0]==m_cfg.addr;header[7:2] inside {[31:63]};parity==0;});
  finish_item(req);
endtask




class router_error_pkt_seq extends router_seq_base;
  `uvm_object_utils(router_error_pkt_seq)

  extern function new(string name="router_error_pkt_seq");
  extern task body();

endclass
//----------------------------------------------------------------------
function router_error_pkt_seq::new(string name="router_error_pkt_seq");
  super.new(name);
endfunction
//----------------------------------------------------------------------
task router_error_pkt_seq::body();
  super.body();
  req=ip_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize with{header[1:0]==m_cfg.addr;header[7:2] inside {[1:15]};parity==100;});
  finish_item(req);
endtask

  

  
