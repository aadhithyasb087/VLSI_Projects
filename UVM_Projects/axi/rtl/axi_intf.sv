interface axi_intf(input logic clk);
  
  //write addr channel
  logic[3:0] awid;
  logic[31:0] awaddr;
  logic[3:0] awlen;
  logic[2:0] awsize;
  logic[1:0] awburst;
  logic      awvalid;
  logic      awready;
  logic      resetn;
  //write data channel
  logic[3:0] wid;
  logic[31:0] wdata;
  logic[3:0] wstrb;
  logic      wlast;
  logic      wvalid;
  logic      wready;

  //write response channel
  logic[3:0] bid;
  logic[1:0] bresp;
  logic      bvalid;
  logic      bready;

  //read address channel
  logic[3:0]  arid;
  logic[31:0] araddr;
  logic[3:0]  arlen;
  logic[2:0]  arsize;
  logic[1:0]  arburst;
  logic       arvalid;
  logic       arready;

  //read data channel
  logic[3:0]  rid;
  logic[31:0] rdata;
  logic[1:0]  rresp;
  logic       rlast;
  logic       rvalid;
  logic       rready;
//-------------------------------------------------------------------
  clocking mas_dr_cb @(posedge clk);
    //write addr channel
    //default input#0 output#0;
    output awid;
    output awaddr;
    output awlen;
    output awsize;
    output awburst;
    output awvalid;
    input  awready;
    output resetn;
    //write data channel
    output wid;
    output wdata;
    output wstrb;
    output wlast;
    output wvalid;
    input  wready;

    //write resp channel
    input  bvalid;
    output bready;
    input bid;
    input bresp;

    //read addr channel
    output arid;
    output araddr;
    output arlen;
    output arsize;
    output arburst;
    output arvalid;
    input  arready;

    //read data channel
    input rvalid;
    output rready;
    input rid;
    input rdata;
    input rresp;
    input rlast;



  endclocking
//-------------------------------------------------------------------
  clocking mas_mr_cb @(posedge clk);
    //default input#0 output#0;

  //write addr channel

    input awid;
    input awaddr;
    input awlen;
    input awsize;
    input awburst;
    input awvalid;
    input  awready;
    input resetn;
    //write data channel
    input wid;
    input wdata;
    input wstrb;
    input wlast;
    input wvalid;
    input  wready;

    //write resp channel
    input  bvalid;
    input bready;
    input bid;
    input bresp;    

    //read addr channel
    input arid;
    input araddr;
    input arlen;
    input arsize;
    input arburst;
    input arvalid;
    input  arready;

    //read data channel
    input rvalid;
    input rready;
    input rid;
    input rdata;
    input rresp;
    input rlast;


  endclocking
//-------------------------------------------------------------------
  clocking slv_dr_cb @(posedge clk);
   // default input#0 output#0;

    //write addr channel
    input  awvalid;
    output awready;
    input awid;
    input awaddr;
    input awlen;
    input awsize;
    input awburst;
    input resetn;

    //write data channel
    input  wvalid;
    output wready;
    input wid;
    input wdata;
    input wstrb;
    input wlast;

    //write resp channel
    output bid;
    output bresp;
    output bvalid;
    input  bready;

    //read addr channel
    input arid;
    input araddr;
    input arlen;
    input arsize;
    input arburst;
    input  arvalid;
    output arready;

    //read data channel
    output rid;
    output rdata;
    output rresp;
    output rlast;
    output rvalid;
    input  rready;
  endclocking
//-------------------------------------------------------------------
  clocking slv_mr_cb @(posedge clk);
    //default input#0 output#0;

    //write addr channel
    input  awvalid;
    input awready;
    input awid;
    input awaddr;
    input awlen;
    input awsize;
    input awburst;
    input resetn;
    //write data channel
    input wvalid;
    input wready;
    input wid;
    input wdata;
    input wstrb;
    input wlast;

    //write resp channel
    input bid;
    input bresp;
    input bvalid;
    input bready;

    //read addr channel
    input  arvalid;
    input arready;
    input arid;
    input araddr;
    input arlen;
    input arsize;
    input arburst;

    //read data channel
    input rid;
    input rdata;
    input rresp;
    input rlast;
    input rvalid;
    input  rready;
  endclocking



endinterface
