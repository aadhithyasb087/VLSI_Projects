class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)
  mas_agt_top h_m_agt_top;
  slv_agt_top h_s_agt_top;
  axi_env_cfg m_cfg;
  axi_scoreboard h_scbd;
  extern function new(string name="axi_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void start_of_simulation_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass
//----------------------------------------------------------------------------
function axi_env::new(string name="axi_env",uvm_component parent);
  super.new(name,parent);
endfunction
//----------------------------------------------------------------------------
function void axi_env::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(axi_env_cfg)::get(this,"","axi_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get properly")
  if(m_cfg.has_mas_agt_top)
    h_m_agt_top=mas_agt_top::type_id::create("h_m_agt_top",this);
  if(m_cfg.has_slv_agt_top)  
    h_s_agt_top=slv_agt_top::type_id::create("h_s_agt_top",this);
  if(m_cfg.has_scbd)
    h_scbd=axi_scoreboard::type_id::create("h_scbd",this);
endfunction
//----------------------------------------------------------------------------
function void axi_env::start_of_simulation_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction
//----------------------------------------------------------------------------
function void axi_env::connect_phase(uvm_phase phase);
  if(m_cfg.has_mas_agt_top)begin
     h_m_agt_top.h_agt[0].h_mon.mas_mon_wport.connect(h_scbd.mas_wfifo_h.analysis_export);
     h_m_agt_top.h_agt[0].h_mon.mas_mon_rport.connect(h_scbd.mas_rfifo_h.analysis_export);
  end
  if(m_cfg.has_slv_agt_top)begin
     h_s_agt_top.h_agt[0].h_mon.slv_mon_wport.connect(h_scbd.slv_wfifo_h.analysis_export);
     h_s_agt_top.h_agt[0].h_mon.slv_mon_rport.connect(h_scbd.slv_rfifo_h.analysis_export);
  end
endfunction
