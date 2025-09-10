class ahb_master_driver extends uvm_driver #(ahb_xtn);
`uvm_component_utils(ahb_master_driver)

 ahb_master_bfm m_bfm;
 ahb_xtn xtn;

function new(string name="ahb_master_driver",uvm_component parent=null);
	super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	m_bfm = ahb_master_bfm::type_id::create("m_bfm",this); 
endfunction : build_phase

task run_phase(uvm_phase phase);
     
	forever
	begin
	xtn = ahb_xtn::type_id::create("xtn");
	seq_item_port.get_next_item(xtn);
	//$display("from m_drv: time:%0t,reset:%d,addr:%0d,trans:%s,size:%s,burst:%s,write:%0d,data:%0d",$time,xtn.HRESETn,xtn.HADDR[0],xtn.HTRANS.name(),xtn.HSIZE.name(),xtn.HBURST.name(),xtn.HWRITE,xtn.HWDATA[0]);
	m_bfm.master_drive(xtn);
	seq_item_port.item_done();
	end
      
endtask : run_phase

endclass : ahb_master_driver
