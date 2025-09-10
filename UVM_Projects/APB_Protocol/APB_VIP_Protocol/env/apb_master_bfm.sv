class apb_master_bfm extends uvm_component;
	`uvm_component_utils(apb_master_bfm)

    apb_xtns xtn;
    virtual apb_intf vif;

	// Constructor
	function new(string name="apb_master_bfm", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("apb_master_bfm","in apb_master_bfm build phase",UVM_NONE)
        xtn = apb_xtns::type_id::create("xtn");
        if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif",vif))
            `uvm_fatal("m_bfm","cannot access interface");
	endfunction

    // Task to drive APB transactions on interface
	virtual task master_drive(apb_xtns xtn);
        //$display("from master bfm");
        //xtn.print();

        // Handle reset condition
	//if(!vif.presetn) begin 
            reset();
	//end
	
       
       	wait(vif.presetn);

        //@(posedge vif.pclk)
       
        @(posedge vif.pclk) // wait for clocking event
        vif.M_DRV.psel   <= 1;
        vif.M_DRV.paddr  <= xtn.paddr;
        vif.M_DRV.pwrite <= xtn.pwrite;
	if(xtn.pwrite==1)
        vif.M_DRV.pwdata <= xtn.pwdata;
        else
        vif.M_DRV.pwdata <= 32'hx;
        
        
        @(posedge vif.pclk)
        vif.M_DRV.penable <= 1;

        wait(vif.M_DRV.pready);  // wait until slave ready
	/*vif.M_DRV.psel    <= 1'b0;
        vif.M_DRV.penable <= 1'b0;
        vif.M_DRV.paddr   <= 32'b0;
        vif.M_DRV.pwrite  <= 1'b0;*/
      //  vif.M_DRV.pwdata  <= 32'b0;
        

        endtask
  
    // Reset procedure: drive default values
    task reset();
        vif.M_DRV.psel    <= 1'b0;
        vif.M_DRV.penable <= 1'b0;
        vif.M_DRV.paddr   <= 32'b0;
        vif.M_DRV.pwrite  <= 1'b0;
        vif.M_DRV.pwdata  <= 32'b0;
    endtask

endclass

