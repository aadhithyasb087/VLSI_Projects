class ahb_master_bfm extends uvm_component;

`uvm_component_utils(ahb_master_bfm)
ahb_xtn xtn;
virtual ahb_if vif;

//-----------new method-------------//
function new(string name="ahb_master_bfm" ,uvm_component parent);
	super.new(name,parent);
endfunction

//-------------build_phase------------//
function void build_phase(uvm_phase phase);
 	super.build_phase(phase);

	if(!uvm_config_db #(virtual ahb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")
	
	xtn = ahb_xtn::type_id::create("xtn");

endfunction

task reset;
    vif.m_drv_cb.HWRITE <= 1'b0;
	vif.m_drv_cb.HSIZE <= 3'b000;
	vif.m_drv_cb.HBURST <= 3'b000;
	vif.m_drv_cb.HTRANS <= 2'b00;
	vif.m_drv_cb.HWDATA <= 32'b0;
endtask

task master_drive(ahb_xtn xtn);
	int j;
	
	//if(!vif.HRESETn) reset();
	/*do
			@(vif.m_drv_cb);
		while(!vif.HRESETn);*/
	//	@(vif.m_drv_cb);
	
	wait(vif.HRESETn);
	@(vif.m_drv_cb);
	vif.m_drv_cb.HWDATA <= 32'hx;
	vif.m_drv_cb.HWRITE <= xtn.HWRITE;
	vif.m_drv_cb.HSIZE <= xtn.HSIZE;
	vif.m_drv_cb.HBURST <= xtn.HBURST;
	vif.m_drv_cb.HTRANS <= xtn.HTRANS;

	foreach(xtn.HADDR[i])
	begin   
	        
			vif.m_drv_cb.HADDR <= xtn.HADDR[i];
			@(vif.m_drv_cb);
			wait(vif.m_drv_cb.HREADY);
			
			if(vif.m_drv_cb.HWRITE)
				vif.m_drv_cb.HWDATA <= xtn.HWDATA[i];
			else
				vif.m_drv_cb.HWDATA <= 32'hx;
			if(i == xtn.HADDR.size()-1) begin
			  //vif.m_drv_cb.HWRITE <= 1'b0;
			  vif.m_drv_cb.HADDR <= 32'hx;
			  end
		end
		
		/*else
		begin
			vif.m_drv_cb.HADDR <= xtn.HADDR[j];
			if(xtn.HWRITE)
				vif.m_drv_cb.HWDATA <= xtn.HWDATA[j];
			else
				vif.m_drv_cb.HWDATA <= 32'hx;
		end*/
		
		
	
endtask : master_drive
endclass
