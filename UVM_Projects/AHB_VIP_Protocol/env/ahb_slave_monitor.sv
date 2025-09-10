class ahb_slave_monitor extends uvm_monitor;

`uvm_component_utils(ahb_slave_monitor)

virtual ahb_if vif;
uvm_analysis_port #(ahb_xtn) s_ap;
ahb_xtn xtn;


//-----------new method-------------//
function new(string name="ahb_slave_monitor" ,uvm_component parent);
	super.new(name,parent);
	s_ap=new("s_ap",this);
endfunction

//-------------build_phase------------//
function void build_phase(uvm_phase phase);
 	super.build_phase(phase);

	if(!uvm_config_db #(virtual ahb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")
	
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
//	xtn.HTRANS = new[1];
	xtn.HWDATA = new[1];
	return xtn;
endfunction : create_transaction

/*task reset;
    xtn.HADDR[0]=vif.s_mon_cb.HADDR;
    xtn.HWRITE = vif.s_mon_cb.HWRITE;
$cast(xtn.HSIZE,  vif.s_mon_cb.HSIZE);
$cast(xtn.HBURST, vif.s_mon_cb.HBURST);
$cast(xtn.HTRANS[0], vif.s_mon_cb.HTRANS);
xtn.HRDATA = vif.s_mon_cb.HRDATA;
s_ap.write(xtn);
endtask*/

task collect_data();
	int addr;
	xtn=create_transaction();
	addr = vif.s_mon_cb.HADDR;

	@(vif.s_mon_cb);
	wait(vif.HRESETn);

	xtn.HADDR[0]=addr;
    xtn.HWRITE = vif.s_mon_cb.HWRITE;
$cast(xtn.HSIZE,  vif.s_mon_cb.HSIZE);
$cast(xtn.HBURST, vif.s_mon_cb.HBURST);
$cast(xtn.HTRANS, vif.s_mon_cb.HTRANS);

	        wait(vif.s_mon_cb.HREADY);
	        xtn.HWDATA[0] = vif.s_mon_cb.HWDATA;
	        xtn.HRDATA = vif.s_mon_cb.HRDATA;
	        //$display("from s_m: time:%0t,reset:%d,addr:%0d,trans:%s,size:%s,burst:%s,write:%0d,rdata:%0d",$time,xtn.HRESETn,xtn.HADDR[0],xtn.HTRANS.name(),xtn.HSIZE.name(),xtn.HBURST.name(),xtn.HWRITE,xtn.HRDATA);
	        
			s_ap.write(xtn);
endtask

endclass
