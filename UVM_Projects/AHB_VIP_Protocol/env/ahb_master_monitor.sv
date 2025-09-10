class ahb_master_monitor extends uvm_monitor;

`uvm_component_utils(ahb_master_monitor)

virtual ahb_if vif;
ahb_xtn xtn;

uvm_analysis_port #(ahb_xtn) m_ap;


function new(string name="ahb_master_monitor" ,uvm_component parent);
	super.new(name,parent);
	m_ap=new("m_ap",this);
endfunction


function void build_phase(uvm_phase phase);
 	super.build_phase(phase);
	if(!uvm_config_db #(virtual ahb_if)::get(this,"","vif",vif))
	`uvm_fatal("m_mon","cannot access interface ")
	
endfunction

task run_phase(uvm_phase phase);
forever
	begin
	
	collect_data();
	
	end
endtask

function ahb_xtn create_transaction();
	ahb_xtn xtn = ahb_xtn::type_id::create("xtn");
	xtn.HADDR = new[1];
	//xtn.HTRANS = new[1];
	xtn.HWDATA = new[1];
	return xtn;
endfunction : create_transaction

/*task reset;
    xtn.HADDR[0]=vif.m_mon_cb.HADDR;
    xtn.HWRITE = vif.m_mon_cb.HWRITE;
$cast(xtn.HSIZE,  vif.m_mon_cb.HSIZE);
$cast(xtn.HBURST, vif.m_mon_cb.HBURST);
$cast(xtn.HTRANS[0], vif.m_mon_cb.HTRANS);
xtn.HRESETn = 1'b0;
//m_ap.write(xtn);
endtask*/


task collect_data();
	int addr;
	xtn=create_transaction();
	
	//@(vif.m_mon_cb);
	
	wait(vif.HRESETn);
	//@(vif.m_mon_cb);
	xtn.HRESETn = 1'b1;
	addr = vif.m_mon_cb.HADDR;
    xtn.HWRITE = vif.m_mon_cb.HWRITE;
$cast(xtn.HSIZE,  vif.m_mon_cb.HSIZE);
$cast(xtn.HBURST, vif.m_mon_cb.HBURST);
$cast(xtn.HTRANS, vif.m_mon_cb.HTRANS);
			
			//do	
		    @(vif.m_mon_cb);
		    xtn.HADDR[0]= addr;
	        wait(vif.m_mon_cb.HREADY);
	        if(xtn.HWRITE)
	          xtn.HWDATA[0] = vif.m_mon_cb.HWDATA;
	        else
	          xtn.HWDATA[0] = 32'hx;
	        
	        //$display("from m_mon: time:%0t,reset:%d,addr:%0d,addrvif:%0dtrans:%s,size:%s,burst:%s,write:%0d,data:%0d",$time,xtn.HRESETn,xtn.HADDR[0],vif.m_mon_cb.HADDR,xtn.HTRANS.name(),xtn.HSIZE.name(),xtn.HBURST.name(),xtn.HWRITE,xtn.HWDATA[0]);
			m_ap.write(xtn);
			
endtask
endclass
