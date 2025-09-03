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
// Filename   : slave_bfm.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:bfm
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



class slave_bfm extends uvm_component;

`uvm_component_utils(slave_bfm)

virtual apb_if vif;
bit  [31:0] mem [*];

function new(string name="slave_bfm",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual apb_if)::get(this,"","vif",vif))
	`uvm_fatal("cant get","have you set it")

endfunction

task run_phase(uvm_phase phase);
forever
begin
	vif.pready<=0;
	wait(!vif.preset);

	slave();
end
endtask

task slave();

	begin	
		@(posedge vif.pclk)
		wait(vif.psel && vif.penable);
		vif.pready<=1;	
		if(vif.pwrite)
			begin
			mem[vif.paddr]=vif.pwdata;
			$display("paddr s %d",vif.paddr);
			$display("pwdata s %d",vif.pwdata);
			end
		else
			begin
			vif.prdata<=mem[vif.paddr];
			$display("prdata from s=%d",vif.prdata);
			end	
		@(posedge vif.pclk)
		vif.pready<=0;
		vif.pslverr<=0;
	
	end
endtask


endclass

