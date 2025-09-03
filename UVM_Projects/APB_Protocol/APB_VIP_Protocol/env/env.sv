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
// Filename   : env.sv HOST RX
// Description: APB
//             
// --------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////
// Company:SION SEMICONDUCTORS PVT Limited 
// Engineer: 
// 
// Create Date: 18.06.2025 09:30:06
// Design Name:APB
// Module Name:env.sv
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


class env extends uvm_env;
`uvm_component_utils(env)
sb sbh;
master_agent m_agt;
slave_agent s_agt;


function new(string name="env",uvm_component parent);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	sbh=sb::type_id::create("sbh",this);

	m_agt=master_agent::type_id::create("m_agt",this);
	s_agt=slave_agent::type_id::create("s_agt",this);
endfunction

function void connect_phase(uvm_phase phase);
	m_agt.m_mon.monitor_port.connect(sbh.fifo_h.analysis_export);
	s_agt.s_mon.monitor_port.connect(sbh.fifo_h1.analysis_export);
endfunction
task run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask

endclass
