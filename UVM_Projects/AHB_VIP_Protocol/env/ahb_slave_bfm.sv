class ahb_slave_bfm extends uvm_component;
`uvm_component_utils(ahb_slave_bfm)

virtual ahb_if vif;
bit [31:0] mem[*];
bit [31:0] storeaddr[$];
bit waitt;

//-----------new method-------------//
function new(string name="ahb_slave_bfm",uvm_component parent);
	super.new(name,parent);
endfunction

//-------------build_phase------------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(virtual ahb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")

endfunction

task run_phase(uvm_phase phase);

    forever begin
        slave_drive();     
    end
    
endtask

task slave_drive();
    
    bit [31:0] HADDR;
    int adr;
    
    HADDR = vif.s_drv_cb.HADDR;
	@(vif.s_drv_cb);
	wait(vif.HRESETn);
       begin
            vif.HRDATA <= 32'hx;
            vif.s_drv_cb.HREADY <= 1;
            if(vif.s_drv_cb.HWRITE) begin
                if(vif.s_drv_cb.HWDATA>0) begin
                mem[HADDR] = vif.s_drv_cb.HWDATA;
                storeaddr.push_back(HADDR);
                end
                vif.HRDATA <= 32'hx;
            end else if(vif.s_drv_cb.HWRITE==0) begin
                  adr = storeaddr.pop_front();
                vif.HRDATA <= mem[adr];
            end
            else vif.HRDATA <= 32'hx;
            end              
endtask

endclass	
