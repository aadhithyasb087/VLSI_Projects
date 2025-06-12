class router_vseq_base extends uvm_sequence;
  `uvm_object_utils(router_vseq_base)
  router_env_cfg m_cfg;
  router_vsequencer h_vseqr;
  router_ip_seqr h_ip_seqr[];
  router_op_seqr h_op_seqr[];
  router_small_pkt_seq h_small_seq;
  router_medium_pkt_seq h_medium_seq;
  router_large_pkt_seq h_large_seq;
  router_dst_normal_seq h_dst_nseq;
  router_dst_soft_reset_seq h_dst_srst_seq;
  router_error_pkt_seq h_error_seq;


  extern function new(string name="router_vseq_base");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_vseq_base::new(string name="router_vseq_base");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_vseq_base::body();
  if(!uvm_config_db#(router_env_cfg)::get(null,get_full_name(),"router_env_cfg",m_cfg))
    `uvm_fatal("virtual seq","env config not get properly")

   h_ip_seqr=new[m_cfg.no_of_ip_agents];
   h_op_seqr=new[m_cfg.no_of_op_agents];
   assert($cast(h_vseqr,m_sequencer)) else begin
     `uvm_error("BODY", "Error in $cast of virtual sequencer")
   end
  foreach(h_ip_seqr[i])
    h_ip_seqr[i]=h_vseqr.h_ip_seqr[i];

  foreach(h_op_seqr[i])
    h_op_seqr[i]=h_vseqr.h_op_seqr[i];

endtask
//---------------------------------------------------------------------
class router_small_pkt_vseq extends router_vseq_base;
  `uvm_object_utils(router_small_pkt_vseq)
    extern function new(string name="router_small_pkt_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_small_pkt_vseq::new(string name="router_small_pkt_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_small_pkt_vseq::body();
  super.body();
  h_small_seq=router_small_pkt_seq::type_id::create("h_small_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_small_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask
  

class router_medium_pkt_vseq extends router_vseq_base;
  `uvm_object_utils(router_medium_pkt_vseq)

  extern function new(string name="router_medium_pkt_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_medium_pkt_vseq::new(string name="router_medium_pkt_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_medium_pkt_vseq::body();
  super.body();
  h_medium_seq=router_medium_pkt_seq::type_id::create("h_medium_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  fork
    h_medium_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
endtask


class router_large_pkt_vseq extends router_vseq_base;
  `uvm_object_utils(router_large_pkt_vseq)
 
  extern function new(string name="router_large_pkt_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_large_pkt_vseq::new(string name="router_large_pkt_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_large_pkt_vseq::body();
  super.body();
//  h_dst_srst_seq=router_dst_soft_reset_seq::type_id::create("h_dst_srst_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  h_large_seq=router_large_pkt_seq::type_id::create("h_large_seq");
  fork
    h_large_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
   // h_dst_srst_seq.start(h_op_seqr[m_cfg.addr]);
  join
endtask




class router_error_pkt_vseq extends router_vseq_base;
  `uvm_object_utils(router_error_pkt_vseq)
    extern function new(string name="router_error_pkt_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_error_pkt_vseq::new(string name="router_error_pkt_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_error_pkt_vseq::body();
  super.body();
  h_error_seq=router_error_pkt_seq::type_id::create("h_error_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  fork
    h_error_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
endtask


class router_large_rst_pkt_vseq extends router_vseq_base;
  `uvm_object_utils(router_large_rst_pkt_vseq)
 
  extern function new(string name="router_large_rst_pkt_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_large_rst_pkt_vseq::new(string name="router_large_rst_pkt_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_large_rst_pkt_vseq::body();
  super.body();
  h_dst_srst_seq=router_dst_soft_reset_seq::type_id::create("h_dst_srst_seq");
  //h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  h_large_seq=router_large_pkt_seq::type_id::create("h_large_seq");
  fork
    h_large_seq.start(h_ip_seqr[0]);
    //h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
    h_dst_srst_seq.start(h_op_seqr[m_cfg.addr]);
  join
endtask


class router_small_pkt0_vseq extends router_vseq_base;
  `uvm_object_utils(router_small_pkt0_vseq)
    extern function new(string name="router_small_pkt0_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_small_pkt0_vseq::new(string name="router_small_pkt0_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_small_pkt0_vseq::body();
  super.body();
  h_small_seq=router_small_pkt_seq::type_id::create("h_small_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_small_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask



class router_small_pkt1_vseq extends router_vseq_base;
  `uvm_object_utils(router_small_pkt1_vseq)
    extern function new(string name="router_small_pkt1_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_small_pkt1_vseq::new(string name="router_small_pkt1_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_small_pkt1_vseq::body();
  super.body();
  h_small_seq=router_small_pkt_seq::type_id::create("h_small_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_small_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask


class router_small_pkt2_vseq extends router_vseq_base;
  `uvm_object_utils(router_small_pkt2_vseq)
    extern function new(string name="router_small_pkt2_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_small_pkt2_vseq::new(string name="router_small_pkt2_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_small_pkt2_vseq::body();
  super.body();
  h_small_seq=router_small_pkt_seq::type_id::create("h_small_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_small_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask






class router_medium_pkt0_vseq extends router_vseq_base;
  `uvm_object_utils(router_medium_pkt0_vseq)
    extern function new(string name="router_medium_pkt0_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_medium_pkt0_vseq::new(string name="router_medium_pkt0_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_medium_pkt0_vseq::body();
  super.body();
  h_medium_seq=router_medium_pkt_seq::type_id::create("h_medium_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_medium_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask



class router_medium_pkt1_vseq extends router_vseq_base;
  `uvm_object_utils(router_medium_pkt1_vseq)
    extern function new(string name="router_medium_pkt1_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_medium_pkt1_vseq::new(string name="router_medium_pkt1_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_medium_pkt1_vseq::body();
  super.body();
  h_medium_seq=router_medium_pkt_seq::type_id::create("h_medium_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_medium_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask


class router_medium_pkt2_vseq extends router_vseq_base;
  `uvm_object_utils(router_medium_pkt2_vseq)
    extern function new(string name="router_medium_pkt2_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_medium_pkt2_vseq::new(string name="router_medium_pkt2_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_medium_pkt2_vseq::body();
  super.body();
  h_medium_seq=router_medium_pkt_seq::type_id::create("h_medium_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_medium_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask



class router_large_pkt0_vseq extends router_vseq_base;
  `uvm_object_utils(router_large_pkt0_vseq)
    extern function new(string name="router_large_pkt0_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_large_pkt0_vseq::new(string name="router_large_pkt0_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_large_pkt0_vseq::body();
  super.body();
  h_large_seq=router_large_pkt_seq::type_id::create("h_large_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_large_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask



class router_large_pkt1_vseq extends router_vseq_base;
  `uvm_object_utils(router_large_pkt1_vseq)
    extern function new(string name="router_large_pkt1_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_large_pkt1_vseq::new(string name="router_large_pkt1_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_large_pkt1_vseq::body();
  super.body();
  h_large_seq=router_large_pkt_seq::type_id::create("h_large_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_large_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask


class router_large_pkt2_vseq extends router_vseq_base;
  `uvm_object_utils(router_large_pkt2_vseq)
    extern function new(string name="router_large_pkt2_vseq");
  extern task body();

endclass
//---------------------------------------------------------------------
function router_large_pkt2_vseq::new(string name="router_large_pkt2_vseq");
  super.new(name);
endfunction
//---------------------------------------------------------------------
task router_large_pkt2_vseq::body();
  super.body();
  h_large_seq=router_large_pkt_seq::type_id::create("h_large_seq");
  h_dst_nseq=router_dst_normal_seq::type_id::create("h_dst_nseq");
  
  fork
    h_large_seq.start(h_ip_seqr[0]);
    h_dst_nseq.start(h_op_seqr[m_cfg.addr]);
  join
  
endtask






  



