class slave_driver extends uvm_driver#(apb_xtn);

`uvm_component_utils(slave_driver)
virtual apb_if vif;
slave_bfm sbfm;

function new(string name="slave_driver",uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")

	sbfm=slave_bfm::type_id::create("sbfm",this);
endfunction


endclass

