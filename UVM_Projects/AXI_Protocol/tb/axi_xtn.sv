class axi_xtn extends uvm_sequence_item;
 
  int w_start_addr,r_start_addr;
  int w_no_bytes,r_no_bytes;
  int data_bus_bytes=4;
  int w_alligned_addr,r_alligned_addr;
  int w_burst_len,r_burst_len;
  int w_addr_n,r_addr_n;
  int w_wrap_boundary,r_wrap_boundary;
  int lbl,ubl;
//  bit[3:0] rstrb[];    //m

  int w_addr[],r_addr[];
  //write addr channel

  rand bit[3:0] awid;      //m
  rand bit[31:0] awaddr;   //m
  rand bit[3:0] awlen;     //m
  rand bit[2:0] awsize;    //m
  rand bit[1:0] awburst;   //m
 // bit awvalid;        //m
 // bit awready;        //s

 //write data channel

  rand bit[3:0] wid;      //m
  rand bit[31:0] wdata[];   //m
  bit[3:0] wstrb[];    //m
  // bit wlast;
  // bit wvalid;
  // bit wready;

  //write resp channel

  rand bit[3:0] bid;      //s
  rand bit[1:0] bresp;    //s
 // bit bvalid;        //s
 // bit bready;        //m

  //read addr channel

  rand bit[3:0] arid;     //m
  rand bit[31:0] araddr;  //m
  rand bit[3:0] arlen;    //m
  rand bit[2:0] arsize;   //m
  rand bit[1:0] arburst;   //m
  // bit arvalid;       //m
  // bit arready        //s

  //read data channel

  rand bit[3:0] rid;      //s
  rand bit[31:0] rdata[];   //s
  rand bit[1:0] rresp;
  // bit rlast;
  // bit rvalid;
  // bit rready;

 `uvm_object_utils_begin(axi_xtn)
    `uvm_field_int(awid,UVM_ALL_ON)
    `uvm_field_int(awaddr,UVM_ALL_ON)
    `uvm_field_int(awlen,UVM_ALL_ON)
    `uvm_field_int(awsize,UVM_ALL_ON)
    `uvm_field_int(awburst,UVM_ALL_ON)
    `uvm_field_int(wid,UVM_ALL_ON)
    `uvm_field_array_int(wdata,UVM_ALL_ON)
    `uvm_field_array_int(wstrb,UVM_ALL_ON)
    `uvm_field_int(bid,UVM_ALL_ON)
    `uvm_field_int(bresp,UVM_ALL_ON)
    `uvm_field_int(arid,UVM_ALL_ON)
    `uvm_field_int(araddr,UVM_ALL_ON)
    `uvm_field_int(arlen,UVM_ALL_ON)
    `uvm_field_int(arsize,UVM_ALL_ON)
    `uvm_field_int(arburst,UVM_ALL_ON)
    `uvm_field_int(rid,UVM_ALL_ON)
    `uvm_field_array_int(rdata,UVM_ALL_ON)
    `uvm_field_int(rresp,UVM_ALL_ON)
    `uvm_field_array_int(w_addr,UVM_ALL_ON)
    `uvm_field_array_int(r_addr,UVM_ALL_ON)
    `uvm_object_utils_end


  constraint c1 {awid == wid;} 
  constraint c2 {awsize inside {[0:2]};}
  constraint c3 {awburst inside {[0:2]};}
  constraint c4 {wdata.size == awlen+1;}
  constraint c5 {if(((awburst == 0)||(awburst ==2)) && (awsize==1)) awaddr%2==0;}
  constraint c6 {if(((awburst == 0)||(awburst ==2)) && (awsize==2)) awaddr%4==0;}
  //constraint c7 {arid == rid;}
  constraint c8 {arsize inside {[0:2]};}
  constraint c9 {arburst inside {[0:2]};}
  constraint c10 {rdata.size == arlen+1;}
  constraint c11 {awaddr<=4096;}
  constraint c12 {araddr<=4096;}
  constraint c13 {awid == bid;}
  constraint c14 {bresp == 2'b00;}
  constraint c15 {rresp == 2'b00;}
//  constraint c11 


  function void w_addr_calc();

    int wb;
  
   for(int i=1;i<w_burst_len;i++)begin
      
      if(awburst ==0)begin
         w_addr[i]=awaddr;
      end
      if(awburst ==1)begin
        w_addr[i]=w_alligned_addr+(i*w_no_bytes);
      end
      if(awburst ==2)begin
        if(wb==0)begin
          w_addr[i]=w_alligned_addr+(i)*w_no_bytes;
          if(w_addr[i]==(w_wrap_boundary+(w_no_bytes*w_burst_len)))begin
            w_addr[i]=w_wrap_boundary;
            wb++;
          end
        end
        else
          w_addr[i]=w_start_addr+((i)*w_no_bytes)-(w_no_bytes*w_burst_len);
      end
    end
/*   $display("---------WRITE ADDR----------------------");
   $display("w_no_bytes=%0d",w_no_bytes);
   $display("awaddr=%0d",awaddr);
   for(int i=0;i<w_addr.size();i++)
     $display("w_addr[%0d] is :%0d",i,w_addr[i]);
   $display("w_burst =%0d",awburst);
   $display("awsize =%0d",awsize);
   $display("awlen =%0d",awlen);
   $display("w_wrap_boundary=%0d",w_wrap_boundary);
   $display("w_alligned addr =%0d",w_alligned_addr);
   $display("-------------------------------------------");
   */
  endfunction

 function void r_addr_calc();

    int rb;
  
    for(int i=1;i<r_burst_len;i++)begin
      
      if(arburst ==0)begin
         r_addr[i]=araddr;
      end
      if(arburst ==1)begin
        r_addr[i]=r_alligned_addr+(i*r_no_bytes);
      end
      if(arburst ==2)begin
        if(rb==0)begin
          r_addr[i]=r_alligned_addr+(i)*r_no_bytes;
          if(r_addr[i]==(r_wrap_boundary+(r_no_bytes*r_burst_len)))begin
            r_addr[i]=r_wrap_boundary;
            rb++;
          end
        end
        else
          r_addr[i]=r_start_addr+((i)*r_no_bytes)-(r_no_bytes*r_burst_len);
      end
    end
/*   $display("----------READ ADDR-------------------");
   $display("r_no_bytes=%0d",r_no_bytes);
   $display("araddr=%0d",araddr);
   for(int i=0;i<r_addr.size();i++)
     $display("r_addr[%0d] is :%0d",i,r_addr[i]);
   $display("r_burst =%0d",arburst);
   $display("arsize =%0d",arsize);
   $display("arlen =%0d",arlen);
   $display("r_wrap_boundary=%0d",r_wrap_boundary);
   $display("r_alligned addr =%0d",r_alligned_addr);
   $display("---------------------------------------");
*/
  endfunction


  function void w_strobe_calc();
    int we;
    wstrb=new[w_burst_len];
    for(int i=0;i<w_burst_len;i++)begin
      lbl=w_addr[i]-(int'(w_addr[i]/data_bus_bytes))*data_bus_bytes;
      if(we==0)begin
        ubl=w_alligned_addr+(w_no_bytes-1)-(int'(w_start_addr/data_bus_bytes))*data_bus_bytes;
        we++;
      end
      else begin
        ubl=lbl+w_no_bytes-1;
      end
      //$display("lbl=%0d",lbl);
      //$display("ubl=%0d",ubl);
      for(int j=0;j<4;j++)begin
        
        if((j>=lbl)&&(j<=ubl))
          wstrb[i][j]=1;
        else
          wstrb[i][j]=0;
      end
    end

  //  $display("------------------------strobe-------------------");
 //   for(int i=0;i<wstrb.size();i++)
 //     $display("strb[%0d]=%0b",i,wstrb[i]);
 //   $display("--------------------------------------------------");
  endfunction
/*
function void r_strobe_calc();
    int re;
    rstrb=new[r_burst_len];
    for(int i=0;i<r_burst_len;i++)begin
      lbl=r_addr[i]-(int'(r_addr[i]/data_bus_bytes))*data_bus_bytes;
      if(re==0)begin
        ubl=r_alligned_addr+(r_no_bytes-1)-(int'(r_start_addr/data_bus_bytes))*data_bus_bytes;
        re++;
      end
      else begin
        ubl=lbl+r_no_bytes-1;
      end
      //$display("lbl=%0d",lbl);
      //$display("ubl=%0d",ubl);
      for(int j=0;j<4;j++)begin
        
        if((j>=lbl)&&(j<=ubl))
          rstrb[i][j]=1;
        else
          rstrb[i][j]=0;
      end
    end

    $display("------------------------strobe-------------------");
    for(int i=0;i<rstrb.size();i++)
      $display("strb[%0d]=%0b",i,rstrb[i]);
    $display("--------------------------------------------------");
  endfunction
*/

  function void w_cal_data();
    w_start_addr=awaddr;
   // r_start_addr=araddr;
    w_no_bytes= 2**awsize;
  //  r_no_bytes= 2**arsize;
    w_burst_len=awlen+1;
  //  r_burst_len=arlen+1;
    w_alligned_addr=(int'(w_start_addr/w_no_bytes)*w_no_bytes);
 //   r_alligned_addr=(int'(r_start_addr/r_no_bytes)*r_no_bytes);
    w_wrap_boundary=(int'(w_start_addr/(w_no_bytes*w_burst_len)))*w_no_bytes*w_burst_len;
  //  r_wrap_boundary=(int'(r_start_addr/(r_no_bytes*r_burst_len)))*r_no_bytes*r_burst_len;

    w_addr=new[w_burst_len];
 //   r_addr=new[r_burst_len];

    w_addr[0]=awaddr;
  //  r_addr[0]=araddr;
 endfunction

function void r_cal_data();
 //   w_start_addr=awaddr;
    r_start_addr=araddr;
 //   w_no_bytes= 2**awsize;
    r_no_bytes= 2**arsize;
  //  w_burst_len=awlen+1;
    r_burst_len=arlen+1;
   // w_alligned_addr=(int'(w_start_addr/w_no_bytes)*w_no_bytes);
    r_alligned_addr=(int'(r_start_addr/r_no_bytes)*r_no_bytes);
  //  w_wrap_boundary=(int'(w_start_addr/(w_no_bytes*w_burst_len)))*w_no_bytes*w_burst_len;
    r_wrap_boundary=(int'(r_start_addr/(r_no_bytes*r_burst_len)))*r_no_bytes*r_burst_len;

//    w_addr=new[w_burst_len];
    r_addr=new[r_burst_len];

 //   w_addr[0]=awaddr;
    r_addr[0]=araddr;
 endfunction


  function void post_randomize();
     w_cal_data();
     r_cal_data();
     
     w_addr_calc();
     r_addr_calc();
     w_strobe_calc();
   endfunction 

endclass


