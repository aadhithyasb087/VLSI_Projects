class apb_slave_bfm extends uvm_component;
	`uvm_component_utils(apb_slave_bfm)

	virtual apb_intf vif;
	bit [31:0] mem[0:31];   
	function new(string name="apb_slave_bfm", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
	       	super.build_phase(phase);
		if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif",vif))
			`uvm_fatal("s bfm","cannot access interface");
	endfunction

	
	task slave();
		begin	
		                               
			vif.S_MON.pready <= 0;   // default: slave not ready
			wait(vif.presetn); // wait for reset release
			@(posedge vif.pclk)
			wait(vif.psel);  
			@(posedge vif.pclk)
			wait(vif.penable);

			vif.S_MON.pready <= 1;  // APB: pready asserted during ACCESS phase
			
			if(vif.pwrite) begin
				// Write transfer: store data into slave memory
				mem[vif.paddr] = vif.pwdata;
				$display("SLAVE WRITE: addr=%0h data=%0h", vif.paddr, vif.pwdata);
			end
			else begin
				// Read transfer: return data from memory
				vif.S_MON.prdata <= mem[vif.paddr];
				$display("SLAVE READ : addr=%0h data=%0h", vif.paddr, vif.prdata);
			end	

			@(posedge vif.pclk)
			vif.S_MON.pready <= 0;   // de-assert ready after transfer
			vif.S_MON.pslverr <= 0;  // always OK response
	
		
		end
	endtask

endclass

