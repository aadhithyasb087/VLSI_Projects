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
// Filename   : master_monitor.sv HOST RX
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


class master_monitor extends uvm_monitor;

`uvm_component_utils(master_monitor)
master_bfm mbfm;
virtual apb_if vif;
bit [31:0]mem[*];

uvm_analysis_port #(apb_xtn) monitor_port;

function new(string name="master_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	mbfm=master_bfm::type_id::create("mbfm",this);
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")
	
endfunction


task run_phase(uvm_phase phase);
forever
begin
	apb_xtn xtn1;
	xtn1=apb_xtn::type_id::create("xtn1");
	master_mon(xtn1);
	$display("from master_monitor");
	xtn1.print();
	monitor_port.write(xtn1);
end
endtask

task master_mon(apb_xtn xtn1);
@(posedge vif.pclk)
		if(vif.psel && vif.penable);
			xtn1.paddr=vif.paddr;
			xtn1.pwrite=vif.pwrite;
			wait(vif.pready);
				if(vif.pwrite) begin
	
					mem[vif.paddr]=vif.pwdata;
					$display("mem monMon=%d at time=%t",vif.paddr,$time);
				end else
					vif.prdata=mem[vif.paddr];
	
endtask
endclass

