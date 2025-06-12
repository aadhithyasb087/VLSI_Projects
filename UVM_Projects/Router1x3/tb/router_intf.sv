interface router_intf(input bit clock);
  logic resetn;
  logic read_enb;
  logic pkt_valid;
  logic[7:0] data_in;
  logic valid_out;
  logic error;
  logic busy;
  logic[7:0] data_out;
//------------------------------------------------------------------
  clocking IP_DRCB@(posedge clock);
    output pkt_valid;
    output data_in;
    output resetn;
    input error;
    input busy;
  endclocking
//------------------------------------------------------------------
  clocking IP_MRCB@(posedge clock);
    input pkt_valid;
    input data_in;
    input resetn;
    input error;
    input busy;
  endclocking
//------------------------------------------------------------------
  clocking OP_DRCB@(posedge clock);
    output read_enb;
    output resetn;
    input valid_out;
  endclocking
//------------------------------------------------------------------
  clocking OP_MRCB@(posedge clock);
    input read_enb;
    input valid_out;
    input data_out;
    input resetn;
  endclocking

  modport IP_DR_MP (clocking IP_DRCB);
  modport IP_MR_MP (clocking IP_MRCB);
  modport OP_DR_MP (clocking OP_DRCB);
  modport OP_MR_MP (clocking OP_MRCB);


  property assert_busy;
    @(posedge clock)disable iff(!resetn)
    $rose(pkt_valid)|=> busy;
  endproperty
  
  property assert_read_enb;
    @(posedge clock) disable iff(!resetn)
    $rose(valid_out)|-> ##[1:$](read_enb);
  endproperty

  property assert_data_out;
    @(posedge clock) disable iff(!resetn)
    $rose(read_enb)|=>$changed(data_out);
  endproperty

  property assert_data_in;
    @(posedge clock) disable iff(!resetn)
    busy|=> $stable(data_in);
  endproperty

 
  property assert_low_read_enb;
    @(posedge clock) disable iff(!resetn)
    $fell(valid_out)|=> (read_enb==0);
  endproperty

  A1:assert property(assert_busy);
  A2:assert property(assert_read_enb);
  A3:assert property(assert_data_out);
  A4:assert property(assert_data_in);
  A5:assert property(assert_low_read_enb);
  
  
endinterface
