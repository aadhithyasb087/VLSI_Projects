interface apb_intf();
  // APB signals
  logic pclk;
  logic presetn;
  logic [31:0] paddr;
  logic pwrite;
  logic [31:0] pwdata;
  logic penable;
  logic psel;
  logic [31:0] prdata;
  logic pslverr;
  logic pready;

  // Driver clocking block
  clocking M_DRV @(posedge pclk);
    input prdata;
    input pready;
    input pslverr;
    
output paddr;
output pwrite;
output pwdata;
output psel;
 output penable;
  endclocking

  // Monitor clocking block
  clocking M_MON @(posedge pclk);
    input presetn;
input paddr;
input pwrite;
input pwdata;
input psel;
input penable;
    input prdata;
input pready;
input pslverr;
  endclocking



  // Slave clocking block
  clocking S_MON @(posedge pclk);
    input presetn; 
input paddr;
input pwrite;
input pwdata;
input psel;
input penable;
    output prdata;
output pready;
output pslverr;
  endclocking


  // Modports
  modport M_DRV_MOD(clocking M_DRV);
  modport M_MON_MOD(clocking M_MON);
  modport S_MON_MOD(clocking S_MON);

endinterface : apb_intf



