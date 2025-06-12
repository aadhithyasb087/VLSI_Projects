class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)
  uvm_tlm_analysis_fifo#(ip_xtn) ip_fifo;
  uvm_tlm_analysis_fifo#(op_xtn) op_fifo0,op_fifo1,op_fifo2;

  ip_xtn h_ip_pkt[$];
  op_xtn h_op_pkt[$];
  ip_xtn h_ip_trans;
  op_xtn h_op_trans;
  ip_xtn h_ip_cov_trans;
  op_xtn h_op_cov_trans;
  int passcount;
  int failcount;

  covergroup src_cov;
    option.per_instance=1;

    ADDR: coverpoint h_ip_cov_trans.header[1:0] {
                                               bins add_0 ={2'b00};
                                               bins add_1 ={2'b01};
                                               bins add_2 ={2'b10};
                                                }

   PAYLOAD_LEN: coverpoint h_ip_cov_trans.header[7:2] {
                                               bins small_pkt ={[1:15]};
                                               bins medium_pkt ={[16:30]};
                                               bins large_pkt ={[31:63]};
                                                      }
      ERROR: coverpoint h_ip_cov_trans.error { 
                                               bins er0 ={1'b0};
                                               bins er1 ={1'b1};
                                          }
   ADDRXLEN: cross ADDR,PAYLOAD_LEN;

  endgroup


 covergroup dst_cov;
    option.per_instance=1;

    ADDR: coverpoint h_op_cov_trans.header[1:0] {
                                               bins add_0 ={2'b00};
                                               bins add_1 ={2'b01};
                                               bins add_2 ={2'b10};
                                                }

   PAYLOAD_LEN: coverpoint h_op_cov_trans.header[7:2] {
                                               bins small_pkt ={[1:15]};
                                               bins medium_pkt ={[16:30]};
                                               bins large_pkt ={[31:63]};
                                                      }
      
   ADDRXLEN: cross ADDR,PAYLOAD_LEN;

  endgroup

    
        

  extern function new(string name="router_scoreboard",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function bit data_check();
  extern function void report_phase(uvm_phase phase);
  endclass
//------------------------------------------------------------------------------------------
function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
  super.new(name,parent);
  ip_fifo=new("ip_fifo",this);
  op_fifo0=new("op_fifo0",this);
  op_fifo1=new("op_fifo1",this);
  op_fifo2=new("op_fifo2",this);
  src_cov=new();
  dst_cov=new();
endfunction
//------------------------------------------------------------------------------------------
function void router_scoreboard::build_phase(uvm_phase phase);


endfunction

function bit[7:0] parity_check(ip_xtn h_src_pkt);
  bit[7:0] parity=0;
  parity=parity^h_src_pkt.header;
  foreach(h_src_pkt.data_in[i])
    parity=parity^h_src_pkt.data_in[i];
  return parity;
endfunction

function bit router_scoreboard::data_check();
  ip_xtn h_src_pkt;
  op_xtn h_dst_pkt;
  bit[7:0] temp_par;
  if(h_dst_pkt.no_of_cycles>=30)begin
    `uvm_info(get_type_name(),"soft reset is done",UVM_LOW)
    return 1;
  end

  if(h_ip_pkt.size()==0)begin
    `uvm_error(get_type_name(),"extra data from DUT")     
    return 0;
  end
  else begin
    h_src_pkt=h_ip_pkt.pop_front();
    h_dst_pkt=h_op_pkt.pop_front();
    if(h_src_pkt.header!=h_dst_pkt.header)begin
      `uvm_error(get_type_name(),"header mismatch")
      return 0;
    end
    if(h_src_pkt.data_in.size()!=h_dst_pkt.payload.size())begin
      `uvm_error(get_type_name(),"payload size mismatch")
      return 0;
    end
    else begin
      foreach(h_src_pkt.data_in[i])begin
        if(h_src_pkt.data_in[i]!=h_dst_pkt.payload[i])begin
          `uvm_error(get_type_name(),"payload data mismatch")
          return 0;
        end
      end
    end
    
    if(h_src_pkt.parity!=h_dst_pkt.parity)begin
      `uvm_error(get_type_name(),"parity mismatch")
      return 0;
    end
    temp_par=parity_check(h_src_pkt);
    if(h_src_pkt.parity!= temp_par)begin
      if(h_src_pkt.error!=1)begin
        `uvm_error(get_type_name(),$sformatf("error not asserted temp_par=%0h src_par=%0h",temp_par,h_src_pkt.parity ))
        return 0;
      end
    end
    return 1;
  end
 
endfunction
//-------------------------------------------------------------
task router_scoreboard::run_phase(uvm_phase phase);
  fork
    forever begin
      ip_fifo.get(h_ip_trans);
      `uvm_info(get_type_name(),"in scbd",UVM_LOW)
      h_ip_trans.print();
      h_ip_cov_trans=h_ip_trans;
      src_cov.sample();
      h_ip_pkt.push_back(h_ip_trans);
    end
    forever begin
      op_fifo0.get(h_op_trans);
      `uvm_info(get_type_name(),"in scbd",UVM_LOW)
      h_op_trans.print();
      h_op_pkt.push_back(h_op_trans);
      if(data_check())begin
        `uvm_info(get_type_name(),"pkt is correct",UVM_LOW)
        passcount++;
        h_op_cov_trans=h_op_trans;
        dst_cov.sample();

      end
      else
        failcount++;
       
    end
    forever begin
      op_fifo1.get(h_op_trans);
      `uvm_info(get_type_name(),"in scbd",UVM_LOW)
      h_op_trans.print();
      h_op_pkt.push_back(h_op_trans);
      if(data_check())begin
        `uvm_info(get_type_name(),"pkt is correct",UVM_LOW)
        passcount++;
        h_op_cov_trans=h_op_trans;
        dst_cov.sample();

      end
      else
        failcount++;
       

    end
    forever begin
      op_fifo2.get(h_op_trans);
      `uvm_info(get_type_name(),"in scbd",UVM_LOW)
      h_op_trans.print();
      h_op_pkt.push_back(h_op_trans);
      if(data_check())begin
        `uvm_info(get_type_name(),"pkt is correct",UVM_LOW)
        passcount++;
        h_op_cov_trans=h_op_trans;
        dst_cov.sample();

      end
      else
        failcount++;
       
    end
  join
endtask

function void router_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("passcount=%0d failcount=%0d",passcount,failcount),UVM_LOW)
endfunction

