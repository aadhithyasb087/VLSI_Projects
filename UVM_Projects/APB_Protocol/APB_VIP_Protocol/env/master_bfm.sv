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
// Filename   : master_bfm.sv HOST RX
// Description: USB3.2.
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 07.06.2025 09:30:06
// Design Name:APB
// Module Name:master_bfm
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






class master_bfm extends uvm_component;

`uvm_component_utils(master_bfm)

virtual apb_if vif;
bit [31:0]mem[*];
function new(string name="master_bfm",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")

endfunction

task master_drive(apb_xtn xtn);
 	$display("pwdta=%d",xtn.pwdata);

	vif.psel<=0;
	vif.penable<=0;
	
	@(posedge vif.pclk) //setup
		vif.psel<=1;
		vif.preset<=0;
		vif.paddr<=xtn.paddr;
		vif.pwrite<=xtn.pwrite;
		//$display("pwdta=%d",xtn.pwrite);

		if(xtn.pwrite==1)
		begin
			vif.pwdata<=xtn.pwdata;
			//$display("pwdata=%d",xtn.pwdata);
		end
	
	@(posedge vif.pclk)	//access
	vif.penable<=1;
	
	wait(vif.pready);
		@(posedge vif.pclk);
	        	vif.psel<=0;
			vif.penable<=0;	
endtask 

endclass
