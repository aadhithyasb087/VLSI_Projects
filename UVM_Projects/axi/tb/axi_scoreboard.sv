class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)
  uvm_tlm_analysis_fifo#(axi_xtn) mas_wfifo_h;
  uvm_tlm_analysis_fifo#(axi_xtn) slv_wfifo_h;
  uvm_tlm_analysis_fifo#(axi_xtn) mas_rfifo_h;
  uvm_tlm_analysis_fifo#(axi_xtn) slv_rfifo_h;
  int wpasscount,wfailcount;
  int rpasscount,rfailcount;
  axi_env_cfg m_cfg;

  axi_xtn h_mas_wtrans;
  axi_xtn h_slv_wtrans;
  axi_xtn h_mas_rtrans;
  axi_xtn h_slv_rtrans;

  extern function new(string name="axi_scoreboard",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
endclass
//------------------------------------------------------------------------------------
function axi_scoreboard::new(string name="axi_scoreboard",uvm_component parent);
  super.new(name,parent);
  mas_wfifo_h=new("mas_wfifo_h",this);
  slv_wfifo_h=new("slv_wfifo_h",this);
  mas_rfifo_h=new("mas_rfifo_h",this);
  slv_rfifo_h=new("slv_rfifo_h",this);


endfunction
//------------------------------------------------------------------------------------
function void axi_scoreboard::build_phase(uvm_phase phase);
  `uvm_info(get_type_name(),"in build phase",UVM_LOW)
  if(!uvm_config_db#(axi_env_cfg)::get(this,"","axi_env_cfg",m_cfg))
    `uvm_fatal(get_type_name(),"config not get properly")

endfunction
//------------------------------------------------------------------------------------
task axi_scoreboard::run_phase(uvm_phase phase);
  fork
    forever begin
      mas_wfifo_h.get(h_mas_wtrans);
      slv_wfifo_h.get(h_slv_wtrans);
      m_cfg.no_of_act_wdata++;
      if(h_mas_wtrans.compare(h_slv_wtrans))begin
        `uvm_info(get_type_name(),"wdata matched",UVM_LOW)
        wpasscount++;
      end
      else begin
        `uvm_error(get_type_name(),"wdata mismatched")
        wfailcount++;
      end
    end
  
    forever begin 
      mas_rfifo_h.get(h_mas_rtrans);
      slv_rfifo_h.get(h_slv_rtrans);
      m_cfg.no_of_act_rdata++;      
      if(h_mas_rtrans.compare(h_slv_rtrans))begin
        `uvm_info(get_type_name(),"rdata matched",UVM_LOW)
        rpasscount++;
      end
      else begin
        `uvm_error(get_type_name(),"rdata mismatched")
        rfailcount++;
      end
    end
  join_none     

 
   
endtask
//------------------------------------------------------------------------------------
function void axi_scoreboard::report_phase(uvm_phase phase);

  `uvm_info(get_type_name(),$sformatf("wpasscount=%0d wfailcount=%0d w_actual_count=%0d",wpasscount,wfailcount,m_cfg.no_of_act_wdata),UVM_LOW)
  `uvm_info(get_type_name(),$sformatf("rpasscount=%0d rfailcount=%0d r_actual_count=%0d",rpasscount,rfailcount,m_cfg.no_of_act_rdata),UVM_LOW)

endfunction
