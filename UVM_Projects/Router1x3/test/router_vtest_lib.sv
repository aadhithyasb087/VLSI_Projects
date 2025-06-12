class router_base_test extends uvm_test;
  `uvm_component_utils(router_base_test)
  router_env h_env;
 
  router_env_cfg h_env_cfg; 
  router_ip_agt_cfg h_ip_agt_cfg[];
  router_op_agt_cfg h_op_agt_cfg[];
  bit[1:0] addr;
  extern function new(string name="router_base_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void router_config();
endclass
//----------------------------------------------------------------------------------------------------------
function router_base_test::new(string name="router_base_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_base_test::router_config();
  foreach(h_ip_agt_cfg[i])begin
    h_ip_agt_cfg[i]=router_ip_agt_cfg::type_id::create($sformatf("h_ip_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual router_intf)::get(this,"","ip_intf",h_ip_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"config not get")
  end

  foreach(h_op_agt_cfg[i])begin
    h_op_agt_cfg[i]=router_op_agt_cfg::type_id::create($sformatf("h_op_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual router_intf)::get(this,"",$sformatf("intf[%0d]",i),h_op_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"config not get")
  end
endfunction
//----------------------------------------------------------------------------------------------------------
function void router_base_test::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in test build_phase",UVM_LOW)
  h_env_cfg=router_env_cfg::type_id::create("h_env_cfg");
  h_env_cfg.addr=this.addr;
  h_env_cfg.no_of_ip_agents=1;
  h_env_cfg.no_of_op_agents=3;
  h_env_cfg.h_ip_agt_cfg=new[h_env_cfg.no_of_ip_agents];
  h_env_cfg.h_op_agt_cfg=new[h_env_cfg.no_of_op_agents];
  h_ip_agt_cfg=new[h_env_cfg.no_of_ip_agents];
  h_op_agt_cfg=new[h_env_cfg.no_of_op_agents];

  router_config();
  foreach(h_ip_agt_cfg[i])
    h_env_cfg.h_ip_agt_cfg[i]=h_ip_agt_cfg[i];
  foreach(h_op_agt_cfg[i])  
    h_env_cfg.h_op_agt_cfg[i]=h_op_agt_cfg[i];
  uvm_config_db#(router_env_cfg)::set(this,"*","router_env_cfg",h_env_cfg);
  h_env=router_env::type_id::create("h_env",this);
endfunction
//----------------------------------------------------------------------------------------------------------
class small_pkt_test extends router_base_test;
  `uvm_component_utils(small_pkt_test)

  router_small_pkt_vseq h_seq;
  extern function new(string name="small_pkt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function small_pkt_test::new(string name="small_pkt_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void small_pkt_test::build_phase(uvm_phase phase);
   addr=$urandom_range(0,2);
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task small_pkt_test::run_phase(uvm_phase phase);
  h_seq=router_small_pkt_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask




class medium_pkt_test extends router_base_test;
  `uvm_component_utils(medium_pkt_test)

  router_medium_pkt_vseq h_seq;
  extern function new(string name="medium_pkt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function medium_pkt_test::new(string name="medium_pkt_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void medium_pkt_test::build_phase(uvm_phase phase);
  addr=$urandom_range(0,2);  
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task medium_pkt_test::run_phase(uvm_phase phase);
  h_seq=router_medium_pkt_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask

class large_pkt_test extends router_base_test;
  `uvm_component_utils(large_pkt_test)

  router_large_pkt_vseq h_seq;
  extern function new(string name="large_pkt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function large_pkt_test::new(string name="large_pkt_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void large_pkt_test::build_phase(uvm_phase phase);
  addr=$urandom_range(0,2);
 // addr=2;  
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task large_pkt_test::run_phase(uvm_phase phase);
  h_seq=router_large_pkt_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
 
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask





class error_pkt_test extends router_base_test;
  `uvm_component_utils(error_pkt_test)

  router_error_pkt_vseq h_seq;
  extern function new(string name="error_pkt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function error_pkt_test::new(string name="error_pkt_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void error_pkt_test::build_phase(uvm_phase phase);
  addr=$urandom_range(0,2);  
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task error_pkt_test::run_phase(uvm_phase phase);
  h_seq=router_error_pkt_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  h_seq.start(h_env.h_vseqr);
  phase.drop_objection(this);
endtask


class large_rst_pkt_test extends router_base_test;
  `uvm_component_utils(large_rst_pkt_test)

  router_large_rst_pkt_vseq h_seq;
  extern function new(string name="large_rst_pkt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function large_rst_pkt_test::new(string name="large_rst_pkt_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void large_rst_pkt_test::build_phase(uvm_phase phase);
  addr=$urandom_range(0,2);
  //addr=2;  
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task large_rst_pkt_test::run_phase(uvm_phase phase);
  h_seq=router_large_rst_pkt_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
 
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask


//----------------------------------------------------------------------------------------------------------
class small_pkt0_test extends router_base_test;
  `uvm_component_utils(small_pkt0_test)

  router_small_pkt0_vseq h_seq;
  extern function new(string name="small_pkt0_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function small_pkt0_test::new(string name="small_pkt0_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void small_pkt0_test::build_phase(uvm_phase phase);
   addr=0;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task small_pkt0_test::run_phase(uvm_phase phase);
  h_seq=router_small_pkt0_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask

//----------------------------------------------------------------------------------------------------------
class small_pkt1_test extends router_base_test;
  `uvm_component_utils(small_pkt1_test)

  router_small_pkt1_vseq h_seq;
  extern function new(string name="small_pkt1_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function small_pkt1_test::new(string name="small_pkt1_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void small_pkt1_test::build_phase(uvm_phase phase);
   addr=1;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task small_pkt1_test::run_phase(uvm_phase phase);
  h_seq=router_small_pkt1_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask


//----------------------------------------------------------------------------------------------------------
class small_pkt2_test extends router_base_test;
  `uvm_component_utils(small_pkt2_test)

  router_small_pkt2_vseq h_seq;
  extern function new(string name="small_pkt2_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function small_pkt2_test::new(string name="small_pkt2_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void small_pkt2_test::build_phase(uvm_phase phase);
   addr=2;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task small_pkt2_test::run_phase(uvm_phase phase);
  h_seq=router_small_pkt2_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask



//----------------------------------------------------------------------------------------------------------
class medium_pkt0_test extends router_base_test;
  `uvm_component_utils(medium_pkt0_test)

  router_medium_pkt0_vseq h_seq;
  extern function new(string name="medium_pkt0_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function medium_pkt0_test::new(string name="medium_pkt0_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void medium_pkt0_test::build_phase(uvm_phase phase);
   addr=0;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task medium_pkt0_test::run_phase(uvm_phase phase);
  h_seq=router_medium_pkt0_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask

//----------------------------------------------------------------------------------------------------------
class medium_pkt1_test extends router_base_test;
  `uvm_component_utils(medium_pkt1_test)

  router_medium_pkt1_vseq h_seq;
  extern function new(string name="medium_pkt1_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function medium_pkt1_test::new(string name="medium_pkt1_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void medium_pkt1_test::build_phase(uvm_phase phase);
   addr=1;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task medium_pkt1_test::run_phase(uvm_phase phase);
  h_seq=router_medium_pkt1_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask


//----------------------------------------------------------------------------------------------------------
class medium_pkt2_test extends router_base_test;
  `uvm_component_utils(medium_pkt2_test)

  router_medium_pkt2_vseq h_seq;
  extern function new(string name="medium_pkt2_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function medium_pkt2_test::new(string name="medium_pkt2_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void medium_pkt2_test::build_phase(uvm_phase phase);
   addr=2;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task medium_pkt2_test::run_phase(uvm_phase phase);
  h_seq=router_medium_pkt2_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask


//----------------------------------------------------------------------------------------------------------
class large_pkt0_test extends router_base_test;
  `uvm_component_utils(large_pkt0_test)

  router_large_pkt0_vseq h_seq;
  extern function new(string name="large_pkt0_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function large_pkt0_test::new(string name="large_pkt0_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void large_pkt0_test::build_phase(uvm_phase phase);
   addr=0;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task large_pkt0_test::run_phase(uvm_phase phase);
  h_seq=router_large_pkt0_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask

//----------------------------------------------------------------------------------------------------------
class large_pkt1_test extends router_base_test;
  `uvm_component_utils(large_pkt1_test)

  router_large_pkt1_vseq h_seq;
  extern function new(string name="large_pkt1_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function large_pkt1_test::new(string name="large_pkt1_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void large_pkt1_test::build_phase(uvm_phase phase);
   addr=1;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task large_pkt1_test::run_phase(uvm_phase phase);
  h_seq=router_large_pkt1_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask


//----------------------------------------------------------------------------------------------------------
class large_pkt2_test extends router_base_test;
  `uvm_component_utils(large_pkt2_test)

  router_large_pkt2_vseq h_seq;
  extern function new(string name="large_pkt2_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------------------------------------
function large_pkt2_test::new(string name="large_pkt2_test",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------------------------------------
function void large_pkt2_test::build_phase(uvm_phase phase);
   addr=2;
     
  super.build_phase(phase);
endfunction
//----------------------------------------------------------------------------------------------------------
task large_pkt2_test::run_phase(uvm_phase phase);
  h_seq=router_large_pkt2_vseq::type_id::create("h_seq");
  phase.raise_objection(this);
  //repeat(5)
  h_seq.start(h_env.h_vseqr);
  #100;
  phase.drop_objection(this);
endtask



