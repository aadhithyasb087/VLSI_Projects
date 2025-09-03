// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
// Copyright 2017 (C) SION Semiconductors (P) Ltd. (SION)
//
// This is unpublished, confidential information. All rights reserved.
// This software contains confidential information and trade secrets.
// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WARRANTY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
// SION MAKES NO WARRANTY OF ANY KIND WITH REGARD TO THE USE OF THIS
// SOFTWARE, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
// --------------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DESCRIPTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------------
//
// Filename   : slave_monitor.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:monitor
// Project Name:APB 
// Target Devices: 
// Tool Versions:
// Description: 
// 
// Dependencies: 
// rx_fmt
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



class slave_monitor extends uvm_monitor;

`uvm_component_utils(slave_monitor)
slave_bfm sbfm;
virtual apb_if vif;

uvm_analysis_port #(apb_xtn) monitor_port;
function new(string name="slave_monitor",uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);

endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	sbfm=slave_bfm::type_id::create("sbfm",this);
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")
	
endfunction

task run_phase(uvm_phase phase);
forever
	begin
		apb_xtn xtn2;
		xtn2=apb_xtn::type_id::create("xtn2");
		slave_mon(xtn2);
		$display("From Slave Monitor");
		xtn2.print();
		monitor_port.write(xtn2);
	end
endtask

task slave_mon(apb_xtn xtn2);
	@(posedge vif.pclk)
	@(posedge vif.pclk)
		wait(vif.psel)
		
		xtn2.paddr=vif.paddr;
	
	@(posedge vif.pclk)
		wait(vif.penable && vif.pready)
		if(vif.pwrite)
			xtn2.pwdata=vif.pwdata;
		else
			xtn2.prdata=vif.prdata;

endtask
endclass

